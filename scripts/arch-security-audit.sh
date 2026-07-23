#!/usr/bin/env bash
# Auditoría local de solo lectura para Arch Linux / Omarchy.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/omarchy-ui.sh"

check() {
  ui_item "$1" "$2"
}

ui_title 'OMARCHY · Auditoría local'
pending_updates=$({ pacman -Qu 2>/dev/null || true; } | wc -l | tr -d ' ')
check 'Actualizaciones pendientes' "$pending_updates"

if systemctl is-active --quiet sshd 2>/dev/null; then
  check 'Servidor SSH' 'activo'
else
  check 'Servidor SSH' 'inactivo o no instalado'
fi

if command -v ufw >/dev/null 2>&1; then
  check 'UFW' "$(ufw status 2>/dev/null | head -1 || printf 'sin permisos')"
elif command -v firewall-cmd >/dev/null 2>&1; then
  check 'firewalld' "$(firewall-cmd --state 2>/dev/null || printf 'inactivo')"
else
  check 'Firewall' 'no se detectó UFW ni firewalld'
fi

wheel_users=$(getent group wheel | cut -d: -f4)
check 'Usuarios en wheel' "${wheel_users:-ninguno}"

if [[ -r /etc/ssh/sshd_config ]]; then
  root_login=$(awk 'tolower($1) == "permitrootlogin" { value=$2 } END { print value ? value : "valor predeterminado" }' /etc/ssh/sshd_config)
  password_auth=$(awk 'tolower($1) == "passwordauthentication" { value=$2 } END { print value ? value : "valor predeterminado" }' /etc/ssh/sshd_config)
  check 'SSH PermitRootLogin' "$root_login"
  check 'SSH PasswordAuthentication' "$password_auth"
fi

if command -v tailscale >/dev/null 2>&1; then
  check 'Tailscale' "$(tailscale status --json 2>/dev/null | grep -q '"BackendState":"Running"' && printf activo || printf inactivo)"
fi

echo
ui_success 'Auditoría terminada: no se modificó configuración ni servicios.'
