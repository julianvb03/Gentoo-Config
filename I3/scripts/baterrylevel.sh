#!/usr/bin/env bash

# Ruta al directorio donde se encuentra la información de la batería
BATTERY_PATH="/sys/class/power_supply/BAT0"

# Verifica si la información de la batería está disponible
if [ -d "$BATTERY_PATH" ]; then
    # Lee el porcentaje de carga de la batería
    CAPACITY=$(cat "$BATTERY_PATH/capacity")
    
    # Lee el estado de la batería (Charging, Discharging, Full)
    STATUS=$(cat "$BATTERY_PATH/status")

    # Determina el ícono en función del porcentaje de batería y el estado
    if [[ "$STATUS" == "Charging" ]]; then
        ICON="󰂄" # Ícono de carga
    elif [[ "$STATUS" == "Full" ]]; then
        ICON="󰁹" # Ícono de batería llena
    else
        if [ "$CAPACITY" -ge 80 ]; then
            ICON="󰁹" # Ícono de batería alta
        elif [ "$CAPACITY" -ge 50 ]; then
            ICON="󰁺" # Ícono de batería media
        elif [ "$CAPACITY" -ge 20 ]; then
            ICON="󰁻" # Ícono de batería baja
        else
            ICON="󰁽" # Ícono de batería crítica
        fi
    fi

    # Muestra el ícono y el porcentaje de batería
    echo "$ICON $CAPACITY%"
else
    # Si no se detecta la batería, muestra un mensaje de error
    echo " No Battery"
fi
