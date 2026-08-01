# Módulo Cava para Waybar

Esta guía explica cómo restaurar el módulo de visualización de audio que fue retirado de Waybar.

## Archivos

- `~/.config/waybar/cava-waybar.conf`: configuración de Cava.
- `~/.local/bin/waybar-cava`: genera la visualización en formato JSON para Waybar.
- `~/.local/bin/waybar-cava-control`: controles de reproducción.

También se guardó una copia en `~/cava-waybar-backup.tar.gz`.

## Restaurar los archivos

```bash
tar -xzf ~/cava-waybar-backup.tar.gz -C ~
chmod +x ~/.local/bin/waybar-cava ~/.local/bin/waybar-cava-control
```

Se necesitan `cava`, `jq` y un reproductor compatible con `playerctl` o `cmus-remote`.

## Activar el módulo

En `~/.config/waybar/config.jsonc`, añade `"custom/cava"` dentro de `modules-right`, por ejemplo después de `pulseaudio`:

```jsonc
"pulseaudio",
"custom/cava",
"cpu",
```

Después, añade esta definición al mismo archivo, dentro del objeto principal:

```jsonc
"custom/cava": {
  "exec": "$HOME/.local/bin/waybar-cava",
  "return-type": "json",
  "format": "{}",
  "tooltip": true,
  "on-click": "$HOME/.local/bin/waybar-cava-control toggle",
  "on-scroll-up": "$HOME/.local/bin/waybar-cava-control next",
  "on-scroll-down": "$HOME/.local/bin/waybar-cava-control previous"
},
```

Opcionalmente, añade este estilo a `~/.config/waybar/style.css`:

```css
#custom-cava {
  margin: 0 8px;
  color: @foreground;
  font-family: 'JetBrainsMono Nerd Font';
  font-size: 11px;
  letter-spacing: 0px;
}
```

Finalmente, reinicia Waybar:

```bash
omarchy restart waybar
```

El módulo muestra las barras de audio, permite pausar/reanudar con clic y cambiar de pista con la rueda del ratón.
