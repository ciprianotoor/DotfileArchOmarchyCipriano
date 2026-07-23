#!/usr/bin/env bash
# Control mínimo de Tailscale sin parámetros de red específicos de Proxmox.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/omarchy-ui.sh"

command -v tailscale >/dev/null 2>&1 || {
  ui_error 'Tailscale no está instalado. Instálalo con: omarchy pkg install tailscale'
  exit 1
}

ui_title 'OMARCHY · Tailscale'
ui_menu_option '1' '󰖂 Ver estado'
ui_menu_option '2' '󰖂 Conectar o autenticar'
ui_menu_option '3' '󰖂 Desconectar'
read -rp 'Opción: ' option

case $option in
  1)
    tailscale status
    ;;
  2)
    ui_warning 'Se conservará la configuración existente de Tailscale.'
    sudo tailscale up
    ;;
  3)
    sudo tailscale down
    ;;
  *)
    echo 'Opción inválida.'
    exit 1
    ;;
esac
