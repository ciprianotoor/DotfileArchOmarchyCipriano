# Mr. Robot — Omarchy theme

Tema oscuro de alto contraste con tono de terminal, vigilancia y glitch:
negro profundo, blanco de fósforo y rojo de alerta. Está creado desde cero
para Omarchy e incluye fondos originales y fondos seleccionados para uso
personal.

## Instalación desde este repositorio

```bash
git clone https://github.com/ciprianotoor/DotfileArchOmarchyCipriano.git
cd DotfileArchOmarchyCipriano
ln -sfn "$PWD/.config/omarchy/themes/mr-robot" \
  "$HOME/.config/omarchy/themes/mr-robot"
omarchy theme set mr-robot
```

Para desarrollo local, el enlace puede existir sin activar el tema. Este
repositorio no ejecuta comandos de aplicación automáticamente.

## Inspiración visual

- Fondo casi negro y tipografía clara de terminal.
- Rojo `#F2293A` para alertas, bordes y estados críticos.
- Blanco fósforo `#E7E9E7` para lectura prolongada.
- Gris CRT y líneas de interferencia para la sensación de monitor antiguo.
- Fondos SVG y JPG incluidos directamente en `backgrounds/`.

`preview.png` es la miniatura del tema. `backgrounds/mr-robot-ascii.png` es
el fondo ASCII rojo/negro que Omarchy puede incluir al usar `theme bg next`.

## Licencia

MIT. Los fondos SVG y configuraciones de este tema son originales.
