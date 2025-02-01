#!/usr/bin/env bash
#
# Menu de gestión de estado del sistema usando OpenRC y sudo.
#
# Este script utiliza rofi o zenity para seleccionar acciones como apagar, reiniciar, etc.
# Modificado para que no pida confirmación y el menú aparezca centrado.

#######################################################################
#                            CONFIGURACIÓN                            #
#######################################################################

# Opciones de rofi
FG_COLOR="#bbbbbb"
BG_COLOR="#111111"
HLFG_COLOR="#111111"
HLBG_COLOR="#bbbbbb"
BORDER_COLOR="#222222"
ROFI_OPTIONS=(-theme-str 'window { location: center; anchor: center; }' -theme ~/.config/rofi/pw.rasi)

# Opciones de zenity
ZENITY_TITLE="Power Menu"
ZENITY_TEXT="Seleccione una acción:"
ZENITY_OPTIONS=(--column= --hide-header)

#######################################################################
#                             MENÚ                                    #
#######################################################################

# Definir las acciones y comandos
declare -A menu=(
  [ Apagar]="sudo shutdown -h 0"
  [ Reiniciar]="sudo reboot"
  [  Suspender]="sudo zzz"  # Asume que tienes suspend habilitado con OpenRC
  [ Hibernar]="sudo zzz"  # Cambia si usas un comando diferente
  [ Cerrar sesión]="kill -9 -1"  # Cerrar sesión actual
)

#######################################################################
#                         FUNCIONES                                  #
#######################################################################

# Verificar si un comando existe
command_exists() {
  command -v "$1" &>/dev/null
}

# Preparar el launcher
prepare_launcher() {
  if [[ "$1" == "rofi" ]]; then
    launcher_exe="rofi"
    launcher_options=(-dmenu -i -lines "${#menu[@]}" -p "Acción:" \
      -bc "${BORDER_COLOR}" -bg "${BG_COLOR}" -fg "${FG_COLOR}" \
      -hlfg "${HLFG_COLOR}" -hlbg "${HLBG_COLOR}" "${ROFI_OPTIONS[@]}")
  elif [[ "$1" == "zenity" ]]; then
    launcher_exe="zenity"
    launcher_options=(--list --title="${ZENITY_TITLE}" --text="${ZENITY_TEXT}" "${ZENITY_OPTIONS[@]}")
  fi
}

# Ejecutar el comando seleccionado
do_action() {
  eval "${menu[$1]}"
}

#######################################################################
#                           FLUJO PRINCIPAL                           #
#######################################################################

# Seleccionar launcher disponible
launcher_exe=""
launcher_options=""
for l in "rofi" "zenity"; do
  if command_exists "$l"; then
    prepare_launcher "$l"
    break
  fi
done

# Si no hay launcher disponible, salir
if [[ -z "$launcher_exe" ]]; then
  echo "Error: No se encontró un launcher compatible (rofi o zenity)."
  exit 1
fi

# Mostrar menú y obtener selección
selection=$(printf '%s\n' "${!menu[@]}" | "${launcher_exe}" "${launcher_options[@]}")
[[ -z "$selection" ]] && exit 0

# Ejecutar acción seleccionada
do_action "$selection"
