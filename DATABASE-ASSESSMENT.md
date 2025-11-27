# ToneHone Database Architecture Assessment

## Executive Summary

As the database architect for ToneHone, I've reviewed the PRD and identified critical database design decisions that will impact scalability, performance, and feature delivery. The current schema design is functional but requires significant optimization for production deployment, particularly around JSONB usage, indexing strategy, and handling conversation threads with 500+ messages.

---

## Critical Items (Must Address for MVP)

### 1. Schema Design Improvements

#### Current Issues
- **Over-reliance on JSONB**: The tone_profile and metadata fields use JSONB without proper indexing or constraints
- **Missing critical indexes**: No composite indexes for common query patterns
- **No partitioning strategy**: Messages table will grow rapidly without partitioning

#### Recommended Schema Redesign

```sql
-- Enhanced Users table with proper constraints
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    email_normalized VARCHAR(255) GENERATED ALWAYS AS (lower(email)) STORED,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    subscription_tier VARCHAR(50) NOT NULL DEFAULT 'free'
        CHECK (subscription_tier IN ('free', 'pro', 'enterprise')),
    subscription_expires_at TIMESTAMPTZ,
    credits_remaining INT NOT NULL DEFAULT 0 CHECK (credits_remaining >= 0),
    total_credits_purchased INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    deleted_at TIMESTAMPTZ,

    -- Indexes
    INDEX idx_users_email_normalized (email_normalized),
    INDEX idx_users_subscription (subscription_tier, subscription_expires_at) WHERE is_active = true,
    INDEX idx_users_created (created_at DESC)
);

-- Separate tone_profiles table (normalize JSONB)
CREATE TABLE tone_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    is_preset BOOLEAN NOT NULL DEFAULT false,
    playfulness SMALLINT NOT NULL CHECK (playfulness BETWEEN 1 AND 10),
    formality SMALLINT NOT NULL CHECK (formality BETWEEN 1 AND 10),
    forwardness SMALLINT NOT NULL CHECK (forwardness BETWEEN 1 AND 10),
    expressiveness SMALLINT NOT NULL CHECK (expressiveness BETWEEN 1 AND 10),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Computed column for quick matching
    tone_vector CUBE GENERATED ALWAYS AS
        (cube(ARRAY[playfulness::float, formality::float, forwardness::float, expressiveness::float])) STORED,

    INDEX idx_tone_profiles_user (user_id),
    INDEX idx_tone_profiles_vector (tone_vector) USING gist,
    UNIQUE(user_id, name)
);

-- Enhanced Conversations table
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    person_name VARCHAR(255) NOT NULL,
    platform VARCHAR(50) NOT NULL DEFAULT 'other'
        CHECK (platform IN ('hinge', 'bumble', 'tinder', 'other')),
    tone_profile_id UUID REFERENCES tone_profiles(id) ON DELETE SET NULL,

    -- Denormalized fields for performance
    message_count INT NOT NULL DEFAULT 0,
    last_message_at TIMESTAMPTZ,
    last_their_message_at TIMESTAMPTZ,
    last_user_message_at TIMESTAMPTZ,
    conversation_health_score SMALLINT CHECK (conversation_health_score BETWEEN 1 AND 5),

    -- Metadata as structured columns instead of JSONB
    profile_bio TEXT,
    profile_photos TEXT[], -- Array of S3 URLs
    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    archived_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,

    -- Indexes
    INDEX idx_conversations_user_active (user_id, archived_at) WHERE deleted_at IS NULL,
    INDEX idx_conversations_last_activity (user_id, last_message_at DESC) WHERE archived_at IS NULL,
    INDEX idx_conversations_platform (user_id, platform) WHERE deleted_at IS NULL,
    INDEX idx_conversations_health (conversation_health_score) WHERE archived_at IS NULL
);

-- Partitioned Messages table for scalability
CREATE TABLE messages (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL,
    speaker VARCHAR(10) NOT NULL CHECK (speaker IN ('user', 'them')),
    content TEXT NOT NULL,
    content_tsvector tsvector GENERATED ALWAYS AS (to_tsvector('english', content)) STORED,

    -- Message metadata as columns
    source VARCHAR(20) NOT NULL DEFAULT 'manual'
        CHECK (source IN ('manual', 'ocr', 'imported', 'ai_generated')),
    ocr_confidence FLOAT CHECK (ocr_confidence BETWEEN 0 AND 1),
    is_key_moment BOOLEAN NOT NULL DEFAULT false,
    effectiveness_score SMALLINT CHECK (effectiveness_score BETWEEN 1 AND 5),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    message_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(), -- When message was actually sent

    PRIMARY KEY (conversation_id, created_at, id)
) PARTITION BY RANGE (created_at);

-- Create monthly partitions
CREATE TABLE messages_2025_11 PARTITION OF messages
    FOR VALUES FROM ('2025-11-01') TO ('2025-12-01');

-- Indexes on partitioned table
CREATE INDEX idx_messages_conversation ON messages (conversation_id, message_timestamp DESC);
CREATE INDEX idx_messages_fulltext ON messages USING GIN (content_tsvector);
CREATE INDEX idx_messages_speaker ON messages (conversation_id, speaker, message_timestamp DESC);
CREATE INDEX idx_messages_key_moments ON messages (conversation_id) WHERE is_key_moment = true;
```

