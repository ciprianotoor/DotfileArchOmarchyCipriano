#!/usr/bin/env bash

set -e

REPO="$HOME/git/DotfileArchOmarchyCipriano"
GITHUB="https://github.com/ciprianotoor/DotfileArchOmarchyCipriano"

# =========================
# Sincronizar Dotfiles
# =========================

sync_dotfiles() {

    clear

    echo "======================================"
    echo " Sincronizando DotfileArchOmarchyCipriano"
    echo "======================================"
    echo ""

    cd "$REPO"

    echo "Copiando configuraciones..."

    # ZSH
    cp "$HOME/.zshrc" "$REPO/home/"

    rsync -av --delete \
        "$HOME/.config/zsh/" \
        "$REPO/config/zsh/"


    # Hyprland
    if [ -d "$HOME/.config/hypr" ]; then
        mkdir -p "$REPO/config/hypr"

        rsync -av --delete \
            "$HOME/.config/hypr/" \
            "$REPO/config/hypr/"
    fi


    # Kitty
    if [ -d "$HOME/.config/kitty" ]; then
        mkdir -p "$REPO/config/kitty"

        rsync -av --delete \
            "$HOME/.config/kitty/" \
            "$REPO/config/kitty/"
    fi


    echo ""
    echo "Cambios detectados:"
    echo "--------------------------------------"

    git status

    echo ""
    read -p "¿Crear commit? [s/N]: " RESP

    if [[ "$RESP" =~ ^[Ss]$ ]]; then

        git add .

        read -p "Mensaje del commit: " MSG

        if [ -z "$MSG" ]; then
            MSG="Actualizar dotfiles"
        fi

        git commit -m "$MSG"

        echo ""
        echo "Subiendo a GitHub..."
        git push

        echo ""
        echo "Sincronización completada."
    else
        echo "Commit cancelado."
    fi

    read -p "Presione ENTER para continuar..."
}


# =========================
# Menú principal
# =========================

menu() {

while true; do

    clear

    echo "======================================"
    echo " DotfileArchOmarchyCipriano"
    echo "======================================"
    echo ""
    echo "Repositorio:"
    echo "$REPO"
    echo ""
    echo "1) Abrir repositorio en terminal"
    echo "2) Abrir repositorio en archivos"
    echo "3) Abrir GitHub"
    echo "4) Ver estado Git"
    echo "5) Sincronizar cambios"
    echo "6) Salir"
    echo ""

    read -p "Seleccione una opción: " OPCION


    case $OPCION in

        1)
            cd "$REPO"
            exec zsh
            ;;

        2)
            xdg-open "$REPO" >/dev/null 2>&1
            ;;

        3)
            xdg-open "$GITHUB" >/dev/null 2>&1
            ;;

        4)
            cd "$REPO"
            git status
            read -p "ENTER para continuar..."
            ;;

        5)
            sync_dotfiles
            ;;

        6)
            exit 0
            ;;

        *)
            echo "Opción incorrecta"
            sleep 2
            ;;

    esac

done

}


menu
