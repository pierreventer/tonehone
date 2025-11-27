import SwiftUI

struct ThreadView: View {
    @EnvironmentObject private var appState: AppState
    @Binding var conversation: Conversation
    @State private var draft: String = ""
    @State private var pastedContext: String = ""
    @FocusState private var focusedField: Field?

    private enum Field {
        case context
        case composer
    }

    private var messages: [Message] { conversation.messages }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 12) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        header
                        ToneProfileStrip(tone: $conversation.toneProfile)
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                            }
                        }
                        contextPasteStrip
                        SuggestionsView(suggestions: appState.suggestions, conversationID: conversation.id)
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                    .padding(.bottom, 80) // space for composer
                }
                .scrollIndicators(.hidden)
                .gesture(
                    DragGesture().onChanged { _ in
                        dismissKeyboard()
                    }
                )

                ComposerBar(text: $draft, onSend: send)
                    .focused($focusedField, equals: .composer)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
            }
        }
        .navigationTitle(conversation.person.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ToneConfigView(conversation: $conversation)
                        .environmentObject(appState)
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            appState.selectConversation(conversation)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(conversation.person.name)
                    .foregroundColor(.white)
                    .font(.headline)
                Text("\(conversation.platformBadge) • Tone tuned")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if conversation.needsResponse {
                Text("Needs reply")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
    }

    private func send() {
        appState.sendMessage(draft)
        draft = ""
    }

    private var contextPasteStrip: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Paste their latest text to tune suggestions")
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(alignment: .top, spacing: 8) {
            TextEditor(text: $pastedContext)
                .font(.body)
                .frame(minHeight: 80, maxHeight: 120)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .focused($focusedField, equals: .context)
            Button {
                appState.setContext(pastedContext, for: conversation.id)
                appState.regenerateSuggestions(for: conversation.id)
                    pastedContext = ""
                    dismissKeyboard()
                } label: {
                    Text("Use")
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .disabled(pastedContext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private extension ThreadView {
    func dismissKeyboard() {
        focusedField = nil
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

private struct MessageBubble: View {
    let message: Message

    var isUser: Bool { message.sender == .user }
    var isAI: Bool { message.sender == .ai }

    var body: some View {
        HStack {
            if isUser { Spacer() }
            VStack(alignment: .leading, spacing: 6) {
                Text(message.text)
                    .foregroundColor(.white)
                    .font(.body)
                Text(message.timestamp, style: .relative)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(bubbleTint.opacity(0.4), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
            if !isUser { Spacer() }
        }
    }

    private var bubbleTint: Color {
        if isUser { return Color.blue }
        if isAI { return Color.purple }
        return Color.white.opacity(0.6)
    }
}

private struct ToneProfileStrip: View {
    @Binding var tone: ToneProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Tone profile")
                    .foregroundColor(.white)
                    .font(.subheadline.weight(.semibold))
                Spacer()
            }
            HStack(spacing: 12) {
                meter(label: "Playfulness", value: tone.playfulness, tint: .orange)
                meter(label: "Formality", value: tone.formality, tint: .blue)
            }
            HStack(spacing: 12) {
                meter(label: "Forwardness", value: tone.forwardness, tint: .pink)
                meter(label: "Expressive", value: tone.expressiveness, tint: .green)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func meter(label: String, value: Double, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(value))/10")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            GeometryReader { proxy in
                let width = proxy.size.width
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(tint.opacity(0.8))
                            .frame(width: width * CGFloat(min(max(value, 0), 10)) / 10)
                    }
                    .frame(height: 8)
            }
            .frame(height: 10)
        }
    }
}

private struct ComposerBar: View {
    @Binding var text: String
    var onSend: () -> Void

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            TextField("Write your reply…", text: $text, axis: .vertical)
                .lineLimit(1...4)
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .foregroundColor(.white)
            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .white)
                    .padding(12)
                    .background(Color.blue.opacity(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.2 : 0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}

#Preview {
    let state = AppState()
    NavigationStack {
        if let first = state.conversations.first,
           let binding = state.binding(for: first.id) {
            ThreadView(conversation: binding)
                .environmentObject(state)
        } else {
            Text("No conversations")
        }
    }
}