### 2. Search Architecture

#### Implement PostgreSQL Full-Text Search

```sql
-- Full-text search configuration
CREATE TEXT SEARCH CONFIGURATION tonehone (COPY = pg_catalog.english);

-- Add custom dictionary for dating terms
CREATE TEXT SEARCH DICTIONARY dating_terms (
    TEMPLATE = synonym,
    SYNONYMS = dating_synonyms
);

ALTER TEXT SEARCH CONFIGURATION tonehone
    ALTER MAPPING FOR asciiword, word
    WITH dating_terms, english_stem;

-- Search function with ranking
CREATE OR REPLACE FUNCTION search_messages(
    p_user_id UUID,
    p_query TEXT,
    p_limit INT DEFAULT 50
) RETURNS TABLE (
    message_id UUID,
    conversation_id UUID,
    person_name VARCHAR,
    content TEXT,
    rank REAL,
    message_timestamp TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id,
        m.conversation_id,
        c.person_name,
        m.content,
        ts_rank(m.content_tsvector, plainto_tsquery('tonehone', p_query)) as rank,
        m.message_timestamp
    FROM messages m
    INNER JOIN conversations c ON c.id = m.conversation_id
    WHERE c.user_id = p_user_id
        AND c.deleted_at IS NULL
        AND m.content_tsvector @@ plainto_tsquery('tonehone', p_query)
    ORDER BY rank DESC, m.message_timestamp DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql STABLE;
```

### 3. Performance Optimization for Large Conversations

#### Implement Pagination and Virtualization Strategy

