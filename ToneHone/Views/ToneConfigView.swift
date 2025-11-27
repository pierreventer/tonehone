import SwiftUI

struct ToneConfigView: View {
    @EnvironmentObject private var appState: AppState
    @Binding var conversation: Conversation

    @State private var workingTone: ToneProfile

    init(conversation: Binding<Conversation>) {
        self._conversation = conversation
        self._workingTone = State(initialValue: conversation.wrappedValue.toneProfile)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                presetsStrip
                slidersSection
                previewSection
                applySection
            }
            .padding()
        }
        .background(
            LinearGradient(colors: [.black.opacity(0.9), Color(red: 0.05, green: 0.07, blue: 0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
        .navigationTitle("Tone for \(conversation.person.name)")
    }

    private var presetsStrip: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Presets")
                .foregroundColor(.white)
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(appState.presets) { preset in
                        Button {
                            workingTone = preset.profile
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(preset.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(describe(preset.profile))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    private var slidersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Adjust tone")
                .foregroundColor(.white)
                .font(.headline)
            toneSlider("Playfulness", value: $workingTone.playfulness, tint: .orange)
            toneSlider("Formality", value: $workingTone.formality, tint: .blue)
            toneSlider("Forwardness", value: $workingTone.forwardness, tint: .pink)
            toneSlider("Expressiveness", value: $workingTone.expressiveness, tint: .green)
            toneSlider("Flirtation", value: $workingTone.flirtation, tint: .purple)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func toneSlider(_ label: String, value: Binding<Double>, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(value.wrappedValue))/10")
                    .foregroundStyle(.secondary)
            }
            Slider(value: value, in: 1...10, step: 1)
                .tint(tint)
        }
    }

    private func applyTone() {
        conversation.toneProfile = workingTone
        appState.updateTone(workingTone, for: conversation.id)
        appState.regenerateSuggestions(for: conversation.id)
    }

    private func describe(_ tone: ToneProfile) -> String {
        "P\(Int(tone.playfulness)) F\(Int(tone.formality)) Fw\(Int(tone.forwardness)) E\(Int(tone.expressiveness)) Fl\(Int(tone.flirtation))"
    }

    private var previewText: String {
        """
        Input:
        "Let's do a hike this weekend?"

        Output:
        "\(sampleOutput)"
        """
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Live preview")
                .foregroundColor(.white)
                .font(.headline)
            Text(previewText)
                .foregroundColor(.white)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var applySection: some View {
        VStack {
            Button {
                applyTone()
            } label: {
                Label("Apply to \(conversation.person.name)", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var sampleOutput: String {
        let play = Int(workingTone.playfulness)
        let flrt = Int(workingTone.flirtation)
        let fwd = Int(workingTone.forwardness)
        let expr = Int(workingTone.expressiveness)
        switch (play, flrt, fwd, expr) {
        case (7..., 7..., 6..., 6...):
            return "Love that idea—how about Saturday morning? I know a spot with a killer view, and coffee’s on me. 😄"
        case (1...3, 1...3, 1...5, 1...4):
            return "That sounds nice. Which day works best for you?"
        case (4...6, 4...6, 4...7, 4...7):
            return "Weekend hike sounds great. I’m thinking Saturday—does that fit for you?"
        default:
            return "I’m in for a hike—what time suits you?"
        }
    }
}

#Preview {
    let state = AppState()
    return NavigationStack {
        if let binding = state.binding(for: state.conversations.first!.id) {
            ToneConfigView(conversation: binding)
                .environmentObject(state)
        }
    }
}
