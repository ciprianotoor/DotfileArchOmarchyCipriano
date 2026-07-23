#!/usr/bin/env bash

set -e

REPO="$HOME/git/DotfileArchOmarchyCipriano"
BACKUP="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo "======================================"
echo " Instalador DotfileArchOmarchyCipriano"
echo "======================================"
echo ""

# Verificar ubicación
if [ ! -d "$REPO" ]; then

    echo "Repositorio no encontrado."

    read -p "Ruta del repositorio: " REPO

fi


# Crear backup

echo "Creando backup..."

mkdir -p "$BACKUP"

[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP/"

[ -d "$HOME/.config" ] && \
cp -r "$HOME/.config" "$BACKUP/"


echo "Backup creado:"
echo "$BACKUP"


# Restaurar .zshrc

echo ""
echo "Instalando .zshrc..."

cp "$REPO/home/.zshrc" "$HOME/.zshrc"


# Restaurar .config

echo ""
echo "Instalando configuraciones..."

mkdir -p "$HOME/.config"


rsync -av \
"$REPO/.config/" \
"$HOME/.config/"


# Permisos

echo ""
echo "Ajustando permisos..."

chmod -R u+rw "$HOME/.config"
chmod u+rw "$HOME/.zshrc"


echo ""
echo "======================================"
echo " Instalación terminada"
echo "======================================"
echo ""
echo "Backup:"
echo "$BACKUP"
echo ""

read -p "¿Reiniciar sesión ahora? [s/N]: " RESP

if [[ "$RESP" =~ ^[Ss]$ ]]; then
    exec zsh
fi
