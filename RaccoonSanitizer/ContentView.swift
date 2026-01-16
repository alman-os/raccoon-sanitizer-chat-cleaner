//
//  ContentView.swift
//  RaccoonSanitizer
//
//  Main GUI - matches the Python reference exactly
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

// Custom UTType for markdown files
extension UTType {
    static var markdown: UTType {
        // Use the system-registered type if available, otherwise create from extension
        UTType("net.daringfireball.markdown") ?? UTType(filenameExtension: "md") ?? .plainText
    }
}

// Simple document for file export
struct MarkdownDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.markdown, .plainText] }

    var text: String

    init(text: String) {
        self.text = text
    }

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(data: data, encoding: .utf8) ?? ""
        } else {
            text = ""
        }
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}

struct ContentView: View {
    @StateObject private var settings = SettingsManager()
    @State private var showSettings = false
    @State private var showExporter = false

    // State
    @State private var rawContent: String = ""
    @State private var cleanedContent: String = ""
    @State private var statusMessage: String = "Click bookmarklet -> copies to clipboard -> paste here!"
    @State private var statusColor: Color = .blue
    @State private var statsText: String = ""

    // Metadata fields (editable)
    @State private var chatTitle: String = ""
    @State private var exportDate: String = ""

    @State private var hasInput = false
    @State private var hasOutput = false
    @State private var onlyHeadersMode = false

    private let cleaner = TranscriptCleaner()

