#!/bin/bash

# Obtener la memoria total, usada y calcular el porcentaje
total_mem=$(free | grep Mem | awk '{print $2}')
used_mem=$(free | grep Mem | awk '{print $3}')
percent=$((used_mem * 100 / total_mem))

# Imprimir el porcentaje de uso
echo "RAM: ${percent}%"
