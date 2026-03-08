# Codex Desktop for Linux (Fork-Ready)

Run [OpenAI Codex Desktop](https://openai.com/codex/) on Linux from a reproducible fork.

This repository converts the official macOS `Codex.dmg` into a Linux-runnable Electron app, installs a robust desktop launcher, and includes a background maintenance flow so installs are not piecemeal.

## What this fork adds

- Deterministic Linux repack from upstream DMG.
- Native module rebuild for Linux (`better-sqlite3`, `node-pty`).
- DMG cache refresh mode via `CODEX_REFRESH_DMG=1`.
- Robust launcher with Wayland/X11 flags and startup logging.
- Background maintenance worker (`codex-desktop-maintain`) for periodic update checks.
- Desktop-entry installer that links launcher scripts from this repo.

## Repo layout

- `install.sh`: main repack/install pipeline.
- `bin/codex-desktop`: launcher wrapper used by app menu.
- `bin/codex-desktop-maintain`: background updater/maintenance process.
- `scripts/install-desktop-entry.sh`: installs app-menu entry and symlinked launchers.
- `scripts/fetch-dmg.sh`: quick DMG fetch helper.

## Prerequisites

Install dependencies:

- Node.js 20+
- npm
- python3
- p7zip
- curl
- unzip
- build tools (`make`, `g++`)

### Arch Linux

```bash
sudo pacman -S nodejs npm python p7zip curl unzip base-devel
```

Install Codex CLI:

```bash
npm i -g @openai/codex
```

## Quick start (fresh machine)

```bash
git clone https://github.com/<your-user>/codex-desktop-linux.git ~/.local/opt/codex-desktop
cd ~/.local/opt/codex-desktop
./install.sh
./scripts/install-desktop-entry.sh
```

Then launch `Codex Desktop` from your app menu.

## Updating

### Fast updater path (recommended)

Normal launches run `codex-desktop-maintain` in background. It:

- rate-limits checks (default every 6h),
- fetches/pulls repo updates,
- reruns installer if needed.

Config knobs:

- `CODEX_AUTO_UPDATE=0`: disable background maintenance.
- `CODEX_UPDATE_INTERVAL_SEC=21600`: check interval.
- `CODEX_FORCE_UPDATE=1`: force maintenance now.
- `CODEX_FORCE_REFRESH_EVERY_SEC=604800`: force DMG refresh cadence.

## Live GUI status (no more blind updates)

Open a live dashboard terminal window from app menu:

- `Codex Live Status`

Or run directly:

```bash
codex-desktop-live-status --gui
```

It continuously shows:

- current Codex CLI version vs npm latest,
- repo head/divergence,
- tail of updater log,
- tail of latest launch log.

### Manual update

```bash
cd ~/.local/opt/codex-desktop
git pull --ff-only
CODEX_REFRESH_DMG=1 ./install.sh
./scripts/install-desktop-entry.sh
```

## DMG cache behavior

`install.sh` reuses `Codex.dmg` by default.

Force re-download:

```bash
CODEX_REFRESH_DMG=1 ./install.sh
```

## Launcher behavior

`bin/codex-desktop` writes logs to:

- `~/.local/state/codex-desktop/launch_*.log`
- `~/.local/state/codex-desktop/update.log`

Wayland/X11 switches:

- `CODEX_FORCE_X11=1 codex-desktop`
- `CODEX_OZONE_MODE=force-wayland codex-desktop`
- `CODEX_EXTRA_FLAGS='--disable-gpu' codex-desktop`

## Fork and privacy workflow (GitHub)

If you want to keep this private until public release:

```bash
# from repo root
gh repo edit --visibility private
```

To publish later:

```bash
gh repo edit --visibility public
```

Typical safe push flow:

```bash
git fetch origin
git rebase origin/main
git push origin main
```

## Make sure nothing is piecemeal

Use only repo-managed installers and launchers:

```bash
cd ~/.local/opt/codex-desktop
./scripts/install-desktop-entry.sh
```

This ensures app-menu entries and `~/.local/bin` launchers point to repo files via symlink.

## Troubleshooting

- `Codex CLI not found`:
  - install CLI (`npm i -g @openai/codex`)
  - verify `~/.local/bin/codex` exists.
- Blank window:
  - ensure port `5175` is free: `lsof -i :5175`.
- Startup crash:
  - inspect latest launch log in `~/.local/state/codex-desktop/`.

## Disclaimer

Unofficial community tooling. Codex Desktop is a product of OpenAI. This repo automates local conversion of your own upstream app package.

## License

MIT
