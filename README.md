# Configuración de Gentoo

Este repositorio guarda mi configuración para mi distribución Gentoo.

## Consideraciones

1. **Gestor de servicios:** Uso **OpenRC** como gestor de servicios.
2. **Paquetes binarios:** Utilizo todos los binarios posibles.
   - Para este propósito, en el archivo **_/portage/config/make.conf_**, incluyo:
     ```bash
     FEATURES="${FEATURES} getbinpkg"
     FEATURES="${FEATURES} binpkg-request-signature"
     ```
   - También selecciono un mirror cercano a mi ubicación. En el archivo **_/etc/portage/binrepos.conf/gentoobinhost.conf_** tengo un mirror brasileño:
     ```bash
     [gentoobinhost]
     priority = 9999
     sync-uri = https://gentoo.c3sl.ufpr.br/releases/amd64/binpackages/23.0/x86-64
     ```
3. **Configuración de hardware:** Uso una **CPU AMD con APU**, junto con **PulseAudio, Bluetooth y GRUB**, con la siguiente configuración:
   ```bash
   USE="X alsa pulseaudio bluetooth networkmanager dist-kernel elogind wifi dbus -kde -gnome -systemd"
   GRUB_PLATFORMS="efi-64"
   VIDEO_CARDS="amdgpu"
   ```

## Configuración de i3

Las dependencias necesarias para el correcto funcionamiento de **i3** son:

1. **i3-wm** → Gestor de ventanas.
2. **i3blocks** → Barra de estado (`i3blocks -c ~/.config/i3/i3blocks.conf`).
3. **xss-lock** + **i3lock** → Bloqueo automático antes de suspender.
4. **NetworkManager** + **nm-applet** → Conexión de red y applet en bandeja.
5. **PulseAudio** y utilidades (`pulseaudio`, `pulseaudio-utils`, `pactl`).
6. **Rofi** → Lanzador de aplicaciones y menús.
7. **xcompmgr** → Compositor ligero para transparencias.
8. **feh** → Para establecer el fondo de pantalla.
9. **setxkbmap** → Configuración del teclado (`setxkbmap -layout latam`).
10. **flameshot** → Capturas de pantalla.
11. **FiraCode Nerd Font** → Para mostrar glifos en la barra de i3.
12. **Scripts personalizados:** Ubicados en **_/Scripts_**, algunos de ellos son:
    - `~/.config/i3/scripts/powermenu`
    - `~/.config/i3/scripts/blur-lock`
    - `~/.config/i3/scripts/volume_brightness.sh`
    - Para el script `wallpaper`, se debe crear la carpeta **_~/.config/wallpaper_** y añadir un archivo `current` con el número de fondos disponibles.

## Dependencias de los scripts

### **Dependencias Generales**
- **Bash** (`/bin/bash`) adicionalmente se usa starship para la variable **PS1** con la configuracion de **_starship.toml_**
- **Coreutils** (`awk`, `grep`, `sed`, `cat`, `rm`, `cp`, `mv`, etc.)
- **Procps** (`vmstat`, `free`) → Información de memoria y CPU.
- **bc** → Cálculos de precisión decimal.
- **pactl** → Manejo de volumen.
- **xrandr** → Ajuste de brillo.
- **feh** → Aplicación de fondos de pantalla.
- **dunstify** → Notificaciones emergentes.
- **rofi / zenity** → Interfaz de menús.
- **htop** → Monitoreo de procesos.
- **paplay** → Sonidos de notificación.

---

### **Dependencias por Script**

#### **`.bashrc`**
- Archivos: `/etc/bashrc`, `/usr/share/bash-completion/bash_completion`.
- Programas: `starship`, `nvim`, `tree`, `docker`, `emerge`, etc.

#### **`volumen_brightness.sh`**
- Programas: `pactl`, `xrandr`, `dunstify`, `bc`.

#### **`powermenu.sh`**
- Programas: `rofi`, `zenity`, `shutdown`, `reboot`, `kill`, `zzz`, `sudo`.

#### **`pomodoro.sh`**
- Archivos: `/tmp/pomo_timer`, `/tmp/pomodoro`, `bell.wav`, `bell_end.wav`.
- Programas: `notify-send`, `paplay`.

#### **`blur_lock.sh`**
- Archivos: `~/Imagenes/Walppapers/i3lock.png`.
- Programas: `i3lock`.

#### **`battery_level.sh`**
- Archivos: `/sys/class/power_supply/BAT0/capacity`, `/sys/class/power_supply/BAT0/status`.
- Programas: `cat`.

#### **`wallpaper.sh`**
- Archivos: `~/.config/wallpaper/current`, `~/.config/wallpaper/sfondo.png`.
- Programas: `feh`.

#### **`ram_usage.sh`**
- Programas: `free`.

#### **`cpu.sh`**
- Programas: `vmstat`, `htop`.

---

## **Resumen de Dependencias Claves**
- **Sistema:** `bash`, `coreutils`, `procps`, `sudo`
- **Audio/Brillo:** `pactl`, `xrandr`, `bc`, `paplay`
- **Interfaz:** `rofi`, `zenity`, `dunstify`, `notify-send`
- **Sistema:** `shutdown`, `reboot`, `kill`, `zzz`
- **Fondos de pantalla:** `feh`
- **Edición de archivos:** `sed`
- **Monitorización:** `free`, `vmstat`, `htop`

## Display Manager

Uso **LightDM** con **lightdm-gtk-greeter**.
