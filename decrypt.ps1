# Este script descarga CDecrypt y sus DLLs si faltan, y luego ejecuta el descifrado.
# La URL base está configurada para el repositorio CesarFRR/cdecrypt-script.

param(
    [string]$BaseUrl = "https://raw.githubusercontent.com/CesarFRR/cdecrypt-script/main/"
)

$ExeFile = "CDecrypt.exe"
$BaseCommand = "CDecrypt" # ¡El nombre que funciona sin .exe!
$Dependencies = @("libeay32.dll", "msvcr120d.dll")
$InputTMD = "title.tmd"
$InputTIK = "title.tik"

Write-Host "Iniciando automatización de descifrado (PowerShell)..."

# Descargar herramientas si faltan (usando el nombre completo del archivo)
$AllFiles = @($ExeFile) + $Dependencies
foreach ($File in $AllFiles) {
    if (-not (Test-Path $File)) {
        $DownloadUrl = $BaseUrl + $File
        Write-Host "Descargando $File de GitHub..."
        try {
            # Invoke-WebRequest es el 'curl' de PowerShell
            Invoke-WebRequest -Uri $DownloadUrl -OutFile $File -UseBasicParsing
        } catch {
            Write-Error "Error al descargar $File. Verifica la URL. Abortando."
            exit 1
        }
    }
}

# Verificar archivos de entrada
if (-not (Test-Path $InputTMD) -or -not (Test-Path $InputTIK)) {
    Write-Error "Faltan archivos clave ($InputTMD y/o $InputTIK). Ejecuta el script en la carpeta del juego."
    exit 1
}

# Ejecutar el descifrado
Write-Host "Ejecutando descifrado: $BaseCommand $InputTMD $InputTIK"
# Línea CRUCIAL corregida: se llama al comando SIN el .exe
.\$BaseCommand $InputTMD $InputTIK

if ($LASTEXITCODE -eq 0) {
    Write-Host "Descifrado completado con éxito."
    Write-Host "Puedes borrar los archivos de descifrado temporal ($ExeFile y DLLs) si lo deseas."
} else {
    Write-Error "CDecrypt.exe terminó con código de error: $LASTEXITCODE."
}