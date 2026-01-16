//
//  TranscriptCleaner.swift
//  RaccoonSanitizer
//
//  Core cleaning logic - translates ChatGPT exports into Obsidian-ready markdown
//

import Foundation

struct ConversationTurn {
    let speaker: String
    var content: [String]
}

struct ChatMetadata {
    var title: String
    var date: String
}

class TranscriptCleaner {

    /// Extract title and date from ChatGPT export header
    /// Returns nil if metadata pattern not found
    func extractMetadata(_ text: String) -> ChatMetadata? {
        // Pattern: # Title - Claude\n*Exported: 2026-01-16T02-55-33*
        let pattern = #"^#\s*(.+?)(?:\s*-\s*Claude)?\n\*Exported:\s*([^\*]+)\*"#

        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }

        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, options: [], range: range) else {
            return nil
        }

        // Extract title (capture group 1)
        guard let titleRange = Range(match.range(at: 1), in: text) else {
            return nil
        }
        let title = String(text[titleRange]).trimmingCharacters(in: .whitespaces)

        // Extract date (capture group 2)
        guard let dateRange = Range(match.range(at: 2), in: text) else {
            return nil
        }
        let rawDate = String(text[dateRange]).trimmingCharacters(in: .whitespaces)

        // Convert date from 2026-01-16T02-55-33 to 2026-01-16 02:55:33
        let friendlyDate = formatDate(rawDate)

        return ChatMetadata(title: title, date: friendlyDate)
    }

    /// Convert date from export format to human-friendly format
    private func formatDate(_ rawDate: String) -> String {
        // Input: 2026-01-16T02-55-33
        // Output: 2026-01-16 02:55:33
        var result = rawDate

        // Replace T with space
        result = result.replacingOccurrences(of: "T", with: " ")

        // Replace dashes in time portion with colons (after the date part)
        // Date part is YYYY-MM-DD (10 chars), then space, then time
        if result.count >= 11 {
            let datePartEnd = result.index(result.startIndex, offsetBy: 10)
            let datePart = String(result[..<datePartEnd])
            var timePart = String(result[datePartEnd...])

            // Replace dashes with colons in time part (skip the leading space)
            timePart = timePart.replacingOccurrences(of: "-", with: ":")

            result = datePart + timePart
        }

        return result
    }

    /// Main cleanup pipeline
    func cleanTranscript(rawMarkdown: String, userLabel: String = "User", aiLabel: String = "ChatGPT") -> String {
        let stripped = stripMetadata(rawMarkdown)
        let turns = parseTurns(stripped)
        let deduped = deduplicateTurns(turns)
        let formatted = formatTurns(deduped, userLabel: userLabel, aiLabel: aiLabel)
        return formatted
    }

    /// Remove title, timestamp, and first separator
    private func stripMetadata(_ text: String) -> String {
        // Pattern: ^#[^\n]+\n\*Exported:[^\n]+\*\n+---\n+
        let pattern = #"^#[^\n]+\n\*Exported:[^\n]+\*\n+---\n+"#

        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines]) else {
            return text
        }

        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
    }

    /// Parse text into conversation turns
    private func parseTurns(_ text: String) -> [ConversationTurn] {
        var turns: [ConversationTurn] = []
        let lines = text.components(separatedBy: "\n")
        var currentTurn: ConversationTurn?

        let speakerPattern = #"^### (User|ChatGPT)$"#
        let speakerRegex = try? NSRegularExpression(pattern: speakerPattern, options: [])

        for line in lines {
            let lineRange = NSRange(line.startIndex..., in: line)

            if let regex = speakerRegex,
               let match = regex.firstMatch(in: line, options: [], range: lineRange),
               let speakerRange = Range(match.range(at: 1), in: line) {

                let speaker = String(line[speakerRange])

                if let turn = currentTurn {
                    turns.append(turn)
                }
                currentTurn = ConversationTurn(speaker: speaker, content: [])

            } else if line == "---" {
                continue
            } else if currentTurn != nil && !line.trimmingCharacters(in: .whitespaces).isEmpty {
                currentTurn?.content.append(line)
            }
        }

        if let turn = currentTurn {
            turns.append(turn)
        }

        return turns
    }

    /// Remove duplicate ChatGPT responses
    private func deduplicateTurns(_ turns: [ConversationTurn]) -> [ConversationTurn] {
        var deduped: [ConversationTurn] = []

        for i in 0..<turns.count {
            let turn = turns[i]
            let prevTurn = i > 0 ? turns[i - 1] : nil
            let prevPrevTurn = i > 1 ? turns[i - 2] : nil

            if turn.speaker == "User" {
                deduped.append(turn)
                continue
            }

            if turn.speaker == "ChatGPT" {
                if prevTurn == nil || prevTurn?.speaker == "User" {
                    deduped.append(turn)
                } else if prevTurn?.speaker == "ChatGPT" && prevPrevTurn?.speaker == "User" {
                    continue
                } else if prevTurn?.speaker == "ChatGPT" && prevPrevTurn?.speaker == "ChatGPT" {
                    continue
                } else {
                    deduped.append(turn)
                }
            }
        }

        return deduped
    }

    /// Format turns with proper indentation
    private func formatTurns(_ turns: [ConversationTurn], userLabel: String, aiLabel: String) -> String {
        var formatted: [String] = []

        let headerPattern = #"^#{1,6}\s"#
        let headerRegex = try? NSRegularExpression(pattern: headerPattern, options: [])

        for turn in turns {
            let speakerName = turn.speaker == "ChatGPT" ? aiLabel : userLabel
            var lines = ["- ### \(speakerName)"]
            var insideHeader = false

            for line in turn.content {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty { continue }

                let trimmedRange = NSRange(trimmed.startIndex..., in: trimmed)
                let isHeader = headerRegex?.firstMatch(in: trimmed, options: [], range: trimmedRange) != nil

                if isHeader {
                    lines.append("\t- \(trimmed)")
                    insideHeader = true
                } else if insideHeader {
                    lines.append("\t\t\(trimmed)")
                } else {
                    lines.append("\t\(trimmed)")
                }
            }

            formatted.append(lines.joined(separator: "\n"))
        }

        return formatted.joined(separator: "\n")
    }

    /// Extract only markdown headers from formatted output
    func extractHeadersOnly(_ formattedText: String) -> String {
        let lines = formattedText.components(separatedBy: "\n")
        var headerLines: [String] = []

        let headerPattern = #"#{1,6}\s"#
        let headerRegex = try? NSRegularExpression(pattern: headerPattern, options: [])

        for line in lines {
            let lineRange = NSRange(line.startIndex..., in: line)
            if headerRegex?.firstMatch(in: line, options: [], range: lineRange) != nil {
                headerLines.append(line)
            }
        }

        return headerLines.joined(separator: "\n")
    }
}
