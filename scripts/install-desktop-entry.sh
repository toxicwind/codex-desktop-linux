#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BIN_DIR="${HOME}/.local/bin"
APP_DIR="${HOME}/.local/share/applications"

mkdir -p "$BIN_DIR" "$APP_DIR"

# Keep launchers sourced from the repo, not piecemeal local copies.
ln -sfn "${ROOT}/bin/codex-desktop" "${BIN_DIR}/codex-desktop"
ln -sfn "${ROOT}/bin/codex-desktop-maintain" "${BIN_DIR}/codex-desktop-maintain"

cat > "${APP_DIR}/codex-desktop-linux.desktop" <<INNER_EOF
[Desktop Entry]
Type=Application
Name=Codex Desktop
Comment=Codex Desktop launcher with background auto-update and robust PATH setup
Exec=${BIN_DIR}/codex-desktop
Terminal=false
Categories=Development;IDE;
StartupNotify=true
INNER_EOF

# Remove old duplicates from previous installs.
rm -f "${APP_DIR}/codex-desktop.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$APP_DIR" >/dev/null 2>&1 || true
fi

echo "Installed launcher:"
echo "  ${APP_DIR}/codex-desktop-linux.desktop"
echo "Linked binaries:"
echo "  ${BIN_DIR}/codex-desktop"
echo "  ${BIN_DIR}/codex-desktop-maintain"