    var body: some View {
        VStack(spacing: 15) {
            // Title
            HStack(spacing: 8) {
                Text("🦝")
                    .font(.largeTitle)
                Text("GPT Chat Transcript Cleanup")
                    .font(.title)
                    .fontWeight(.bold)
            }

            Text("Transform raw chat exports into clean, Obsidian-ready markdown")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Status indicator
            Text(statusMessage)
                .font(.caption)
                .foregroundColor(statusColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.secondary.opacity(0.15))
                .cornerRadius(6)

            // Paste button (primary action)
            Button(action: pasteFromClipboard) {
                Label("Paste from Clipboard", systemImage: "doc.on.clipboard")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            // Metadata fields (Title + Date)
            VStack(spacing: 8) {
                HStack {
                    Text("Title:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(width: 45, alignment: .trailing)
                    TextField("", text: $chatTitle)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(.body, design: .monospaced))
                }
                HStack {
                    Text("Date:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(width: 45, alignment: .trailing)
                    TextField("", text: $exportDate)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(.body, design: .monospaced))
                }
            }
            .padding(.vertical, 4)

            // Button row
            HStack(spacing: 10) {
                // Settings button
                Button(action: { showSettings = true }) {
                    Label("Settings", systemImage: "gear")
                }
                .buttonStyle(.bordered)

                // Only headers toggle
                Toggle(isOn: $onlyHeadersMode) {
                    Label("Only Headers", systemImage: "list.bullet")
                }
                .toggleStyle(.checkbox)
                .padding(.horizontal, 8)

                Spacer()

                // Cleanup button
                Button(action: cleanupTranscript) {
                    Label("Cleanup", systemImage: "sparkles")
                        .frame(minWidth: 100)
                }
                .buttonStyle(.bordered)
                .disabled(!hasInput)

                // Copy All button
                Button(action: copyAllToClipboard) {
                    Label("Copy All", systemImage: "doc.on.doc")
                        .frame(minWidth: 100)
                }
                .buttonStyle(.bordered)
                .disabled(!hasOutput)

                // Export button
                Button(action: { showExporter = true }) {
                    Label("Export", systemImage: "square.and.arrow.down")
                        .frame(minWidth: 100)
                }
                .buttonStyle(.bordered)
                .disabled(!hasOutput)
            }

            // Output section
            HStack {
                Text("Cleaned Output")
                    .font(.headline)
                Spacer()
            }

            // Text output
            TextEditor(text: .constant(cleanedContent))
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(Color.secondary.opacity(0.3), width: 1)

            // Stats label
            if !statsText.isEmpty {
                HStack {
                    Text(statsText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .padding(25)
        .frame(minWidth: 700, minHeight: 550)
        .sheet(isPresented: $showSettings) {
            SettingsView(settings: settings)
        }
        .fileExporter(
            isPresented: $showExporter,
            document: MarkdownDocument(text: assembleFullOutput()),
            contentType: .markdown,
            defaultFilename: chatTitle.isEmpty ? "transcript-cleaned" : chatTitle
        ) { result in
            switch result {
            case .success(let url):
                statusMessage = "Saved to: \(url.lastPathComponent)"
                statusColor = .green
            case .failure(let error):
                statusMessage = "Failed to save: \(error.localizedDescription)"
                statusColor = .red
            }
        }
    }

    // MARK: - Actions

    private func pasteFromClipboard() {
        guard let clipboard = NSPasteboard.general.string(forType: .string) else {
            statusMessage = "No text content in clipboard!"
            statusColor = .red
            return
        }

        if clipboard.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            statusMessage = "Clipboard is empty!"
            statusColor = .red
            return
        }

        // Check if it looks like ChatGPT export format
        if !clipboard.contains("### User") && !clipboard.contains("### ChatGPT") {
            statusMessage = "Warning: Doesn't look like ChatGPT export, but proceeding..."
            statusColor = .orange
        } else {
            statusMessage = "Pasted! Click Cleanup to process."
            statusColor = .green
        }

        rawContent = clipboard

        // Extract metadata (title + date) and populate fields
        if let metadata = cleaner.extractMetadata(clipboard) {
            chatTitle = metadata.title
            exportDate = metadata.date
        } else {
            chatTitle = ""
            exportDate = ""
        }

        // Show raw conversation (metadata stripped, but unformatted) in text box
        // Use regex to strip the metadata header portion
        let metadataPattern = #"^#[^\n]+\n\*Exported:[^\n]+\*\n+---\n+"#
        if let regex = try? NSRegularExpression(pattern: metadataPattern, options: [.anchorsMatchLines]) {
            let range = NSRange(clipboard.startIndex..., in: clipboard)
            cleanedContent = regex.stringByReplacingMatches(in: clipboard, options: [], range: range, withTemplate: "")
        } else {
            cleanedContent = clipboard
        }

        hasInput = true
        hasOutput = false
        statsText = ""
    }

    private func cleanupTranscript() {
        guard !rawContent.isEmpty else { return }

        // Clean with custom labels
        var result = cleaner.cleanTranscript(
            rawMarkdown: rawContent,
            userLabel: settings.userLabel,
            aiLabel: settings.aiLabel
        )

        // Apply headers-only extraction if enabled
        if onlyHeadersMode {
            result = cleaner.extractHeadersOnly(result)
        }

        cleanedContent = result
        hasOutput = true

        // Calculate stats
        let originalLines = rawContent.components(separatedBy: "\n").count
        let cleanedLines = result.components(separatedBy: "\n").count
        let turnCount = result.components(separatedBy: "- ###").count - 1
        let reduction = originalLines > 0 ? Int((1.0 - Double(cleanedLines) / Double(originalLines)) * 100) : 0

        // Build mode indicator
        var modeParts: [String] = []
        if onlyHeadersMode {
            modeParts.append("Headers Only")
        }
        if settings.userLabel != "User" || settings.aiLabel != "ChatGPT" {
            modeParts.append("\(settings.userLabel)/\(settings.aiLabel)")
        }
        let modeIndicator = modeParts.isEmpty ? "" : " | " + modeParts.joined(separator: " + ")

        statsText = "\(turnCount) turns - \(originalLines) -> \(cleanedLines) lines - \(reduction)% smaller\(modeIndicator)"
    }

    /// Assemble full output with metadata header
    private func assembleFullOutput() -> String {
        var parts: [String] = []

        // Add title (with # prefix)
        if !chatTitle.isEmpty {
            parts.append("# \(chatTitle)")
        }

        // Add date (between * *)
        if !exportDate.isEmpty {
            parts.append("*\(exportDate)*")
        }

        // Add formatted content (with blank line + divider if we have metadata)
        if !parts.isEmpty && !cleanedContent.isEmpty {
            parts.append("")  // blank line
            parts.append("---")  // divider
        }
        if !cleanedContent.isEmpty {
            parts.append(cleanedContent)
        }

        return parts.joined(separator: "\n")
    }

    private func copyAllToClipboard() {
        let fullOutput = assembleFullOutput()

        guard !fullOutput.isEmpty else {
            statusMessage = "Nothing to copy!"
            statusColor = .red
            return
        }

        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(fullOutput, forType: .string)

        statusMessage = "Copied to clipboard!"
        statusColor = .green
    }
}

#Preview {
    ContentView()
}
