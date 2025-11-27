import SwiftUI

struct SuggestionDetailView: View {
    @EnvironmentObject private var appState: AppState
    let suggestion: Suggestion
    let conversationID: UUID?

    @State private var editedText: String

    init(suggestion: Suggestion, conversationID: UUID?) {
        self.suggestion = suggestion
        self.conversationID = conversationID
        _editedText = State(initialValue: suggestion.text)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Refine suggestion")
                .font(.headline)
                .foregroundColor(.white)

            TextEditor(text: $editedText)
                .font(.body)
                .foregroundColor(.white)
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .frame(minHeight: 180)

            HStack {
                Button {
                    appState.copySuggestion(Suggestion(id: suggestion.id, text: editedText, matchScore: suggestion.matchScore, rationale: suggestion.rationale, variant: suggestion.variant))
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }

                Button {
                    appState.useSuggestion(editedText, for: conversationID)
                } label: {
                    Label("Use & add to thread", systemImage: "arrow.down.doc")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial)
        .ignoresSafeArea()
        .navigationTitle("Refine")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let state = AppState()
    return NavigationStack {
        SuggestionDetailView(suggestion: state.suggestions.first!, conversationID: state.conversations.first?.id)
            .environmentObject(state)
    }
}
