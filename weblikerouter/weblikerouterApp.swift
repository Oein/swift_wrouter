//
//  weblikerouterApp.swift
//  weblikerouter
//
//  Created by oein on 1/26/25.
//

import SwiftUI

@main
struct weblikerouterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands(content: {
#if os(macOS)
            CommandMenu("Moving", content: {
                Button("Backward") {
                    WRouter_PathManager.shared.backward()
                }
                .keyboardShortcut(.leftArrow, modifiers: [.command])
                Button("Forward") {
                    WRouter_PathManager.shared.forward()
                }
                .keyboardShortcut(.rightArrow, modifiers: [.command])
            })
#endif
        })
    }
}
