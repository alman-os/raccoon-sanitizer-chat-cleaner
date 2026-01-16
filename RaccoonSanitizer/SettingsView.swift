//
//  SettingsView.swift
//  RaccoonSanitizer
//
//  Settings dialog for customizing speaker labels
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: SettingsManager
    @Environment(\.dismiss) private var dismiss

    @State private var tempUserLabel: String = ""
    @State private var tempAiLabel: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Customize Speaker Labels")
                .font(.title2)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Your label:")
                        .frame(width: 100, alignment: .trailing)
                    TextField("User", text: $tempUserLabel)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                }

                HStack {
                    Text("AI label:")
                        .frame(width: 100, alignment: .trailing)
                    TextField("ChatGPT", text: $tempAiLabel)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                }
            }

            Text("Labels are saved automatically for next time")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 20) {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Button("Save") {
                    settings.userLabel = tempUserLabel.isEmpty ? "User" : tempUserLabel
                    settings.aiLabel = tempAiLabel.isEmpty ? "ChatGPT" : tempAiLabel
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(30)
        .frame(width: 400, height: 250)
        .onAppear {
            tempUserLabel = settings.userLabel
            tempAiLabel = settings.aiLabel
        }
    }
}

#Preview {
    SettingsView(settings: SettingsManager())
}
