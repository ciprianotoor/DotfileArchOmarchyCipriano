# DotfileArchOmarchyCipriano
Autor: Ciprian Javier Perez Garcia
Fecha:23/07/206
Configuración personal de Arch Linux + Omarchy.

Este repositorio contiene mis archivos de configuración, alias, scripts y ajustes personalizados para mi entorno de trabajo en Linux.

## Contenido

## Entorno

- Distribución: Arch Linux
- Entorno: Omarchy
- Shell: Zsh
- Prompt: Powerlevel10k
- Terminal: Kitty
- WM: Hyprland

## Zsh

Incluye:

- Configuración personalizada de `.zshrc`
- Alias personales
- Herramientas propias
- Funciones Zsh
- Menús personalizados

## Objetivo

Tener una copia versionada de mi entorno Linux para poder restaurarlo fácilmente después de una instalación nueva o aplicarlo en otros equipos.

## Instalación

Clonar el repositorio:

```bash
git clone https://github.com/ciprianotoor/DotfileArchOmarchyCipriano.git
```

### Instalar el tema Mr. Robot en Omarchy

Desde la carpeta donde clonaste el repositorio:

```bash
mkdir -p ~/.config/omarchy/themes

ln -sfn \
  "$PWD/.config/omarchy/themes/mr-robot" \
  ~/.config/omarchy/themes/mr-robot

omarchy theme set mr-robot
```

Para cambiar entre los fondos incluidos:

```bash
omarchy theme bg next
```

La documentación específica del tema está en
[`.config/omarchy/themes/mr-robot/README.md`](.config/omarchy/themes/mr-robot/README.md).

El tema se enlaza desde este repositorio porque el repositorio completo
contiene dotfiles, no es un repositorio de tema independiente para
`omarchy theme install`.
