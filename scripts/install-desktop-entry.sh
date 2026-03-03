#!/usr/bin/env bash
BIN_DIR="${HOME}/.local/bin"
mkdir -p "$BIN_DIR" "${HOME}/.local/share/applications"
cp bin/codex-desktop "$BIN_DIR/codex-desktop"
cat > "${HOME}/.local/share/applications/codex-desktop.desktop" <<INNER_EOF
[Desktop Entry]
Type=Application
Name=Codex Desktop
Exec=$BIN_DIR/codex-desktop
Terminal=false
Categories=Development;
INNER_EOF
