#!/usr/bin/env bash

set -euo pipefail

BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR/.config"

backup_file() {
    local source_path="$1"
    [[ -f "$HOME/$source_path" ]] || return 0
    mkdir -p "$BACKUP_DIR/$(dirname "$source_path")"
    cp -a "$HOME/$source_path" "$BACKUP_DIR/$source_path"
    printf 'OK: %s\n' "$source_path"
}

backup_dir() {
    local source_path="$1"
    [[ -d "$HOME/$source_path" ]] || return 0
    mkdir -p "$BACKUP_DIR/$(dirname "$source_path")"
    cp -a "$HOME/$source_path" "$BACKUP_DIR/$(dirname "$source_path")/"
    printf 'OK: %s/\n' "$source_path"
}

echo "Creando respaldo en: $BACKUP_DIR"
backup_file '.zshrc'
backup_file '.p10k.zsh'
backup_dir '.config/zsh'
backup_dir '.config/hypr'
backup_dir '.config/kitty'

printf '\nRespaldo completado.\n'
printf 'Ubicación: %s\n' "$BACKUP_DIR"
