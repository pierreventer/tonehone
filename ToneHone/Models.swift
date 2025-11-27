import Foundation

enum MessageSender: String, Codable {
    case user
    case other
    case ai
}

struct Person: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var platform: String
    var avatarSymbol: String
}

struct Message: Identifiable, Codable, Hashable {
    let id: UUID
    var sender: MessageSender
    var text: String
    var timestamp: Date
}

struct ToneProfile: Codable, Hashable {
    var playfulness: Double
    var formality: Double
    var forwardness: Double
    var expressiveness: Double
    var flirtation: Double
}

enum SuggestionVariant: String, Codable, CaseIterable {
    case safe, bold, playful, question, statement
}

struct Suggestion: Identifiable, Codable, Hashable {
    let id: UUID
    var text: String
    var matchScore: Int
    var rationale: String
    var variant: SuggestionVariant
}

struct Conversation: Identifiable, Codable, Hashable {
    let id: UUID
    var person: Person
    var messages: [Message]
    var toneProfile: ToneProfile
    var needsResponse: Bool
    var lastActivity: Date
    var platformBadge: String
    var unreadCount: Int
    var healthScore: Int
}
