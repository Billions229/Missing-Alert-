# Script PowerShell pour nettoyer Gradle et lancer Missing Alert

Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "                    NETTOYAGE GRADLE ET LANCEMENT" -ForegroundColor Cyan
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration des variables d'environnement
$env:ANDROID_HOME = "C:\Android"
$env:PATH = $env:PATH + ";C:\Android\platform-tools;C:\Android\cmdline-tools\4.0\bin"

Write-Host "ETAPE 1: Nettoyage complet des caches Gradle..." -ForegroundColor Yellow

# Supprimer tous les caches Gradle
$gradleDir = "$env:USERPROFILE\.gradle"
if (Test-Path $gradleDir) {
    Write-Host "Suppression de $gradleDir..." -ForegroundColor Red
    Remove-Item -Recurse -Force $gradleDir -ErrorAction SilentlyContinue
    Write-Host "Caches Gradle supprimes" -ForegroundColor Green
}

# Supprimer le dossier build du projet
if (Test-Path "android\build") {
    Write-Host "Suppression du dossier build du projet..." -ForegroundColor Red
    Remove-Item -Recurse -Force "android\build" -ErrorAction SilentlyContinue
    Write-Host "Dossier build supprime" -ForegroundColor Green
}

# Supprimer node_modules et reinstaller
Write-Host ""
Write-Host "ETAPE 2: Reinstallation des dependances Node.js..." -ForegroundColor Yellow
if (Test-Path "node_modules") {
    Write-Host "Suppression de node_modules..." -ForegroundColor Red
    Remove-Item -Recurse -Force "node_modules" -ErrorAction SilentlyContinue
}

if (Test-Path "package-lock.json") {
    Remove-Item "package-lock.json" -ErrorAction SilentlyContinue
}

Write-Host "Reinstallation des dependances..." -ForegroundColor Yellow
npm install

Write-Host ""
Write-Host "ETAPE 3: Recreation du fichier local.properties..." -ForegroundColor Yellow
"sdk.dir=C:\\Android" | Out-File -FilePath "android\local.properties" -Encoding ASCII
Write-Host "Fichier local.properties recree" -ForegroundColor Green

Write-Host ""
Write-Host "ETAPE 4: Verification de l'appareil..." -ForegroundColor Yellow
& "C:\Android\platform-tools\adb.exe" devices

Write-Host ""
Write-Host "ETAPE 5: Lancement de l'application..." -ForegroundColor Yellow
Write-Host "Cela peut prendre 5-10 minutes la premiere fois..." -ForegroundColor Cyan
Write-Host ""

# Lancer React Native
npm run android

Write-Host ""
Write-Host "========================================================================" -ForegroundColor Cyan
Write-Host "Si ca ne marche toujours pas, essayez:" -ForegroundColor Yellow
Write-Host "1. Redemarrez votre ordinateur" -ForegroundColor White
Write-Host "2. Relancez ce script" -ForegroundColor White
Write-Host "3. Ou essayez: cd android && gradlew.bat clean && cd .. && npm run android" -ForegroundColor White
Write-Host "========================================================================" -ForegroundColor Cyan
