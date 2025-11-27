//
//  ToneHoneApp.swift
//  ToneHone
//
//  Created by Pierre Venter on 27/11/2025.
//

import SwiftUI

@main
struct ToneHoneApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
