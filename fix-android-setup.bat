@echo off
setlocal enabledelayedexpansion

echo ========================================================================
echo                    CONFIGURATION ANDROID POUR REACT NATIVE
echo ========================================================================
echo.
echo Ce script va configurer automatiquement l'environnement Android
echo pour React Native sur Windows
echo.

:: Variables
set CURRENT_DIR=%CD%
set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
set JAVA_HOME=%PROGRAMFILES%\Eclipse Adoptium\jdk-17.0.12.7-hotspot

echo ETAPE 1: Verification de l'installation Java...
echo.

:: Verifier si Java 17 est installe
java -version 2>nul
if %errorlevel% neq 0 (
    echo Java n'est pas installe ou pas dans le PATH
    echo.
    echo SOLUTION: Installez Java 17 depuis:
    echo https://adoptium.net/temurin/releases/?version=17
    echo.
    echo Apres installation, redemarrez votre terminal et relancez ce script.
    pause
    exit /b 1
)

:: Verifier la version de Java
for /f "tokens=3" %%i in ('java -version 2^>^&1 ^| findstr "version"') do (
    set JAVA_VERSION=%%i
    set JAVA_VERSION=!JAVA_VERSION:"=!
)

echo Version Java detectee: %JAVA_VERSION%

:: Verifier si c'est Java 17-20
echo %JAVA_VERSION% | findstr /r "^1[7-9]\." >nul
if %errorlevel% neq 0 (
    echo %JAVA_VERSION% | findstr /r "^20\." >nul
    if %errorlevel% neq 0 (
        echo ATTENTION: Java %JAVA_VERSION% detecte
        echo React Native necessite Java 17-20
        echo.
        echo SOLUTION: Installez Java 17 depuis:
        echo https://adoptium.net/temurin/releases/?version=17
        pause
    )
)

echo ETAPE 2: Configuration des variables d'environnement...
echo.

:: Verifier si Android Studio est installe
if not exist "%LOCALAPPDATA%\Android\Sdk" (
    echo Android SDK non trouve dans %LOCALAPPDATA%\Android\Sdk
    echo.
    echo SOLUTION: Installez Android Studio depuis:
    echo https://developer.android.com/studio
    echo.
    echo Apres installation:
    echo 1. Ouvrez Android Studio
    echo 2. Allez dans File ^> Settings ^> Appearance ^& Behavior ^> System Settings ^> Android SDK
    echo 3. Installez Android 14 ^(API 34^) et Android SDK Build-Tools 34.0.0
    echo 4. Relancez ce script
    pause
    exit /b 1
)

echo Android SDK trouve: %ANDROID_HOME%

:: Configurer les variables d'environnement
echo Configuration des variables d'environnement...

:: ANDROID_HOME
setx ANDROID_HOME "%ANDROID_HOME%" >nul 2>&1
echo ANDROID_HOME defini: %ANDROID_HOME%

:: JAVA_HOME (detecter automatiquement)
for /f "tokens=2*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Eclipse Adoptium\JDK" /s /v "Path" 2^>nul ^| findstr "REG_SZ"') do (
    set DETECTED_JAVA_HOME=%%j
)

if defined DETECTED_JAVA_HOME (
    setx JAVA_HOME "%DETECTED_JAVA_HOME%" >nul 2>&1
    echo JAVA_HOME defini: %DETECTED_JAVA_HOME%
) else (
    echo JAVA_HOME non detecte automatiquement
    echo Veuillez le definir manuellement
)

:: Ajouter au PATH
set NEW_PATH=%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\tools;%ANDROID_HOME%\tools\bin;%ANDROID_HOME%\emulator

:: Verifier si les chemins sont deja dans PATH
echo %PATH% | findstr "%ANDROID_HOME%" >nul
if %errorlevel% neq 0 (
    echo Ajout des outils Android au PATH...
    for /f "tokens=2*" %%i in ('reg query "HKEY_CURRENT_USER\Environment" /v "Path" 2^>nul') do set CURRENT_PATH=%%j
    setx PATH "%CURRENT_PATH%;%NEW_PATH%" >nul 2>&1
    echo PATH mis a jour
) else (
    echo Les outils Android sont deja dans le PATH
)

echo ETAPE 3: Verification des outils Android...
echo.

:: Rafraichir les variables d'environnement pour cette session
set PATH=%PATH%;%NEW_PATH%
set ANDROID_HOME=%ANDROID_HOME%

:: Verifier ADB
"%ANDROID_HOME%\platform-tools\adb.exe" version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ ADB fonctionne
) else (
    echo ✗ ADB non fonctionnel
    echo Verifiez que Android SDK Platform-Tools est installe
)

:: Verifier les emulateurs
echo.
echo Verification des emulateurs disponibles...
"%ANDROID_HOME%\emulator\emulator.exe" -list-avds 2>nul
if %errorlevel% equ 0 (
    echo ✓ Emulateur configure
) else (
    echo ✗ Aucun emulateur trouve
    echo.
    echo SOLUTION: Creez un emulateur avec Android Studio:
    echo 1. Ouvrez Android Studio
    echo 2. Allez dans Tools ^> AVD Manager
    echo 3. Cliquez sur "Create Virtual Device"
    echo 4. Choisissez un appareil ^(ex: Pixel 7^)
    echo 5. Selectionnez Android 14 ^(API 34^)
    echo 6. Terminez la creation
)

echo ETAPE 4: Test de connexion de votre appareil...
echo.

echo Verification des appareils connectes...
"%ANDROID_HOME%\platform-tools\adb.exe" devices
echo.

echo Si votre appareil n'apparait pas:
echo 1. Activez le mode developpeur sur votre telephone
echo 2. Activez le debogage USB
echo 3. Autorisez la connexion sur votre telephone
echo 4. Executez: adb devices

echo ETAPE 5: Configuration Gradle pour contourner les problemes SSL...
echo.

:: Creer le fichier gradle.properties pour contourner les problemes SSL
if not exist "%USERPROFILE%\.gradle" mkdir "%USERPROFILE%\.gradle"

(
echo # Configuration Gradle pour React Native
echo org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m
echo org.gradle.parallel=true
echo org.gradle.configureondemand=true
echo org.gradle.daemon=true
echo.
echo # Contournement des problemes SSL
echo systemProp.https.proxyHost=
echo systemProp.https.proxyPort=
echo systemProp.http.proxyHost=
echo systemProp.http.proxyPort=
echo.
echo # Configuration Android
echo android.useAndroidX=true
echo android.enableJetifier=true
) > "%USERPROFILE%\.gradle\gradle.properties"

echo Configuration Gradle creee dans %USERPROFILE%\.gradle\gradle.properties

echo.
echo ========================================================================
echo                           CONFIGURATION TERMINEE
echo ========================================================================
echo.
echo Variables d'environnement configurees:
echo - ANDROID_HOME: %ANDROID_HOME%
echo - PATH mis a jour avec les outils Android
echo.
echo IMPORTANT: Redemarrez votre terminal ^(PowerShell/CMD^) pour que
echo les nouvelles variables d'environnement prennent effet.
echo.
echo Apres redemarrage, testez avec:
echo   npx react-native doctor
echo   npm run android
echo.
echo Si vous avez encore des problemes:
echo 1. Verifiez qu'Android Studio est bien installe
echo 2. Verifiez qu'un emulateur est cree ou qu'un appareil est connecte
echo 3. Redemarrez completement votre ordinateur si necessaire
echo.

pause
