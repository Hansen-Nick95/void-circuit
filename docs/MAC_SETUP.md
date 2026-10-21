# Mac setup

Everything you install on the Mac, in order. Plan for about 50 GB of free disk space (mostly Xcode).

## 1. Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. Xcode (Mac App Store)
- Open it once and accept the license.
- In **Xcode → Settings → Components**, install the **iOS platform**.
- In **Xcode → Settings → Accounts**, sign in with your Apple ID. A free ID can install to your own phone
  (builds expire after 7 days). The $99/yr Apple Developer Program is needed later for TestFlight.
- `xcode-select --install` for command-line tools (git, make, clang).

## 3. Godot 4.7.2 (standard build, not .NET)
```bash
brew install --cask godot
/Applications/Godot.app/Contents/MacOS/Godot --version   # should print 4.7.2.stable...
```
If Homebrew gives you a different version, either download 4.7.2 from
https://godotengine.org/download/archive/ or bump `.godot-version` and log it in docs/DECISIONS.md.

In the editor: **Editor → Manage Export Templates → Download and Install**. iOS export needs these.

## 4. VS Code + godot-tools
```bash
brew install --cask visual-studio-code
code --install-extension geequlim.godot-tools
```
In Godot, under **Editor Settings → Text Editor → External**, turn on "Use External Editor", set
Exec Path to `/Applications/Visual Studio Code.app/Contents/MacOS/Electron` and Exec Flags to
`{project} --goto {file}:{line}:{col}`.

## 5. Harness tools
```bash
brew install pipx && pipx ensurepath   # then open a new terminal
brew install gh && gh auth login       # optional, but handy for pulling Claude's branches
curl -fsSL https://claude.ai/install.sh | bash   # Claude Code CLI
```

## 6. Clone and check
```bash
gh repo clone hansen-nick95/void-circuit   # or: git clone git@github.com:hansen-nick95/void-circuit.git
cd void-circuit
make setup     # checks Godot.app version, installs gdtoolkit via pipx
make check     # should end with "All tests passed!"
make shots     # optional: frames in reports/shots/
```
Open the project in Godot: Project Manager → Import → choose `project.godot`.

## 7. First iPhone build (M0.7)
1. Plug in the iPhone, open Xcode and trust the computer. On the phone, turn on
   **Settings → Privacy & Security → Developer Mode** and restart.
2. In Godot: **Project → Export → Add… → iOS**.
   - App Store Team ID: from Xcode → Settings → Accounts → your team (a free "Personal Team" works).
   - Bundle Identifier: `com.hansennick95.voidcircuit` (any unique reverse-DNS name).
   - Export path: `export/ios/VoidCircuit.xcodeproj` (export/ is gitignored).
3. Click **Export Project**, open the generated `.xcodeproj` in Xcode, select your phone, and press Run.
4. Commit the `export_presets.cfg` Godot created. It holds no secrets.

## Running Claude locally
From the repo folder, run `claude`, then paste the kickoff prompt from docs/HANDOFF.md, or just say
"Read CLAUDE.md and docs/HANDOFF.md and continue."
