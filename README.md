# CorgiBreak

A macOS menu bar app that helps protect your eyes using the **20-20-20 rule** — every 20 minutes, look at something 20 feet away for 20 seconds. With an adorable animated pixel corgi to keep you company during breaks.

<!-- TODO: Add a screenshot or GIF demo here -->
<!-- ![CorgiBreak Screenshot](screenshot.png) -->

## Features

- **20-20-20 Timer** — Automatically reminds you to take a break every 20 minutes
- **Fullscreen Overlay** — A blurred overlay with a countdown timer appears across all screens
- **Animated Pixel Corgi** — 8 unique corgi animations (idle, walk, run, sit, jump, sniff, and more) randomly chosen each break
- **Menu Bar Only** — Lives in the menu bar, stays out of your way
- **Pause / Resume** — Pause the timer when you don't need it
- **Skip Breaks** — Press `Esc` or click Skip to dismiss a break early
- **Multi-Monitor** — Overlay appears on all connected displays
- **Zero Dependencies** — Pure Swift and SwiftUI, no third-party libraries

## Requirements

- macOS 14.0 (Sonoma) or later

## Installation

### Homebrew (recommended)

```bash
brew install --cask VolodymyrM27/corgibreak/corgibreak
```

### Manual Download

Download `CorgiBreak.zip` from the [Releases](https://github.com/VolodymyrM27/CorgiBreak/releases) page, unzip, and drag **CorgiBreak.app** to your Applications folder.

### Build from Source

Requires Xcode 15.0+ and [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```bash
# Clone the repository
git clone https://github.com/VolodymyrM27/CorgiBreak.git
cd CorgiBreak

# Install XcodeGen (if not already installed)
brew install xcodegen

# Generate the Xcode project
xcodegen generate

# Build
xcodebuild \
  -project CorgiBreak.xcodeproj \
  -scheme CorgiBreak \
  -configuration Release \
  -derivedDataPath build \
  build

# Run
open build/Build/Products/Release/CorgiBreak.app
```

## Usage

1. Launch **CorgiBreak** — it appears as an eye icon in the menu bar
2. The timer counts down from 20:00
3. When the timer hits zero, a fullscreen break overlay appears with your pixel corgi
4. Look at something 20 feet away for 20 seconds
5. The overlay dismisses automatically, or press **Esc** to skip

### Menu Bar Options

| Action | Shortcut |
|---|---|
| Pause / Resume | `P` |
| Take a Break Now | `B` |
| Quit | `Q` |

## Project Structure

```
CorgiBreak/
├── Sources/
│   ├── CorgiBreakApp.swift      # App entry point, menu bar setup
│   ├── MenuBarView.swift        # Menu bar dropdown UI
│   ├── TimerManager.swift       # 20-20-20 timer logic
│   ├── OverlayManager.swift     # Fullscreen window management
│   ├── BreakView.swift          # Break overlay UI
│   ├── PixelCorgi.swift         # Animated sprite rendering
│   └── VisualEffectView.swift   # NSVisualEffectView wrapper
├── Resources/
│   ├── CorgiFrames/             # Pre-extracted animation frames
│   ├── Assets.xcassets/         # App icon and assets
│   └── Info.plist
├── scripts/
│   └── extract_frames.py        # Sprite sheet extraction tool
├── project.yml                  # XcodeGen project definition
└── CLAUDE.md                    # AI assistant instructions
```

## Tech Stack

- **Swift 5.9** / **SwiftUI**
- **AppKit** for window management and visual effects
- **XcodeGen** for project file generation
- No third-party dependencies

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
