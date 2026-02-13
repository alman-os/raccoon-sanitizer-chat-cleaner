# 🦝 Raccoon Sanitizer

**Export and clean your AI chat conversations with style.**

A Swift-based macOS app that transforms ChatGPT, Claude, and Gemini conversations into beautiful, organized markdown files. Part of a 3-step pipeline that makes exporting your AI chats effortless.

![app Icon](RaccoonSanitizer/Assets.xcassets/AppIcon.appiconset/256.png)
---

## 📋 Table of Contents

- [🎯 What Does This App Do?](#what-does-this-app-do)
- [📥 Download & Installation](#download--installation)
- [⚠️ Troubleshooting](#troubleshooting)
- [🚀 How to Use](#how-to-use)
- [📂 What Can I Do With Exported Markdowns?](#what-can-i-do-with-exported-markdowns)
- [🔒 Privacy & Transparency](#privacy--transparency)
- [🛠 Technical Details](#technical-details)
- [🐛 Issues or Questions?](#issues-or-questions)

---

## What Does This App Do?

Raccoon Sanitizer is **Step 2** in a complete chat export pipeline:

1. **Bookmarklet** captures your chat structure to clipboard
2. **This App** cleans and formats the markdown with customizable names
3. **Export** to Obsidian, VS Code, or any markdown app

**Key Features:**

- 📋 **Paste from clipboard** — One click to import your captured chat
- 🧹 **Auto-cleanup** — Organizes markdown with proper headers and structure
- ✏️ **Customizable role names** — Change "User" to "Architect" or "Claude" to "My BFF"
- 💾 **Export to markdown** — Save anywhere for use in your PKM system
- 🔍 **Easy navigation** — Special formatting makes long chats scannable
- 🎨 **Supports ChatGPT, Claude, and Gemini** conversations

---

## Download & Installation

### Which Version Do I Need?

- **Apple Silicon (M1/M2/M3)**: [`RaccoonSanitizer_macOS-build_v-1-2_metadata.zip`](https://github.com/alman-os/raccoon-sanitizer-chat-cleaner/blob/main/RaccoonSanitizer_macOS-build_v-1-2_metadata.zip)
- **Intel Mac**: [`RaccoonSanitizer_macOS-intelVentura_v1_1.zip`](https://github.com/alman-os/raccoon-sanitizer-chat-cleaner/blob/main/RaccoonSanitizer_macOS-intelVentura_v1_1.zip)

> **Not sure which chip you have?** Click the Apple menu () → **About This Mac**

### Installation Steps

1. Download the appropriate ZIP file from above
2. Unzip the file (double-click the ZIP)
3. Move the app to your Applications folder (optional but recommended)
4. Open the app — you'll likely see a security warning → [See troubleshooting](#troubleshooting)

---

## Troubleshooting

### "Cannot be opened because it is from an unidentified developer"

**This is normal!** The app isn't signed with an Apple Developer certificate yet (approval in progress).

### Method 1: Right-Click Open (Easiest)

1. **Right-click** (or Control+click) on the Raccoon Sanitizer app
2. Select **"Open"** from the menu
3. Click **"Open"** in the dialog that appears
4. The app will now launch normally every time

### Method 2: Terminal Command

1. Open **Terminal** (Spotlight → type "Terminal")
2. Type this command (replace the path with where you put the app):
```bash
xattr -cr /Applications/RaccoonSanitizer.app
```

3. Press Enter
4. Now double-click the app to open it normally

### Method 3: System Settings

1. Try to open the app (it will be blocked)
2. Go to **System Settings** → **Privacy & Security**
3. Scroll down to see **"RaccoonSanitizer was blocked..."**
4. Click **"Open Anyway"**

---

## How to Use

> **Want the full guide?** Check out the [complete Raccoon Sanitizer tutorial](https://aeolian-guan-53d.notion.site/Raccoon-Sanitizer-ChatGPT-conversations-export-2d118a6631c9808f875ac86a2cd555d3)

### Quick Start

1. Install the bookmarklet (from the guide above)
2. Open your chat (ChatGPT, Claude, or Gemini)
3. Click the bookmarklet — chat is captured to clipboard
4. Open Raccoon Sanitizer app
5. Click **"Paste from Clipboard"**
6. (Optional) Click the settings ⚙️ to customize role names
7. Click **"Cleanup"** to format the markdown
8. Click **"Export"** to save your markdown file

### Customization Example

By default, conversations are formatted as:

- `### User` for your messages
- `### ChatGPT` (or Claude/Gemini) for AI responses

But you can customize these! Open settings and change:

- User → "Architect" or "Designer" or your name
- ChatGPT → "My Assistant" or "BFF" or anything you like

---

## What Can I Do With Exported Markdowns?

- **Obsidian** — Import for your personal knowledge management system
- **VS Code** — View and edit with full markdown support
- **Notion** — Drag and drop the markdown file
- **Notes app** — Open directly on macOS
- **Feed to another AI** — Use your conversations as context in new chats

### Pro Tip: Navigation Trick

Exported files include a special `- ` prefix before headers (`###`, `####`) that makes them:

- Clickable/collapsible in many markdown editors
- Easy to scan when scrolling through long conversations
- Simple to reference specific turns in the conversation

---

## Privacy & Transparency

- **100% local processing** — Nothing is sent to any server
- **Open source** — All code is available in this repository
- **Your data stays yours** — Files are saved wherever you choose

---

## Technical Details

- **Language**: Swift
- **Platform**: macOS (Ventura and later recommended)
- **License**: MIT
- **Version**: 1.2

---

## Issues or Questions?

- **Found a bug?** [Open an issue](https://github.com/alman-os/raccoon-sanitizer-chat-cleaner/issues)
- **Have a suggestion?** [Start a discussion](https://github.com/alman-os/raccoon-sanitizer-chat-cleaner/discussions)
- **Want the full guide?** [Read the Notion tutorial](https://aeolian-guan-53d.notion.site/Raccoon-Sanitizer-ChatGPT-conversations-export-2d118a6631c9808f875ac86a2cd555d3)

---

## Acknowledgments

Created by [@gonzaleshvili](https://twitter.com/gonzaleshvili)

Inspired by the need for a better way to preserve and organize AI conversations.

---

## Coming Soon

- ✅ Apple Developer Program signing (no more security warnings!)
- 📦 Homebrew installation
- 🔄 Batch processing for multiple chats
- 🎨 Custom export templates

---
