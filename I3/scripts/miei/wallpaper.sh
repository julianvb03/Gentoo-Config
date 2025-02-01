#!/usr/bin/bash

# Definir rutas con expansión completa
w_path="$HOME/Imagenes/Walppapers"
c_path="$HOME/.config/walppaper/current"
config="$HOME/.config/walppaper"

# Número máximo de imágenes (ajústalo según el total de imágenes en la carpeta)
max_index=6

# Leer el número actual y eliminar espacios innecesarios
current=$(cat "$c_path" | tr -d '[:space:]')

# Verificar si la variable current es un número
if ! [[ "$current" =~ ^[0-9]+$ ]]; then
    echo "Error: El valor en $c_path no es un número válido."
    exit 1
fi

# Verificar si BLOCK_BUTTON está definido y manejarlo
if [[ -z "$BLOCK_BUTTON" ]]; then
    echo "Uso: Presiona el botón izquierdo (1) para avanzar, derecho (3) para retroceder"
    exit 1
fi

# Ajustar el índice según el botón presionado
if [ "$BLOCK_BUTTON" -eq 1 ]; then
    new=$((current + 1))
    if [ "$new" -gt "$max_index" ]; then
        new=0
    fi
elif [ "$BLOCK_BUTTON" -eq 3 ]; then
    new=$((current - 1))
    if [ "$new" -lt 0 ]; then
        new=$max_index
    fi
else
    echo "Uso: Presiona el botón izquierdo (1) para avanzar, derecho (3) para retroceder"
    exit 1
fi

# Verificar si la imagen existe antes de copiar
if [ ! -f "$w_path/$new.png" ]; then
    echo "Error: La imagen $new.png no existe en $w_path"
    exit 1
fi

# Eliminar imagen anterior si existe
if [ -f "${config}/sfondo.png" ]; then
    rm "${config}/sfondo.png"
fi

# Copiar y renombrar la nueva imagen
cp "$w_path/$new.png" "$config"
mv "$config/$new.png" "${config}/sfondo.png"

# Actualizar el archivo con el nuevo índice
echo "$new" > "$c_path"

# Aplicar el nuevo fondo de pantalla
feh --bg-fill "${config}/sfondo.png"
