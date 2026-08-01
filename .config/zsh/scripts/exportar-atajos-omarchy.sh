#!/usr/bin/env bash
set -euo pipefail

default_file="$HOME/atajos-omarchy.txt"

if [[ $# -gt 0 ]]; then
  output_file="$1"
else
  printf '¿Dónde quieres guardar la lista? [%s]: ' "$default_file"
  read -r output_file
  output_file="${output_file:-$default_file}"
fi

# Permite escribir la ruta usando ~/...
output_file="${output_file/#\~/$HOME}"
output_dir="$(dirname -- "$output_file")"

mkdir -p -- "$output_dir"
omarchy-menu-keybindings --print | tee -- "$output_file"

printf '\nLista guardada en: %s\n' "$output_file" >&2

printf '¿Quieres abrirla con nano? [s/N]: '
read -r open_with_nano

case "$open_with_nano" in
  s|S|si|Si|sí|Sí|SI|SÍ)
    nano "$output_file"
    ;;
esac
