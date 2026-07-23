#!/usr/bin/env bash
# Estado compacto del equipo Arch Linux / Omarchy.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/omarchy-ui.sh"

source /etc/os-release

pending_updates=$({ pacman -Qu 2>/dev/null || true; } | wc -l | tr -d ' ')
theme=$(omarchy theme current 2>/dev/null || printf 'desconocido')
network=$(ip -o -4 addr show scope global 2>/dev/null | awk '{print $2 ": " $4}' | paste -sd ', ' - || true)

ui_title 'OMARCHY · Estado del sistema'
ui_item '󰣇 Sistema' "${PRETTY_NAME:-Arch Linux}"
ui_item ' Omarchy' "$(omarchy-version 2>/dev/null || printf '?') · $theme"
ui_item '󰌽 Kernel' "$(uname -r)"
ui_item '󰩟 Red' "${network:-sin conexión IPv4}"

if (( pending_updates > 0 )); then
  ui_warning "󰏖 $pending_updates actualizaciones pendientes"
else
  ui_success '󰏖 Sistema actualizado según la base local de pacman'
fi

if command -v tailscale >/dev/null 2>&1 && tailscale ip -4 >/dev/null 2>&1; then
  ui_item '󰖂 Tailscale' "$(tailscale ip -4)"
fi

ui_item '󰄉 Encendido' "$(uptime -p)"
