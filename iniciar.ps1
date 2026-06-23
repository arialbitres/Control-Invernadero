$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (-not (Get-Command php -ErrorAction SilentlyContinue)) {
    Write-Host "`nNo se encontro PHP en este equipo." -ForegroundColor Red
    Write-Host "Instalalo con: winget install PHP.PHP.8.4" -ForegroundColor Yellow
    Write-Host "Luego cerra y abri PowerShell, y ejecuta: .\iniciar.bat`n"
    exit 1
}

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "No se encontro Node.js. Instalalo desde https://nodejs.org/" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path (Join-Path $PSScriptRoot "node_modules"))) {
    Write-Host "Instalando dependencias por primera vez..." -ForegroundColor Yellow
    & npm.cmd install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "No se pudieron instalar las dependencias." -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

Write-Host "Iniciando Control de Invernadero..." -ForegroundColor Green
$socketServer = Start-Process node -ArgumentList "server.js" -WorkingDirectory $PSScriptRoot -PassThru -WindowStyle Hidden

try {
    Write-Host "Aplicacion disponible en http://localhost:8000"
    Write-Host "Presiona Ctrl+C para detenerla."
    php -S localhost:8000 -t $PSScriptRoot
}
finally {
    if ($socketServer -and -not $socketServer.HasExited) {
        Stop-Process -Id $socketServer.Id
    }
}
