#!/bin/bash
# Este script descarga CDecrypt y sus DLLs si faltan, y luego ejecuta el descifrado.
# La URL base ya está configurada a tu repositorio.

BASE_URL="https://raw.githubusercontent.com/CesarFRR/cdecrypt-script/main/"
EXECUTABLE="CDecrypt.exe"
DEPENDENCIES=("libeay32.dll" "msvcr120d.dll")
INPUT_TMD="title.tmd"
INPUT_TIK="title.tik"

echo "Iniciando automatización (Bash)..."

# Descargar herramientas si faltan
if [ ! -f "$EXECUTABLE" ]; then
    echo "Descargando $EXECUTABLE de GitHub..."
    curl -L -o "$EXECUTABLE" "${BASE_URL}${EXECUTABLE}" || { echo "ERROR: Falló la descarga de $EXECUTABLE. Abortando."; exit 1; }
fi
for FILE in "${DEPENDENCIES[@]}"; do
    if [ ! -f "$FILE" ]; then
        echo "Descargando $FILE de GitHub..."
        curl -L -o "$FILE" "${BASE_URL}${FILE}" || { echo "ERROR: Falló la descarga de $FILE. Abortando."; exit 1; }
    fi
done

# Dar permisos de ejecución (Necesario para entornos Linux/macOS)
chmod +x "$EXECUTABLE"

# Verificar archivos de entrada
if [ ! -f "$INPUT_TMD" ] || [ ! -f "$INPUT_TIK" ]; then
    echo "ERROR: Faltan archivos clave ($INPUT_TMD y/o $INPUT_TIK). Ejecuta el script en la carpeta del juego."
    exit 1
fi

# Ejecutar el descifrado
echo "Ejecutando descifrado..."
"./$EXECUTABLE" "$INPUT_TMD" "$INPUT_TIK"

if [ $? -eq 0 ]; then
    echo "Descifrado completado con éxito."
    echo "Puedes borrar los archivos de descifrado temporal ($EXECUTABLE y DLLs) si lo deseas."
else
    echo "ERROR: CDecrypt.exe falló. Revisa los archivos de entrada o permisos."
    exit 1
fi