# Mr. Robot — Omarchy theme

Tema oscuro de alto contraste con tono de terminal, vigilancia y glitch:
negro profundo, blanco de fósforo y rojo de alerta. Está creado desde cero
para Omarchy. Es un tema comunitario/no oficial e incluye recursos originales
y recursos de terceros cuya licencia debe revisarse por separado.

> Si eres nuevo en Omarchy: este repositorio instala únicamente un tema. No
> instala Arch Linux, Omarchy, aplicaciones, fuentes ni el repositorio completo
> de dotfiles. Haz una copia de seguridad antes de cambiar tu tema.

## Instalación directa

Este tema tiene un repositorio independiente y puede instalarse con:

```bash
omarchy theme install \
  https://github.com/ciprianotoor/omarchy-mr-robot-theme.git
```

Omarchy clonará el repositorio independiente en
`~/.config/omarchy/themes/mr-robot`. No combines esta instalación con el
enlace simbólico de los dotfiles usando el mismo nombre: elige un método para
evitar confusiones sobre qué copia está activa.

## Instalación desde el repositorio de dotfiles

```bash
git clone https://github.com/ciprianotoor/DotfileArchOmarchyCipriano.git
cd DotfileArchOmarchyCipriano
ln -sfn "$PWD/.config/omarchy/themes/mr-robot" \
  "$HOME/.config/omarchy/themes/mr-robot"
omarchy theme set mr-robot
```

Para desarrollo local, el enlace puede existir sin activar el tema. Este
repositorio no ejecuta comandos de aplicación automáticamente.

Para cambiar entre los fondos incluidos:

```bash
omarchy theme bg next
```

Para quitar el tema, activa primero otro tema y comprueba la ruta con
`ls -ld ~/.config/omarchy/themes/mr-robot`. No borres
`~/.local/share/omarchy/`, porque es una ruta administrada por Omarchy.

## Inspiración visual

- Fondo casi negro y tipografía clara de terminal.
- Rojo `#F2293A` para alertas, bordes y estados críticos.
- Blanco fósforo `#E7E9E7` para lectura prolongada.
- Gris CRT y líneas de interferencia para la sensación de monitor antiguo.
- Fondos SVG y JPG incluidos directamente en `backgrounds/`.

`preview.png` es la miniatura del tema. `backgrounds/mr-robot-ascii.png` es
el fondo ASCII rojo/negro que Omarchy puede incluir al usar `theme bg next`.

## Licencia, recursos de terceros y límites

Esta sección es informativa y no constituye asesoría legal. La licencia MIT de
este repositorio cubre únicamente las configuraciones, scripts, documentación
y recursos originales creados por el autor, salvo indicación distinta.

Los JPG de terceros están identificados o referenciados en
[`SOURCES.txt`](backgrounds/SOURCES.txt). Sus derechos, permisos, atribución y
restricciones pertenecen a sus respectivos autores o sitios de origen. MIT no
te concede derechos sobre esos JPG, ni sobre frases, personajes, marcas,
logotipos o material promocional de *Mr. Robot*. Verifica cada fuente antes de
redistribuir el repositorio o usar los recursos comercialmente; si no puedes
verificar los permisos, elimina los archivos de terceros de tu copia.

Arch Linux, Omarchy, Hyprland, fuentes, iconos, plugins y demás dependencias
también conservan sus propias licencias. Revisa sus términos por separado.

Este tema no está afiliado, patrocinado ni aprobado por Omarchy, Arch Linux,
los titulares de derechos de Mr. Robot ni los autores de los recursos
externos.

“Mr. Robot” se usa solamente para describir la inspiración visual de este
proyecto de fans. No se permite presentar el tema como oficial, autorizado o
respaldado por los titulares de la serie o por Omarchy.

El tema se proporciona “tal cual”, sin garantía de compatibilidad, seguridad o
ausencia de errores. El usuario es responsable de revisar los archivos,
mantener copias de seguridad y cumplir las licencias y leyes aplicables.
