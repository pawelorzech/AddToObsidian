# AddToObsidian

A lightweight macOS menu bar app for quickly adding notes to your Obsidian vault using a global keyboard shortcut.

## Features

- **Menu bar app** - Lives in your menu bar, no Dock icon
- **Global keyboard shortcut** - Press `Control + Option + Cmd + O` from any application to open the note window
- **Quick save** - Press `Cmd + Enter` to save your note
- **Cancel with Escape** - Press `Escape` to close without saving
- **YAML frontmatter** - Notes are saved with creation date metadata
- **Automatic file naming** - Files are named with timestamp: `2024-01-19_14-30-45.md`

## Installation

1. Download `AddToObsidian-v1.0.0.zip` from the [Releases](https://github.com/yourusername/AddToObsidian/releases) page
2. Unzip and move `AddToObsidian.app` to your Applications folder
3. Open the app (you may need to right-click and select "Open" on first launch due to Gatekeeper)
4. Grant Accessibility permissions when prompted (required for global keyboard shortcut)

## Setup

1. Right-click the menu bar icon and select **Settings**
2. Click **Select Folder** and choose your Obsidian vault folder
3. Start adding notes with `Control + Option + Cmd + O`

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `⌃⌥⌘O` | Open note window (global) |
| `⌘↩` | Save note |
| `⎋` | Cancel / Close window |

## Note Format

Notes are saved as Markdown files with YAML frontmatter:

```markdown
---
created: 2024-01-19T14:30:45Z
---

Your note content here...
```

## Requirements

- macOS 13.0 (Ventura) or later
- Accessibility permissions (for global keyboard shortcut)

## Building from Source

1. Clone the repository
2. Open `AddToObsidian.xcodeproj` in Xcode 15+
3. Build and run (`Cmd + R`)

## Privacy

- No data is collected or transmitted
- Notes are stored only in your selected Obsidian vault folder
- The app uses security-scoped bookmarks for persistent folder access

## License

MIT License - see [LICENSE](LICENSE) for details
