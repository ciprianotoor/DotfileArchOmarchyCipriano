#!/usr/bin/env bash
# Monta o desmonta medios extraíbles mediante udisks2, sin rutas fijas de Proxmox.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/omarchy-ui.sh"

command -v udisksctl >/dev/null 2>&1 || {
  ui_error 'Falta udisksctl (paquete udisks2).'
  exit 1
}

ui_title 'OMARCHY · Medios extraíbles'
echo 'Dispositivos detectados:'
lsblk -o NAME,TYPE,SIZE,FSTYPE,MOUNTPOINTS
echo
read -rp 'Dispositivo (por ejemplo /dev/sdb1): ' device
[[ -b $device ]] || { echo 'El dispositivo no existe.'; exit 1; }

ui_menu_option '1' '󰉋 Montar'
ui_menu_option '2' '󰆴 Desmontar'
ui_menu_option '3' '󰆲 Apagar o expulsar dispositivo'
read -rp 'Acción: ' action

case $action in
  1) udisksctl mount -b "$device" ;;
  2) udisksctl unmount -b "$device" ;;
  3) udisksctl power-off -b "$device" ;;
  *) echo 'Acción inválida.'; exit 1 ;;
esac