```sql
-- Optimized message retrieval with cursor-based pagination
CREATE OR REPLACE FUNCTION get_conversation_messages(
    p_conversation_id UUID,
    p_cursor TIMESTAMPTZ DEFAULT NULL,
    p_limit INT DEFAULT 50
) RETURNS TABLE (
    id UUID,
    speaker VARCHAR,
    content TEXT,
    message_timestamp TIMESTAMPTZ,
    source VARCHAR,
    is_key_moment BOOLEAN,
    effectiveness_score SMALLINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id,
        m.speaker,
        m.content,
        m.message_timestamp,
        m.source,
        m.is_key_moment,
        m.effectiveness_score
    FROM messages m
    WHERE m.conversation_id = p_conversation_id
        AND (p_cursor IS NULL OR m.message_timestamp < p_cursor)
    ORDER BY m.message_timestamp DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql STABLE;

-- Message count and analytics cache
CREATE TABLE conversation_analytics (
    conversation_id UUID PRIMARY KEY REFERENCES conversations(id) ON DELETE CASCADE,
    total_messages INT NOT NULL DEFAULT 0,
    user_messages INT NOT NULL DEFAULT 0,
    their_messages INT NOT NULL DEFAULT 0,
    avg_response_time_seconds INT,
    avg_message_length INT,
    last_calculated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Engagement metrics
    reply_rate FLOAT,
    conversation_depth_score SMALLINT CHECK (conversation_depth_score BETWEEN 1 AND 5),
    momentum_indicator VARCHAR(20) CHECK (momentum_indicator IN ('hot', 'warming', 'stable', 'cooling', 'cold')),

    -- Topic analysis (using pg_trgm for similarity)
    top_topics TEXT[],
    effective_message_patterns JSONB,

    INDEX idx_analytics_updated (last_calculated_at)
);

-- Trigger to update analytics asynchronously
CREATE OR REPLACE FUNCTION update_conversation_analytics() RETURNS TRIGGER AS $$
BEGIN
    -- Queue analytics update job
    INSERT INTO job_queue (job_type, payload, scheduled_at)
    VALUES (
        'update_conversation_analytics',
        jsonb_build_object('conversation_id', NEW.conversation_id),
        NOW() + INTERVAL '5 seconds'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_analytics
    AFTER INSERT ON messages
    FOR EACH ROW
    EXECUTE FUNCTION update_conversation_analytics();
```

### 4. Data Retention and Archiving Strategy

```sql
-- Archived conversations table (cold storage)
CREATE TABLE archived_conversations (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    person_name VARCHAR(255),
    platform VARCHAR(50),
    messages_jsonb JSONB NOT NULL, -- Compressed message history
    created_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    INDEX idx_archived_user (user_id, archived_at DESC)
);

-- Archive old conversations function
CREATE OR REPLACE FUNCTION archive_old_conversations() RETURNS void AS $$
DECLARE
    v_conversation RECORD;
BEGIN
    FOR v_conversation IN
        SELECT c.id, c.user_id, c.person_name, c.platform, c.created_at
        FROM conversations c
        WHERE c.last_message_at < NOW() - INTERVAL '90 days'
            AND c.archived_at IS NULL
    LOOP
        -- Archive to cold storage
        INSERT INTO archived_conversations (id, user_id, person_name, platform, messages_jsonb, created_at)
        SELECT
            v_conversation.id,
            v_conversation.user_id,
            v_conversation.person_name,
            v_conversation.platform,
            jsonb_agg(
                jsonb_build_object(
                    'speaker', m.speaker,
                    'content', m.content,
                    'timestamp', m.message_timestamp
                ) ORDER BY m.message_timestamp
            ),
            v_conversation.created_at
        FROM messages m
        WHERE m.conversation_id = v_conversation.id
        GROUP BY v_conversation.id;

        -- Mark as archived
        UPDATE conversations
        SET archived_at = NOW()
        WHERE id = v_conversation.id;

        -- Delete from messages table (partitions will be dropped)
        DELETE FROM messages WHERE conversation_id = v_conversation.id;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Schedule monthly
CREATE EXTENSION IF NOT EXISTS pg_cron;
SELECT cron.schedule('archive-old-conversations', '0 2 1 * *', 'SELECT archive_old_conversations();');
```

---

## High-Priority Items (Should Address for v1.0)

### 1. Connection Pooling and Query Optimization

```javascript
// Database connection configuration
const { Pool } = require('pg');
const pgBouncer = {
    host: process.env.PGBOUNCER_HOST,
    port: 6432,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,

    // Connection pool settings
    max: 20, // Maximum connections
    min: 5,  // Minimum connections
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,

    // Statement timeout for long queries
    statement_timeout: '30s',

    // Enable prepared statements
    prepare: true
};

// Read replica configuration
const readReplica = {
    ...pgBouncer,
    host: process.env.READ_REPLICA_HOST,
    max: 50 // More connections for read-heavy workload
};
```

