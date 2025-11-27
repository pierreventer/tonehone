import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        RootView()
            .environmentObject(appState)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
