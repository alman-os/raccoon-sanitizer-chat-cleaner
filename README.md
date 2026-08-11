# 🦝 Raccoon Sanitizer

<table>
  <tr>
    <td>
      <a href="https://youtu.be/r496TMPb7xs">
        <img src="https://github.com/alman-os/raccoon-sanitizer-chat-cleaner/blob/main/yt-thumbnail.png" alt="Watch the video" width="300">
      </a>
    </td>
    <td>
      <h3>Export ChatGPT/Claude conversations to .md (editable turns, Obsidian friendly) (Free Download)</h3>
      <p> 👈🏻 Watch the Youtube Explainer here!
</p>
    </td>
  </tr>
</table>

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
- 🧠 **Resilient parsing** — Keeps split-up replies, preserves code blocks, and only collapses genuine duplicates (no more lost messages)
- 🎨 **Supports ChatGPT, Claude, and Gemini** conversations

---

## Download & Installation

### One Download — Works on Every Mac

The app now ships as a **single universal build**: the same `.dmg` runs natively on both **Apple Silicon (M1/M2/M3/M4)** and **Intel** Macs. No more figuring out which chip you have.

👉 **[Download the latest `.dmg` from the Releases page](https://github.com/alman-os/raccoon-sanitizer-chat-cleaner/releases/latest)**

### Installation Steps

1. Download the latest `.dmg` from the [Releases page](https://github.com/alman-os/raccoon-sanitizer-chat-cleaner/releases/latest)
2. Double-click the `.dmg` to open it
3. Drag **RaccoonSanitizer** into your **Applications** folder
4. Open the app — it should launch normally (it's now signed & notarized 🎉)

---

## Troubleshooting

### The app is now signed & notarized ✅

As of the current release, Raccoon Sanitizer is **signed with an Apple Developer ID and notarized by Apple**. That means it should open like any other app — just double-click, no security warnings, no Terminal commands needed.

### Edge cases (older downloads / strict setups)

If you grabbed an **older, pre-notarization build**, or macOS still complains for some reason, any one of these will get you running:

**Right-click open (easiest)**
1. **Right-click** (or Control+click) the Raccoon Sanitizer app
2. Choose **"Open"**, then **"Open"** again in the dialog
3. It'll launch normally every time after that

**System Settings**
1. Try to open the app
2. Go to **System Settings** → **Privacy & Security**
3. Scroll to **"RaccoonSanitizer was blocked…"** and click **"Open Anyway"**

**Terminal (legacy fallback)**
```bash
xattr -cr /Applications/RaccoonSanitizer.app
```
> Only needed for old unsigned builds — the current notarized release shouldn't require this.

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
- **Build**: Universal binary (Apple Silicon + Intel), signed & notarized with an Apple Developer ID
- **License**: MIT

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

- ✅ Apple Developer signing & notarization (done — no more security warnings!)
- ✅ Universal build (one download for Apple Silicon + Intel)
- 📦 Homebrew installation
- 🔄 Batch processing for multiple chats
- 🎨 Custom export templates

---