### 2. Caching Strategy with Redis

```typescript
// Redis caching layer
interface CacheStrategy {
    conversationContext: {
        key: (userId: string, conversationId: string) => string;
        ttl: 1800; // 30 minutes
    };
    toneProfile: {
        key: (profileId: string) => string;
        ttl: 3600; // 1 hour
    };
    userAnalytics: {
        key: (userId: string) => string;
        ttl: 300; // 5 minutes
    };
    aiGenerationHistory: {
        key: (conversationId: string) => string;
        ttl: 86400; // 24 hours
    };
}

// Cache-aside pattern implementation
class ConversationCache {
    async getConversationWithMessages(conversationId: string) {
        const cacheKey = `conv:${conversationId}:messages`;

        // Try cache first
        let data = await redis.get(cacheKey);
        if (data) return JSON.parse(data);

        // Cache miss - fetch from database
        const result = await db.query(`
            SELECT c.*,
                   json_agg(
                       json_build_object(
                           'id', m.id,
                           'speaker', m.speaker,
                           'content', m.content,
                           'timestamp', m.message_timestamp
                       ) ORDER BY m.message_timestamp
                   ) FILTER (WHERE m.id IS NOT NULL) as recent_messages
            FROM conversations c
            LEFT JOIN LATERAL (
                SELECT * FROM messages
                WHERE conversation_id = c.id
                ORDER BY message_timestamp DESC
                LIMIT 50
            ) m ON true
            WHERE c.id = $1
            GROUP BY c.id
        `, [conversationId]);

        // Cache for 30 minutes
        await redis.setex(cacheKey, 1800, JSON.stringify(result));
        return result;
    }
}
```

### 3. Database Monitoring and Alerting

```sql
-- Performance monitoring views
CREATE VIEW v_slow_queries AS
SELECT
    query,
    calls,
    total_time,
    mean_time,
    max_time,
    stddev_time,
    rows
FROM pg_stat_statements
WHERE mean_time > 100 -- Queries taking >100ms
ORDER BY mean_time DESC;

CREATE VIEW v_table_bloat AS
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS total_size,
    pg_size_pretty(pg_relation_size(schemaname||'.'||tablename)) AS table_size,
    ROUND(100 * (pg_total_relation_size(schemaname||'.'||tablename) -
                 pg_relation_size(schemaname||'.'||tablename))::numeric /
                 pg_total_relation_size(schemaname||'.'||tablename), 2) AS bloat_percentage
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

-- Index usage statistics
CREATE VIEW v_index_usage AS
SELECT
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
    CASE
        WHEN idx_scan = 0 THEN 'UNUSED'
        WHEN idx_scan < 100 THEN 'RARELY_USED'
        ELSE 'ACTIVE'
    END AS usage_status
FROM pg_stat_user_indexes
ORDER BY idx_scan;
```

### 4. Backup and Disaster Recovery

```bash
#!/bin/bash
# Automated backup script

# Configuration
BACKUP_DIR="/backups/postgres"
S3_BUCKET="s3://tonehone-backups"
DB_NAME="tonehone"
RETENTION_DAYS=30

# Continuous WAL archiving
cat >> /etc/postgresql/15/main/postgresql.conf << EOF
wal_level = replica
archive_mode = on
archive_command = 'aws s3 cp %p ${S3_BUCKET}/wal/%f'
max_wal_senders = 3
wal_keep_size = 1GB
EOF

# Daily logical backup
pg_dump -Fc -j 4 --no-owner --no-acl \
    -h localhost -U postgres -d ${DB_NAME} \
    -f ${BACKUP_DIR}/tonehone_$(date +%Y%m%d).dump

# Upload to S3 with encryption
aws s3 cp ${BACKUP_DIR}/tonehone_$(date +%Y%m%d).dump \
    ${S3_BUCKET}/daily/ \
    --storage-class STANDARD_IA \
    --server-side-encryption AES256

# Point-in-time recovery setup
cat > /etc/recovery.conf << EOF
restore_command = 'aws s3 cp ${S3_BUCKET}/wal/%f %p'
recovery_target_time = '2025-11-27 12:00:00'
EOF
```

