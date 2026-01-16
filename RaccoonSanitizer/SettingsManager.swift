//
//  SettingsManager.swift
//  RaccoonSanitizer
//
//  Manages persistent settings using UserDefaults
//

import Foundation
import SwiftUI
import Combine

class SettingsManager: ObservableObject {
    private let userLabelKey = "userLabel"
    private let aiLabelKey = "aiLabel"

    @Published var userLabel: String {
        didSet {
            UserDefaults.standard.set(userLabel, forKey: userLabelKey)
        }
    }

    @Published var aiLabel: String {
        didSet {
            UserDefaults.standard.set(aiLabel, forKey: aiLabelKey)
        }
    }

    init() {
        self.userLabel = UserDefaults.standard.string(forKey: userLabelKey) ?? "User"
        self.aiLabel = UserDefaults.standard.string(forKey: aiLabelKey) ?? "ChatGPT"
    }

    func reset() {
        userLabel = "User"
        aiLabel = "ChatGPT"
    }
}
