#!/usr/bin/env bash
# Resumen breve del equipo para Arch Linux / Omarchy.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/omarchy-ui.sh"

source /etc/os-release

ui_title 'OMARCHY · Información del sistema'
ui_item '󰣇 Sistema' "${PRETTY_NAME:-Arch Linux}"
ui_item '󰌽 Kernel' "$(uname -r)"
ui_item '󰍛 Equipo' "$(hostname)"
ui_item ' Usuario' "$USER"

ips=$(ip -o -4 addr show scope global 2>/dev/null | awk '{print $2 ": " $4}' | paste -sd ', ' - || true)
ui_item '󰩟 Red' "${ips:-sin conexión IPv4}"

if command -v omarchy-version >/dev/null 2>&1; then
  ui_item ' Omarchy' "$(omarchy-version)"
fi

ui_item '󰄉 Encendido' "$(uptime -p)"