---

## Schema Optimizations and Improvements

### 1. Implement Smart Indexing Strategy

```sql
-- Composite indexes for common query patterns
CREATE INDEX idx_messages_conversation_speaker_time
    ON messages (conversation_id, speaker, message_timestamp DESC);

CREATE INDEX idx_conversations_user_platform_health
    ON conversations (user_id, platform, conversation_health_score)
    WHERE archived_at IS NULL;

-- Partial indexes for active data
CREATE INDEX idx_conversations_needs_response
    ON conversations (user_id, last_their_message_at DESC)
    WHERE last_user_message_at < last_their_message_at
    AND archived_at IS NULL;

-- Covering index for dashboard query
CREATE INDEX idx_conversations_dashboard
    ON conversations (user_id, last_message_at DESC)
    INCLUDE (person_name, platform, message_count, conversation_health_score)
    WHERE archived_at IS NULL;

-- GIN index for JSONB if we keep any
CREATE INDEX idx_ai_generations_options
    ON ai_generations USING GIN (generated_options);
```

### 2. Implement Row-Level Security

```sql
-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- User can only see their own data
CREATE POLICY users_isolation ON users
    FOR ALL USING (auth.uid() = id);

CREATE POLICY conversations_isolation ON conversations
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY messages_isolation ON messages
    FOR ALL USING (
        conversation_id IN (
            SELECT id FROM conversations WHERE user_id = auth.uid()
        )
    );

-- Admin override
CREATE POLICY admin_all ON users
    FOR ALL USING (auth.role() = 'admin');
```

### 3. Optimize JSONB Usage

```sql
-- If keeping JSONB, add proper constraints and indexes
ALTER TABLE conversations
ADD CONSTRAINT valid_tone_profile
CHECK (
    tone_profile IS NULL OR (
        tone_profile ? 'playfulness' AND
        tone_profile ? 'formality' AND
        tone_profile ? 'forwardness' AND
        tone_profile ? 'expressiveness' AND
        (tone_profile->>'playfulness')::int BETWEEN 1 AND 10 AND
        (tone_profile->>'formality')::int BETWEEN 1 AND 10 AND
        (tone_profile->>'forwardness')::int BETWEEN 1 AND 10 AND
        (tone_profile->>'expressiveness')::int BETWEEN 1 AND 10
    )
);

-- Functional indexes on JSONB fields
CREATE INDEX idx_tone_playfulness
    ON conversations ((tone_profile->>'playfulness')::int)
    WHERE tone_profile IS NOT NULL;
```

---

## Performance and Scalability Concerns

### 1. Handle 500+ Message Conversations

```sql
-- Message summarization for long conversations
CREATE TABLE message_summaries (
    conversation_id UUID PRIMARY KEY REFERENCES conversations(id) ON DELETE CASCADE,
    summary_text TEXT,
    key_topics TEXT[],
    message_count_included INT,
    generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    INDEX idx_summaries_generated (generated_at)
);

-- Only fetch recent messages + summary for long threads
CREATE OR REPLACE FUNCTION get_conversation_context(
    p_conversation_id UUID,
    p_recent_count INT DEFAULT 20
) RETURNS TABLE (
    recent_messages JSONB,
    summary TEXT,
    total_message_count INT
) AS $$
BEGIN
    RETURN QUERY
    WITH recent AS (
        SELECT jsonb_agg(
            jsonb_build_object(
                'speaker', speaker,
                'content', content,
                'timestamp', message_timestamp
            ) ORDER BY message_timestamp DESC
        ) as messages
        FROM (
            SELECT speaker, content, message_timestamp
            FROM messages
            WHERE conversation_id = p_conversation_id
            ORDER BY message_timestamp DESC
            LIMIT p_recent_count
        ) r
    ),
    summary AS (
        SELECT summary_text
        FROM message_summaries
        WHERE conversation_id = p_conversation_id
    ),
    counts AS (
        SELECT message_count
        FROM conversations
        WHERE id = p_conversation_id
    )
    SELECT
        recent.messages,
        summary.summary_text,
        counts.message_count
    FROM recent, summary, counts;
END;
$$ LANGUAGE plpgsql STABLE;
```

