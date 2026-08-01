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

### Instalar el tema Mr. Robot directamente

El tema tiene ahora un repositorio independiente, preparado para Omarchy:

```bash
omarchy theme install \
  https://github.com/ciprianotoor/omarchy-mr-robot-theme.git
```

### Usar el tema desde este repositorio de dotfiles

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

El repositorio independiente del tema está disponible en
<https://github.com/ciprianotoor/omarchy-mr-robot-theme>.

### Sincronizar el tema y los repositorios

El menú `temasync` actualiza o publica el repositorio de dotfiles y el
repositorio independiente del tema:

```bash
source ~/.zshrc
temasync
```

El menú permite ver estados, actualizar uno o ambos repositorios, reaplicar
el tema y publicar cambios. La opción `6` copia el tema independiente hacia
`.config/omarchy/themes/mr-robot` del repositorio de dotfiles; pide confirmación
y conserva `backgrounds/downloaded/`. Después de esa copia, usa la opción `7`
para publicar los cambios.

Puedes cambiar las rutas si tus repositorios están en otra ubicación:

```bash
DIR_DOTFILES="$HOME/git/DotfileArchOmarchyCipriano" \
DIR_MR_ROBOT_THEME="$HOME/git/omarchy-mr-robot-theme" \
  temasync
```

## Preguntas frecuentes y limitaciones

### ¿Qué instala este repositorio?

Instala configuraciones, alias, scripts y ajustes pensados para el entorno
personal del autor. No es un instalador universal ni una imagen completa de
Arch Linux u Omarchy.

### ¿Qué necesito?

Se recomienda una instalación actual de Arch Linux con Omarchy, permisos de
usuario sobre `~/.config`, Git y las aplicaciones que cada configuración
utiliza. Algunas funciones dependen de programas opcionales como Zsh, Kitty,
Hyprland, Waybar, Neovim, tmux, `playerctl`, `brightnessctl` o herramientas
propias de Omarchy.

### ¿Puede romper mi configuración?

Sí. Los archivos de configuración pueden reemplazar, enlazar o cambiar el
comportamiento de programas del usuario. Haz una copia de seguridad y revisa
los scripts antes de ejecutarlos. El autor no garantiza compatibilidad con
otras distribuciones, versiones, hardware, monitores, shells o diseños de
teclado.

### ¿Qué ocurre al actualizar Omarchy?

Omarchy puede cambiar sus rutas, plantillas, comandos o formatos. Los archivos
administrados por Omarchy pueden ser reemplazados por una actualización. No
se debe modificar `~/.local/share/omarchy/`; las personalizaciones deben vivir
en `~/.config/` o en los directorios de usuario documentados por Omarchy.

### ¿Este repositorio incluye credenciales?

No debería incluir contraseñas, tokens, claves privadas ni datos personales.
Antes de publicar cambios, revisa el diff y evita añadir secretos. Si un
secreto se publica por accidente, revócalo y reemplázalo inmediatamente.

## Licencias, terceros y exclusiones

La licencia MIT de [`LICENSE`](LICENSE) cubre únicamente los archivos
originales de configuración, scripts, documentación y recursos creados por
el autor, salvo que un archivo indique otra cosa. La MIT permite usar,
copiar, modificar y redistribuir esos materiales, conservando el aviso de
copyright y la licencia. Consulta el texto oficial en
[Open Source Initiative](https://opensource.org/license/mit).

La licencia MIT no cubre ni concede derechos sobre:

- Arch Linux, Omarchy, Hyprland, Neovim, plugins, fuentes, iconos o cualquier
  otra dependencia externa; cada proyecto conserva su propia licencia.
- Mr. Robot, sus personajes, nombres, marcas, logotipos, frases o material
  promocional.
- Fondos JPG obtenidos de terceros. Se incluyen referencias en
  [`SOURCES.txt`](.config/omarchy/themes/mr-robot/backgrounds/SOURCES.txt),
  pero sus derechos y condiciones pertenecen a sus autores o sitios de
  origen. Verifica permisos, atribución y restricciones antes de redistribuir
  el repositorio o usar esos archivos comercialmente.
- Material publicado bajo Creative Commons u otra licencia distinta de MIT.
  Deben respetarse sus condiciones, como atribución o compartir igual; por
  ejemplo, [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode.es)
  y [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/legalcode.en).

No se afirma afiliación, patrocinio ni autorización por parte de Omarchy,
Arch Linux, los creadores de Mr. Robot, sus productoras, distribuidores,
autores de fondos o mantenedores de dependencias.

## Aviso legal

El contenido se ofrece “tal cual”, sin garantía de funcionamiento,
compatibilidad, disponibilidad, seguridad o ausencia de errores. El usuario
es responsable de revisar, adaptar y ejecutar el contenido, mantener copias
de seguridad y cumplir las leyes, licencias y políticas aplicables a su uso.
Nada en este repositorio constituye asesoría legal, técnica o de seguridad.
Cuando exista una duda sobre derechos de autor, redistribución, uso comercial
o responsabilidad, consulta a un profesional cualificado.
