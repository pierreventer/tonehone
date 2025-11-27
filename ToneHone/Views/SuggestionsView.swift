import SwiftUI

struct SuggestionsView: View {
    @EnvironmentObject private var appState: AppState
    let suggestions: [Suggestion]
    var conversationID: UUID?
    var onRegenerate: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Suggestions")
                    .foregroundColor(.white)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                if let onRegenerate {
                    Button(action: onRegenerate) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                }
            }
            ForEach(suggestions) { suggestion in
                NavigationLink {
                    SuggestionDetailView(suggestion: suggestion, conversationID: conversationID)
                        .environmentObject(appState)
                } label: {
                    SuggestionCard(suggestion: suggestion)
                        .environmentObject(appState)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct SuggestionCard: View {
    let suggestion: Suggestion
    @EnvironmentObject private var appState: AppState

    private var variantColor: Color {
        switch suggestion.variant {
        case .safe: return .blue.opacity(0.35)
        case .bold: return .pink.opacity(0.35)
        case .playful: return .orange.opacity(0.35)
        case .question: return .purple.opacity(0.35)
        case .statement: return .teal.opacity(0.35)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(suggestion.variant.rawValue.capitalized)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(variantColor)
                    .clipShape(Capsule())
                Spacer()
                Text("\(suggestion.matchScore)% match")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(suggestion.text)
                .foregroundColor(.white)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            Text(suggestion.rationale)
                .foregroundStyle(.secondary)
                .font(.caption)
            HStack {
                Button {
                    appState.copySuggestion(suggestion)
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                        .foregroundColor(.white)
                }
                Spacer()
                HStack(spacing: 4) {
                    Text("Refine")
                        .foregroundColor(.white)
                        .font(.callout)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .padding(10)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

#Preview {
    SuggestionsView(
        suggestions: AppState().suggestions,
        conversationID: nil,
        onRegenerate: {}
    )
    .environmentObject(AppState())
    .padding()
    .background(Color.black)
}
