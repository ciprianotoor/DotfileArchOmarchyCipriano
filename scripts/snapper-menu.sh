#!/usr/bin/env bash
# Gestión manual de instantáneas Snapper para Omarchy.

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/lib/omarchy-ui.sh"

command -v snapper >/dev/null 2>&1 || {
  ui_error 'Snapper no está instalado.'
  exit 1
}

config=${1:-root}

while true; do
  clear
  ui_title "OMARCHY · Snapper ($config)"
  ui_menu_option '1' '󰆧 Listar instantáneas'
  ui_menu_option '2' '󰐕 Crear instantánea manual'
  ui_menu_option '3' '󰆴 Eliminar una instantánea'
  ui_menu_option '4' '󰮄 Ver configuraciones disponibles'
  ui_menu_option '0' '󰗼 Salir'
  read -rp 'Opción: ' option

  case $option in
    1)
      sudo snapper -c "$config" list
      ;;
    2)
      read -rp 'Descripción: ' description
      sudo snapper -c "$config" create --description "${description:-Instantánea manual}"
      ;;
    3)
      sudo snapper -c "$config" list
      read -rp 'Número exacto a eliminar: ' number
      [[ $number =~ ^[0-9]+$ ]] || { ui_error 'Número inválido.'; ui_pause; continue; }
      read -rp "Eliminar la instantánea $number? [s/N]: " confirm
      [[ $confirm =~ ^[sS]$ ]] && sudo snapper -c "$config" delete "$number"
      ;;
    4)
      snapper list-configs
      ;;
    0) exit 0 ;;
    *) echo 'Opción inválida.' ;;
  esac

  ui_pause
done
