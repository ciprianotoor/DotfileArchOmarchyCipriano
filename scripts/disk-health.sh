#!/usr/bin/env bash
# Consulta SMART interactiva y no destructiva para discos locales.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/omarchy-ui.sh"

if ! command -v smartctl >/dev/null 2>&1; then
  ui_error 'Falta smartctl. Instálalo con: sudo pacman -S smartmontools'
  exit 1
fi

mapfile -t disks < <(lsblk -dnpo NAME,TYPE | awk '$2 == "disk" { print $1 }')
(( ${#disks[@]} )) || { echo 'No se detectaron discos.'; exit 1; }

ui_title 'OMARCHY · Salud de discos'
for i in "${!disks[@]}"; do
  ui_menu_option "$((i + 1))" "󰋊 ${disks[i]}"
done

read -rp 'Selecciona un disco: ' selection
[[ $selection =~ ^[0-9]+$ ]] && (( selection >= 1 && selection <= ${#disks[@]} )) || {
  echo 'Selección inválida.'
  exit 1
}
disk=${disks[selection - 1]}

echo
ui_menu_option '1' '󰋊 Revisar estado SMART'
ui_menu_option '2' '󰓩 Iniciar prueba corta'
ui_menu_option '3' '󰓩 Iniciar prueba larga'
read -rp 'Selecciona una acción: ' action

case $action in
  1)
    sudo smartctl -H -A "$disk"
    ;;
  2)
    sudo smartctl -t short "$disk"
    ui_success 'Prueba corta iniciada. Ejecuta este script después para ver el resultado.'
    ;;
  3)
    sudo smartctl -t long "$disk"
    ui_success 'Prueba larga iniciada. Ejecuta este script después para ver el resultado.'
    ;;
  *)
    echo 'Acción inválida.'
    exit 1
    ;;
esac