### 2. Implement Sharding Strategy for Scale

```sql
-- User-based sharding (future-proofing)
CREATE OR REPLACE FUNCTION get_shard_for_user(p_user_id UUID)
RETURNS TEXT AS $$
BEGIN
    -- Simple modulo sharding based on UUID
    RETURN 'shard_' || (hashtext(p_user_id::text) % 4)::text;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Foreign data wrapper setup for sharding
CREATE EXTENSION postgres_fdw;

-- Example shard connection
CREATE SERVER shard_1 FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'shard1.tonehone.internal', port '5432', dbname 'tonehone');
```

### 3. Query Performance Optimization

```sql
-- Materialized view for dashboard
CREATE MATERIALIZED VIEW mv_conversation_dashboard AS
SELECT
    c.id,
    c.user_id,
    c.person_name,
    c.platform,
    c.message_count,
    c.last_message_at,
    c.conversation_health_score,
    tp.playfulness,
    tp.formality,
    tp.forwardness,
    tp.expressiveness,
    CASE
        WHEN c.last_their_message_at > c.last_user_message_at
        THEN true ELSE false
    END as needs_response,
    ca.reply_rate,
    ca.momentum_indicator
FROM conversations c
LEFT JOIN tone_profiles tp ON c.tone_profile_id = tp.id
LEFT JOIN conversation_analytics ca ON c.id = ca.conversation_id
WHERE c.archived_at IS NULL;

CREATE UNIQUE INDEX idx_mv_dashboard_id ON mv_conversation_dashboard (id);
CREATE INDEX idx_mv_dashboard_user ON mv_conversation_dashboard (user_id);

-- Refresh strategy
CREATE OR REPLACE FUNCTION refresh_dashboard_view() RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_conversation_dashboard;
END;
$$ LANGUAGE plpgsql;

-- Refresh every 5 minutes
SELECT cron.schedule('refresh-dashboard', '*/5 * * * *', 'SELECT refresh_dashboard_view();');
```

---

## Migration Strategy and Version Control

### 1. Database Migration Framework

```typescript
// Use Prisma Migrate or similar
// migrations/001_initial_schema.sql
-- Migration: 001_initial_schema
-- Description: Initial database schema for ToneHone

BEGIN;

-- Create all tables
-- Add indexes
-- Add constraints

COMMIT;

// migrations/002_add_partitioning.sql
-- Migration: 002_add_partitioning
-- Description: Convert messages to partitioned table

BEGIN;

-- Create new partitioned table
-- Copy data
-- Swap tables
-- Drop old table

COMMIT;
```

### 2. Zero-Downtime Migration Strategy

```sql
-- Use CREATE INDEX CONCURRENTLY for production
CREATE INDEX CONCURRENTLY idx_messages_new ON messages (...);

-- Blue-green deployments with database
-- 1. Create new schema version
CREATE SCHEMA tonehone_v2;

-- 2. Replicate data
-- 3. Switch application to new schema
-- 4. Drop old schema after verification
```

### 3. Data Validation and Integrity

