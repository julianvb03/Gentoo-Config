#!/bin/bash

# Archivo donde se guardarán las tareas
TODO_FILE="$HOME/.rofi_todos"
DONE_FILE="$HOME/.rofi_done_todos" # Opcional: para almacenar tareas completadas

# Asegurarse de que los archivos existan
if [[ ! -f "${TODO_FILE}" ]]; then
    touch "${TODO_FILE}"
fi

if [[ ! -f "${DONE_FILE}" ]]; then
    touch "${DONE_FILE}"
fi

# Función para agregar una tarea
function add_todo() {
    echo "$*" >> "${TODO_FILE}"
}

# Función para eliminar una tarea
function remove_todo() {
    if [[ -n "$DONE_FILE" ]]; then
        echo "$*" >> "${DONE_FILE}" # Mueve la tarea al archivo de completadas
    fi
    sed -i "/^${*}$/d" "${TODO_FILE}"
}

# Función para obtener todas las tareas
function get_todos() {
    cat "${TODO_FILE}" # Simplemente imprime el contenido del archivo
}

# Manejo de entrada del usuario
if [[ -z "$1" ]]; then
    # Si no se pasa ningún argumento, muestra las tareas
    get_todos
else
    INPUT="$*"
    LINE=$(echo "$INPUT" | sed "s/\([^a-zA-Z0-9]\)/\\\\\\1/g") # Escapa caracteres especiales
    LINE_UNESCAPED="$INPUT"

    if [[ $LINE_UNESCAPED == +* ]]; then
        # Agregar tarea si empieza con "+"
        LINE_UNESCAPED=$(echo "$LINE_UNESCAPED" | sed 's/^+//g' | sed 's/^\s+//g')
        add_todo "$LINE_UNESCAPED"
    else
        # Buscar y eliminar tarea si ya existe
        MATCHING=$(grep "^${LINE_UNESCAPED}$" "${TODO_FILE}")
        if [[ -n "$MATCHING" ]]; then
            remove_todo "$LINE_UNESCAPED"
        fi
    fi

    # Mostrar las tareas actualizadas
    get_todos
fi
