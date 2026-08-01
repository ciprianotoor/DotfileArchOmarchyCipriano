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

# Verificar componentes requeridos por .zshrc y por los scripts de mantenimiento.
echo ""
echo "Verificando plugins y utilidades..."

required_paths=(
    "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    "$HOME/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
    "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "$HOME/.config/zsh/scripts/lib/omarchy-ui.sh"
)

missing=0
for required_path in "${required_paths[@]}"; do
    if [ ! -f "$required_path" ]; then
        echo "FALTA: $required_path"
        missing=1
    else
        echo "OK:    $required_path"
    fi
done

if [ "$missing" -ne 0 ]; then
    echo ""
    echo "Error: faltan componentes requeridos. Instalación cancelada."
    exit 1
fi


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