```sql
-- Add check constraints progressively
ALTER TABLE messages
ADD CONSTRAINT check_content_length
CHECK (char_length(content) BETWEEN 1 AND 10000) NOT VALID;

-- Validate in background
ALTER TABLE messages VALIDATE CONSTRAINT check_content_length;

-- Regular integrity checks
CREATE OR REPLACE FUNCTION verify_data_integrity() RETURNS TABLE (
    check_name TEXT,
    status TEXT,
    details TEXT
) AS $$
BEGIN
    -- Check for orphaned messages
    RETURN QUERY
    SELECT
        'orphaned_messages'::TEXT,
        CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END,
        'Found ' || COUNT(*) || ' orphaned messages'
    FROM messages m
    LEFT JOIN conversations c ON m.conversation_id = c.id
    WHERE c.id IS NULL;

    -- Check for invalid tone profiles
    RETURN QUERY
    SELECT
        'invalid_tone_profiles'::TEXT,
        CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END,
        'Found ' || COUNT(*) || ' invalid tone profiles'
    FROM tone_profiles
    WHERE playfulness NOT BETWEEN 1 AND 10
        OR formality NOT BETWEEN 1 AND 10
        OR forwardness NOT BETWEEN 1 AND 10
        OR expressiveness NOT BETWEEN 1 AND 10;
END;
$$ LANGUAGE plpgsql;
```

---

## Recommendations Summary

### Immediate Actions (Week 1)
1. Normalize JSONB fields into proper columns with constraints
2. Implement partitioning for messages table
3. Add comprehensive indexing strategy
4. Set up connection pooling with PgBouncer
5. Implement basic caching with Redis

### Short-term (Month 1)
1. Set up read replicas for scaling reads
2. Implement full-text search properly
3. Add materialized views for dashboard
4. Set up automated backups and WAL archiving
5. Implement row-level security

### Medium-term (Quarter 1)
1. Implement message summarization for long conversations
2. Add conversation analytics pipeline
3. Set up monitoring and alerting
4. Implement archiving strategy
5. Plan sharding strategy for future scale

### Long-term Considerations
1. Evaluate need for time-series database for analytics
2. Consider Elasticsearch for advanced search features
3. Plan for geographic distribution (multi-region)
4. Implement event sourcing for conversation history
5. Evaluate graph database for relationship insights

---

## Cost Projections

### Database Infrastructure Costs (Monthly)

**PostgreSQL (Primary)**
- Supabase Pro: $25/month (8GB, 2 vCPUs)
- Scaling to: $399/month (32GB, 8 vCPUs) by Month 6

**Redis Cache**
- Upstash: $0.2 per 100K commands
- Estimated: $50-100/month at scale

**Backup Storage**
- S3 Storage: $0.023 per GB
- WAL Archives: ~$20/month
- Daily Backups: ~$30/month

**Read Replica (When needed)**
- Additional $199/month per replica

**Total Initial: ~$100/month**
**Total at Scale (10K users): ~$750/month**

---

## Risk Mitigation

### Data Loss Prevention
- Continuous WAL archiving
- Daily logical backups
- Point-in-time recovery capability
- Multi-region backup storage

### Performance Degradation
- Proactive monitoring and alerting
- Automatic index recommendations
- Query performance tracking
- Capacity planning based on metrics

### Security Risks
- Encryption at rest and in transit
- Row-level security policies
- Regular security audits
- PII data handling compliance

---

## Conclusion

The ToneHone database architecture requires significant optimization to handle the expected scale and performance requirements. The current schema design is a good starting point but needs normalization, proper indexing, and partitioning strategies. By implementing these recommendations in phases, ToneHone can build a robust, scalable database infrastructure that supports rapid growth while maintaining excellent performance for users managing hundreds of conversations with thousands of messages.

Priority should be given to the critical items that directly impact user experience: search performance, message retrieval speed, and data integrity. The proposed architecture will support the target of 10,000 concurrent users and 1M+ API requests per day while maintaining sub-second response times for most operations.