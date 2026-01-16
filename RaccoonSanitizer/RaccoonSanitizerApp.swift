//
//  RaccoonSanitizerApp.swift
//  RaccoonSanitizer
//
//  Main app entry point
//

import SwiftUI

@main
struct RaccoonSanitizerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.automatic)
        .defaultSize(width: 900, height: 750)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}
