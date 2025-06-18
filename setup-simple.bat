@echo off
setlocal enabledelayedexpansion

echo ========================================================================
echo                    MISSING ALERT - SETUP SIMPLIFIE
echo ========================================================================
echo.
echo Configuration automatique du projet React Native Missing Alert
echo.

:: Variables
set PROJECT_NAME=MissingAlert
set CURRENT_DIR=%CD%
set PROJECT_DIR=%CURRENT_DIR%\%PROJECT_NAME%

echo Repertoire courant: %CURRENT_DIR%
echo Projet sera cree dans: %PROJECT_DIR%
echo.

:: Verification des prerequis
echo ETAPE 1: Verification des prerequis...
echo.

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: Node.js n'est pas installe ou pas dans le PATH
    pause
    exit /b 1
)

where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: npm n'est pas installe ou pas dans le PATH
    pause
    exit /b 1
)

where git >nul 2>&1
if %errorlevel% neq 0 (
    echo ERREUR: git n'est pas installe ou pas dans le PATH
    pause
    exit /b 1
)

for /f "tokens=1" %%i in ('node --version') do set NODE_VERSION=%%i
echo Node.js version detectee: %NODE_VERSION%
echo Tous les prerequis sont satisfaits!
echo.

:: Suppression du dossier existant si present
if exist "%PROJECT_DIR%" (
    echo Le dossier %PROJECT_NAME% existe deja. Suppression...
    rmdir /s /q "%PROJECT_DIR%"
    echo Dossier supprime.
)

echo ETAPE 2: Creation du projet React Native...
echo.
echo Initialisation du projet React Native avec TypeScript...
echo Cela peut prendre plusieurs minutes...
echo.

npx react-native@latest init %PROJECT_NAME% --template react-native-template-typescript
if %errorlevel% neq 0 (
    echo ERREUR: Echec de la creation du projet React Native
    pause
    exit /b 1
)

echo Projet React Native cree avec succes!
echo.

:: Aller dans le repertoire du projet
cd "%PROJECT_DIR%"

echo ETAPE 3: Installation des dependances principales...
echo.

echo Installation des dependances de navigation...
call npm install @react-navigation/native @react-navigation/stack @react-navigation/bottom-tabs
if %errorlevel% neq 0 (
    echo ERREUR: Echec de l'installation des dependances de navigation
    pause
    exit /b 1
)

echo Installation des dependances React Native...
call npm install react-native-screens react-native-safe-area-context react-native-gesture-handler
if %errorlevel% neq 0 (
    echo ERREUR: Echec de l'installation des dependances React Native
    pause
    exit /b 1
)

echo Installation des dependances de gestion d'etat...
call npm install zustand @reduxjs/toolkit react-redux
if %errorlevel% neq 0 (
    echo ERREUR: Echec de l'installation des dependances de gestion d'etat
    pause
    exit /b 1
)

echo Installation des dependances de formulaires...
call npm install react-hook-form @hookform/resolvers yup
if %errorlevel% neq 0 (
    echo ERREUR: Echec de l'installation des dependances de formulaires
    pause
    exit /b 1
)

echo Dependances principales installees avec succes!
echo.

echo ETAPE 4: Installation des dependances Firebase...
echo.

echo Installation de Firebase...
call npm install @react-native-firebase/app @react-native-firebase/auth @react-native-firebase/firestore @react-native-firebase/messaging @react-native-firebase/storage
if %errorlevel% neq 0 (
    echo ERREUR: Echec de l'installation de Firebase
    pause
    exit /b 1
)

echo Installation des dependances de geolocalisation...
call npm install react-native-geolocation-service react-native-maps @react-native-community/geolocation
if %errorlevel% neq 0 (
    echo ERREUR: Echec de l'installation des dependances de geolocalisation
    pause
    exit /b 1
)

echo Installation des dependances d'images...
call npm install react-native-image-picker react-native-image-crop-picker
if %errorlevel% neq 0 (
    echo ERREUR: Echec de l'installation des dependances d'images
    pause
    exit /b 1
)

echo Dependances Firebase et geolocalisation installees!
echo.

echo ETAPE 5: Installation des dependances de developpement...
echo.

call npm install --save-dev @types/react @types/react-native eslint prettier @typescript-eslint/eslint-plugin @typescript-eslint/parser
if %errorlevel% neq 0 (
    echo ERREUR: Echec de l'installation des outils de developpement
    pause
    exit /b 1
)

call npm install --save-dev jest @testing-library/react-native @testing-library/jest-native
if %errorlevel% neq 0 (
    echo ERREUR: Echec de l'installation des outils de test
    pause
    exit /b 1
)

echo Dependances de developpement installees!
echo.

echo ETAPE 6: Creation de la structure de dossiers...
echo.

mkdir src 2>nul
mkdir src\components 2>nul
mkdir src\screens 2>nul
mkdir src\navigation 2>nul
mkdir src\services 2>nul
mkdir src\store 2>nul
mkdir src\types 2>nul
mkdir src\utils 2>nul
mkdir src\hooks 2>nul
mkdir src\assets 2>nul
mkdir src\assets\images 2>nul
mkdir src\assets\icons 2>nul

mkdir src\screens\auth 2>nul
mkdir src\screens\home 2>nul
mkdir src\screens\alerts 2>nul
mkdir src\screens\profile 2>nul
mkdir src\screens\map 2>nul

mkdir src\components\common 2>nul
mkdir src\components\forms 2>nul
mkdir src\components\alerts 2>nul
mkdir src\components\map 2>nul

mkdir src\services\firebase 2>nul
mkdir src\services\geolocation 2>nul
mkdir src\services\notifications 2>nul

echo Structure de dossiers creee!
echo.

echo ========================================================================
echo                           CONFIGURATION TERMINEE
echo ========================================================================
echo.
echo Projet React Native cree: %PROJECT_NAME%
echo Toutes les dependances installees
echo Structure de dossiers creee
echo.
echo PROCHAINES ETAPES:
echo 1. Configurer Firebase dans votre console Firebase
echo 2. Creer les fichiers de code source
echo 3. Configurer les variables d'environnement
echo 4. Tester l'application
echo.
echo Le projet de base est maintenant pret!
echo.

cd "%CURRENT_DIR%"
pause
