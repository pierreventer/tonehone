import Foundation
import SwiftUI
import Combine
import UIKit

@MainActor
final class AppState: ObservableObject {
    struct TonePreset: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let profile: ToneProfile
    }

    @Published var conversations: [Conversation]
    @Published var suggestions: [Suggestion]
    @Published var selectedConversationID: UUID?
    @Published private var contextByConversation: [UUID: String]

    let presets: [TonePreset] = [
        TonePreset(name: "Playful & Flirty", profile: .init(playfulness: 8, formality: 3, forwardness: 7, expressiveness: 8, flirtation: 8)),
        TonePreset(name: "Thoughtful & Deep", profile: .init(playfulness: 3, formality: 6, forwardness: 4, expressiveness: 5, flirtation: 2)),
        TonePreset(name: "Casual & Friendly", profile: .init(playfulness: 5, formality: 2, forwardness: 5, expressiveness: 6, flirtation: 4)),
        TonePreset(name: "Direct & Bold", profile: .init(playfulness: 4, formality: 5, forwardness: 9, expressiveness: 7, flirtation: 5)),
        TonePreset(name: "Professional & Warm", profile: .init(playfulness: 3, formality: 7, forwardness: 5, expressiveness: 4, flirtation: 1))
    ]

    init() {
        let now = Date()
        let person = Person(id: UUID(), name: "Sarah", platform: "Hinge", avatarSymbol: "heart.circle.fill")
        let tone = ToneProfile(playfulness: 7, formality: 3, forwardness: 6, expressiveness: 7, flirtation: 7)
        let messages = [
            Message(id: UUID(), sender: .other, text: "I love hiking! What's your favorite trail?", timestamp: now.addingTimeInterval(-3600)),
            Message(id: UUID(), sender: .user, text: "Runyon Canyon is my usual go-to. Where do you hike?", timestamp: now.addingTimeInterval(-1800))
        ]

        let conversation = Conversation(
            id: UUID(),
            person: person,
            messages: messages,
            toneProfile: tone,
            needsResponse: true,
            lastActivity: now.addingTimeInterval(-600),
            platformBadge: "Hinge",
            unreadCount: 1,
            healthScore: 4
        )

        let ctxMap: [UUID: String] = [conversation.id: ""]
        let ctx = ctxMap[conversation.id] ?? ""
        let initialSuggestions = Self.sampleSuggestions(context: ctx, tone: tone)

        self.conversations = [conversation]
        self.selectedConversationID = conversation.id
        self.contextByConversation = ctxMap
        self.suggestions = initialSuggestions
    }

    var selectedConversation: Conversation? {
        get { conversations.first(where: { $0.id == selectedConversationID }) }
        set {
            guard let newValue = newValue else { return }
            if let idx = conversations.firstIndex(where: { $0.id == newValue.id }) {
                conversations[idx] = newValue
            }
        }
    }

    func selectConversation(_ conversation: Conversation) {
        selectedConversationID = conversation.id
    }

    func binding(for conversationID: UUID) -> Binding<Conversation>? {
        guard let idx = conversations.firstIndex(where: { $0.id == conversationID }) else { return nil }
        return Binding(
            get: { self.conversations[idx] },
            set: { self.conversations[idx] = $0 }
        )
    }

    func sendMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let selectedID = selectedConversationID,
              let idx = conversations.firstIndex(where: { $0.id == selectedID }) else { return }

        let message = Message(id: UUID(), sender: .user, text: trimmed, timestamp: Date())
        conversations[idx].messages.append(message)
        conversations[idx].lastActivity = Date()
        conversations[idx].needsResponse = false
    }

    func useSuggestion(_ text: String, for conversationID: UUID? = nil) {
        let targetID = conversationID ?? selectedConversationID
        guard let id = targetID,
              let idx = conversations.firstIndex(where: { $0.id == id }) else { return }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let message = Message(id: UUID(), sender: .user, text: trimmed, timestamp: Date())
        conversations[idx].messages.append(message)
        conversations[idx].lastActivity = Date()
        conversations[idx].needsResponse = false
    }

    func copySuggestion(_ suggestion: Suggestion) {
        UIPasteboard.general.string = suggestion.text
    }

    func setContext(_ text: String, for conversationID: UUID) {
        contextByConversation[conversationID] = text
    }

    func context(for conversationID: UUID) -> String {
        contextByConversation[conversationID] ?? ""
    }

    func updateTone(_ tone: ToneProfile, for conversationID: UUID) {
        guard let idx = conversations.firstIndex(where: { $0.id == conversationID }) else { return }
        conversations[idx].toneProfile = tone
    }

    func regenerateSuggestions(for conversationID: UUID? = nil) {
        let convoID = conversationID ?? selectedConversationID
        guard let id = convoID,
              let convo = conversations.first(where: { $0.id == id }) else {
            suggestions = Self.sampleSuggestions(context: "", tone: nil)
            return
        }
        let context = contextByConversation[id] ?? ""
        suggestions = Self.sampleSuggestions(context: context, tone: convo.toneProfile)
    }

    private static func sampleSuggestions(context: String, tone: ToneProfile?) -> [Suggestion] {
        let contextLine = context.isEmpty ? "" : " Based on: \"\(context)\""
        let toneHint: String
        if let tone {
            toneHint = " Tone: P\(Int(tone.playfulness))/F\(Int(tone.formality))/Fw\(Int(tone.forwardness))/E\(Int(tone.expressiveness))/Fl\(Int(tone.flirtation))."
        } else {
            toneHint = ""
        }
        return [
            Suggestion(id: UUID(), text: "That's awesome! I usually do Runyon Canyon—are you more of a sunrise or afternoon hiker?", matchScore: 95, rationale: "Builds on hiking, matches playful tone, invites engagement.\(contextLine)\(toneHint)", variant: .question),
            Suggestion(id: UUID(), text: "Love that. We should hit a trail together this week—I've got a spot with a great view.", matchScore: 84, rationale: "More forward, suggests a plan.\(contextLine)\(toneHint)", variant: .bold),
            Suggestion(id: UUID(), text: "Hiking sounds perfect. What kind of terrain do you enjoy most?", matchScore: 90, rationale: "Keeps conversation moving, invites them to share preference.\(contextLine)\(toneHint)", variant: .safe),
            Suggestion(id: UUID(), text: "Teach me your favorite trail—I’ll bring the coffee.", matchScore: 92, rationale: "Playful promise, light escalation.\(contextLine)\(toneHint)", variant: .playful)
        ]
    }
}
