#!/usr/bin/env bash

set -e

REPO="$HOME/git/DotfileArchOmarchyCipriano"

echo "======================================"
echo " Sincronizando DotfileArchOmarchyCipriano"
echo "======================================"

cd "$REPO"

echo "[1/4] Copiando archivos de configuración..."

# Home
cp "$HOME/.zshrc" "$REPO/home/"

# Zsh
rsync -av --delete \
    "$HOME/.config/zsh/" \
    "$REPO/config/zsh/"

# Hyprland (si existe)
if [ -d "$HOME/.config/hypr" ]; then
    rsync -av --delete \
        "$HOME/.config/hypr/" \
        "$REPO/config/hypr/"
fi

# Kitty (si existe)
if [ -d "$HOME/.config/kitty" ]; then
    rsync -av --delete \
        "$HOME/.config/kitty/" \
        "$REPO/config/kitty/"
fi


echo "[2/4] Estado Git:"
git status


echo "[3/4] Añadiendo cambios..."
git add .


echo "[4/4] Commit y Push"

read -p "Mensaje del commit: " MSG

if [ -z "$MSG" ]; then
    MSG="Actualizar dotfiles"
fi

git commit -m "$MSG"

git push

echo ""
echo "======================================"
echo " Sincronización completada"
echo "======================================"
