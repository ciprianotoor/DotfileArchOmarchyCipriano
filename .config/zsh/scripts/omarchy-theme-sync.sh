#!/usr/bin/env bash

set -u

DOTFILES_REPO="${DIR_DOTFILES:-$HOME/git/DotfileArchOmarchyCipriano}"
THEME_REPO="${DIR_MR_ROBOT_THEME:-$HOME/git/omarchy-mr-robot-theme}"
THEME_NAME="mr-robot"

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
UI_LIB="$SCRIPT_DIR/lib/omarchy-ui.sh"
if [[ -f $UI_LIB ]]; then
  # shellcheck source=/dev/null
  source "$UI_LIB"
else
  ui_title() { printf '\n== %s ==\n\n' "$1"; }
  ui_success() { printf '[OK] %s\n' "$1"; }
  ui_warning() { printf '[!] %s\n' "$1"; }
  ui_info() { printf '[INFO] %s\n' "$1"; }
  ui_error() { printf '[ERROR] %s\n' "$1" >&2; }
  ui_pause() { read -r -p 'ENTER para continuar'; }
  ui_menu_option() { printf '%s) %s\n' "$1" "$2"; }
fi

repo_exists() {
  [[ -d $1/.git ]]
}

repo_label() {
  case "$1" in
    "$DOTFILES_REPO") printf 'dotfiles' ;;
    "$THEME_REPO") printf 'tema Mr. Robot' ;;
    *) printf '%s' "$1" ;;
  esac
}

repo_status() {
  local repo=$1
  local label
  label=$(repo_label "$repo")

  if ! repo_exists "$repo"; then
    ui_error "$label no existe o no es un repositorio Git: $repo"
    return 1
  fi

  printf '\n[%s]\n' "$label"
  git -C "$repo" status --short --branch
  printf 'Último commit: '
  git -C "$repo" log -1 --date=short --format='%h %ad %s'
}

pull_repo() {
  local repo=$1
  local label
  label=$(repo_label "$repo")

  if ! repo_exists "$repo"; then
    ui_error "$label no existe: $repo"
    return 1
  fi

  if [[ -n $(git -C "$repo" status --porcelain) ]]; then
    ui_warning "$label tiene cambios locales; se omite el pull para no sobrescribirlos."
    git -C "$repo" status --short
    return 1
  fi

  printf '\nActualizando %s...\n' "$label"
  if git -C "$repo" pull --ff-only; then
    ui_success "$label actualizado."
  else
    ui_error "No se pudo actualizar $label con fast-forward. Revisa ramas o conflictos."
    return 1
  fi
}

refresh_theme() {
  if ! command -v omarchy >/dev/null 2>&1; then
    ui_error 'No se encontró el comando omarchy.'
    return 1
  fi

  omarchy theme refresh
  ui_success "Tema $THEME_NAME reaplicado sin cambiar el fondo."
}

sync_theme_into_dotfiles() {
  if ! repo_exists "$THEME_REPO" || ! repo_exists "$DOTFILES_REPO"; then
    ui_error 'Se necesitan ambos repositorios para sincronizar.'
    return 1
  fi

  if [[ -n $(git -C "$THEME_REPO" status --porcelain) ||
        -n $(git -C "$DOTFILES_REPO" status --porcelain) ]]; then
    ui_warning 'Ambos repositorios deben estar limpios antes de sincronizar.'
    ui_info 'Guarda, confirma o aparta tus cambios locales y vuelve a intentarlo.'
    return 1
  fi

  ui_warning 'Se copiará el tema independiente hacia el repositorio de dotfiles.'
  ui_info 'El repositorio independiente será la fuente del tema mr-robot.'
  ui_info 'Se conservará backgrounds/downloaded/ como carpeta local ignorada.'
  read -r -p '¿Continuar? [s/N]: ' answer
  [[ $answer =~ ^[Ss]$ ]] || { ui_warning 'Sincronización cancelada.'; return 0; }

  rsync -a --delete \
    --exclude='.git/' \
    --exclude='backgrounds/downloaded/' \
    "$THEME_REPO/" \
    "$DOTFILES_REPO/.config/omarchy/themes/$THEME_NAME/"

  ui_success 'Tema copiado al repositorio de dotfiles.'
  git -C "$DOTFILES_REPO" status --short
  refresh_theme
}

pull_all() {
  local failed=0
  pull_repo "$DOTFILES_REPO" || failed=1
  pull_repo "$THEME_REPO" || failed=1
  (( failed == 0 )) && refresh_theme || ui_warning 'No se reaplicó el tema porque hubo un repositorio pendiente.'
}

publish_repo() {
  local repo=$1
  local label
  local message
  label=$(repo_label "$repo")

  if ! repo_exists "$repo"; then
    ui_error "$label no existe: $repo"
    return 1
  fi

  if [[ -z $(git -C "$repo" status --porcelain) ]]; then
    ui_success "$label no tiene cambios locales."
    return 0
  fi

  printf '\nCambios de %s:\n' "$label"
  git -C "$repo" status --short
  read -r -p '¿Preparar y publicar estos cambios? [s/N]: ' answer
  [[ $answer =~ ^[Ss]$ ]] || { ui_warning 'Publicación cancelada.'; return 0; }

  read -r -p 'Mensaje del commit: ' message
  [[ -n $message ]] || message="chore: sync $(date +%Y-%m-%d)"

  git -C "$repo" add -A &&
    git -C "$repo" commit -m "$message" &&
    git -C "$repo" push
}

publish_all() {
  publish_repo "$DOTFILES_REPO"
  publish_repo "$THEME_REPO"
}

while true; do
  clear
  ui_title 'OMARCHY · Sincronización Mr. Robot'
  ui_item 'Dotfiles' "$DOTFILES_REPO"
  ui_item 'Tema' "$THEME_REPO"
  printf '\n'
  ui_menu_option '1' 'Ver estado de ambos repositorios'
  ui_menu_option '2' 'Actualizar ambos desde GitHub'
  ui_menu_option '3' 'Actualizar solo dotfiles'
  ui_menu_option '4' 'Actualizar solo el tema'
  ui_menu_option '5' 'Reaplicar el tema actual'
  ui_menu_option '6' 'Sincronizar tema independiente -> dotfiles'
  ui_menu_option '7' 'Publicar cambios de ambos repositorios'
  ui_menu_option '8' 'Salir'
  printf '\n'
  read -r -p 'Opción: ' option

  case "$option" in
    1)
      repo_status "$DOTFILES_REPO"
      repo_status "$THEME_REPO"
      ui_pause
      ;;
    2)
      pull_all
      ui_pause
      ;;
    3)
      pull_repo "$DOTFILES_REPO"
      ui_pause
      ;;
    4)
      pull_repo "$THEME_REPO"
      refresh_theme
      ui_pause
      ;;
    5)
      refresh_theme
      ui_pause
      ;;
    6)
      sync_theme_into_dotfiles
      ui_pause
      ;;
    7)
      publish_all
      ui_pause
      ;;
    8)
      exit 0
      ;;
    *)
      ui_error 'Opción inválida.'
      sleep 1
      ;;
  esac
done
