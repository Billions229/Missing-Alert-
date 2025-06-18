# Script PowerShell pour lancer React Native avec la configuration Android correcte

Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "                    LANCEMENT MISSING ALERT" -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration des variables d'environnement pour cette session
$env:ANDROID_HOME = "C:\Android"
$env:PATH = $env:PATH + ";C:\Android\platform-tools;C:\Android\cmdline-tools\4.0\bin"

Write-Host "ETAPE 1: Configuration des variables d'environnement..." -ForegroundColor Yellow
Write-Host "ANDROID_HOME: $env:ANDROID_HOME" -ForegroundColor Green
Write-Host ""

# Verification de la connexion de l'appareil
Write-Host "ETAPE 2: Verification de l'appareil connecte..." -ForegroundColor Yellow
& "C:\Android\platform-tools\adb.exe" devices
Write-Host ""

# Recreer le fichier local.properties
Write-Host "ETAPE 3: Configuration du fichier local.properties..." -ForegroundColor Yellow
"sdk.dir=C:\\Android" | Out-File -FilePath "android\local.properties" -Encoding ASCII
Write-Host "Fichier local.properties recree" -ForegroundColor Green
Write-Host ""

# Nettoyer le projet
Write-Host "ETAPE 4: Nettoyage rapide du projet..." -ForegroundColor Yellow
if (Test-Path "android\build") {
    Remove-Item -Recurse -Force "android\build" -ErrorAction SilentlyContinue
    Write-Host "Dossier build nettoye" -ForegroundColor Green
}

# Nettoyer le cache Metro
Write-Host "Nettoyage du cache Metro..." -ForegroundColor Yellow
npm cache clean --force
Write-Host ""

# Lancer l'application
Write-Host "ETAPE 5: Lancement de l'application Missing Alert..." -ForegroundColor Yellow
Write-Host "Cela peut prendre quelques minutes la premiere fois..." -ForegroundColor Cyan
Write-Host ""

# Lancer React Native
npm run android

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "Si l'application ne se lance pas:" -ForegroundColor Yellow
Write-Host "1. Verifiez que votre telephone est toujours connecte" -ForegroundColor White
Write-Host "2. Autorisez l'installation sur votre telephone" -ForegroundColor White
Write-Host "3. Relancez ce script: .\run-android-fixed.ps1" -ForegroundColor White
Write-Host "========================================================================" -ForegroundColor Cyan
