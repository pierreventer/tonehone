import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.black, Color(red: 0.08, green: 0.09, blue: 0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 12) {
                    header
                    ConversationList(conversations: appState.conversations, selection: $appState.selectedConversationID)
                        .environmentObject(appState)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("ToneHone")
                    .font(.system(.title, weight: .semibold))
                    .foregroundColor(.white)
                Text("Conversation hub • tone-aware suggestions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                appState.regenerateSuggestions()
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(.vertical, 12)
    }
}

private struct ConversationList: View {
    @EnvironmentObject private var appState: AppState
    let conversations: [Conversation]
    @Binding var selection: UUID?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(conversations) { conversation in
                    NavigationLink(value: conversation.id) {
                        ConversationCard(conversation: conversation, isSelected: selection == conversation.id)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationDestination(for: UUID.self) { id in
            if let binding = appState.binding(for: id) {
                ThreadView(conversation: binding)
                    .environmentObject(appState)
            } else {
                Text("Conversation not found")
            }
        }
    }
}

private struct ConversationCard: View {
    let conversation: Conversation
    let isSelected: Bool

    private var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: conversation.lastActivity, relativeTo: Date())
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(.regularMaterial)
                    .frame(width: 46, height: 46)
                Image(systemName: conversation.person.avatarSymbol)
                    .foregroundStyle(.white)
                    .font(.title3)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(conversation.person.name)
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Text(relativeTime)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 8) {
                    badge(conversation.platformBadge, color: .blue.opacity(0.25))
                    badge("Tone \(conversation.toneProfile.playfulness.rounded().formatted(.number))", color: .purple.opacity(0.25))
                    if conversation.needsResponse {
                        badge("Needs reply", color: .orange.opacity(0.25))
                    }
                    if conversation.unreadCount > 0 {
                        badge("\(conversation.unreadCount)", color: .green.opacity(0.25))
                    }
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private func badge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(color)
            )
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
