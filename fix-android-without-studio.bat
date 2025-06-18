@echo off
setlocal enabledelayedexpansion

echo ========================================================================
echo                    FINALISATION ANDROID SANS ANDROID STUDIO
echo ========================================================================
echo.
echo Ce script va finaliser votre configuration Android basee sur votre guide
echo react_native_guide.md
echo.

:: Variables basees sur votre guide
set ANDROID_HOME=C:\Android
set CURRENT_DIR=%CD%

echo ETAPE 1: Verification de la configuration existante...
echo.

:: Verifier si Android SDK est installe selon votre guide
if not exist "%ANDROID_HOME%" (
    echo ERREUR: Android SDK non trouve dans C:\Android
    echo Veuillez suivre les etapes 4-6 de votre guide react_native_guide.md
    pause
    exit /b 1
)

echo Android SDK trouve: %ANDROID_HOME%

:: Verifier les outils essentiels
if not exist "%ANDROID_HOME%\platform-tools\adb.exe" (
    echo ATTENTION: platform-tools manquant
    echo Executez: sdkmanager "platform-tools"
)

if not exist "%ANDROID_HOME%\cmdline-tools" (
    echo ATTENTION: cmdline-tools manquant
    echo Verifiez l'etape 4 de votre guide
)

echo ETAPE 2: Configuration des variables d'environnement...
echo.

:: Configurer ANDROID_HOME
setx ANDROID_HOME "%ANDROID_HOME%" >nul 2>&1
echo ANDROID_HOME defini: %ANDROID_HOME%

:: Detecter JAVA_HOME automatiquement
set JAVA_FOUND=0
for /d %%i in ("C:\Program Files\OpenJDK\*") do (
    if exist "%%i\bin\java.exe" (
        setx JAVA_HOME "%%i" >nul 2>&1
        echo JAVA_HOME defini: %%i
        set JAVA_FOUND=1
        goto :java_found
    )
)

:java_found
if %JAVA_FOUND%==0 (
    echo ATTENTION: Java non trouve automatiquement
    echo Verifiez l'installation avec: choco install -y openjdk8
)

:: Configurer le PATH
echo Configuration du PATH...
set NEW_PATHS=%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\cmdline-tools\4.0\bin;%ANDROID_HOME%\cmdline-tools\4.0

:: Ajouter au PATH utilisateur
for /f "tokens=2*" %%i in ('reg query "HKEY_CURRENT_USER\Environment" /v "Path" 2^>nul') do set CURRENT_PATH=%%j
echo %CURRENT_PATH% | findstr "%ANDROID_HOME%" >nul
if %errorlevel% neq 0 (
    setx PATH "%CURRENT_PATH%;%NEW_PATHS%" >nul 2>&1
    echo PATH mis a jour avec les outils Android
) else (
    echo Les outils Android sont deja dans le PATH
)

echo ETAPE 3: Creation du fichier local.properties...
echo.

:: Creer le fichier local.properties dans android/
if not exist "android" (
    echo ATTENTION: Dossier android/ non trouve
    echo Etes-vous dans le bon repertoire de projet React Native?
) else (
    echo sdk.dir=C:\\Android > android\local.properties
    echo Fichier local.properties cree dans android/
)

echo ETAPE 4: Configuration Gradle optimisee...
echo.

:: Creer le fichier gradle.properties global
if not exist "%USERPROFILE%\.gradle" mkdir "%USERPROFILE%\.gradle"

(
echo # Configuration Gradle pour React Native
echo org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m
echo org.gradle.parallel=true
echo org.gradle.configureondemand=true
echo org.gradle.daemon=true
echo.
echo # Configuration Android
echo android.useAndroidX=true
echo android.enableJetifier=true
echo.
echo # Optimisations reseau
echo systemProp.http.socketTimeout=60000
echo systemProp.http.connectionTimeout=60000
) > "%USERPROFILE%\.gradle\gradle.properties"

echo Configuration Gradle globale creee

:: Optimiser le gradle.properties local du projet
if exist "android\gradle.properties" (
    echo. >> android\gradle.properties
    echo # Optimisations ajoutees automatiquement >> android\gradle.properties
    echo org.gradle.jvmargs=-Xmx2048m >> android\gradle.properties
    echo org.gradle.parallel=true >> android\gradle.properties
    echo android.enableJetifier=true >> android\gradle.properties
    echo android.useAndroidX=true >> android\gradle.properties
    echo Configuration Gradle locale optimisee
)

echo ETAPE 5: Test de la configuration...
echo.

:: Rafraichir les variables pour cette session
set PATH=%PATH%;%NEW_PATHS%
set ANDROID_HOME=%ANDROID_HOME%

:: Tester ADB
echo Test d'ADB...
"%ANDROID_HOME%\platform-tools\adb.exe" version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ ADB fonctionne correctement
    echo.
    echo Appareils connectes:
    "%ANDROID_HOME%\platform-tools\adb.exe" devices
) else (
    echo ✗ ADB ne fonctionne pas
    echo Verifiez que platform-tools est installe: sdkmanager "platform-tools"
)

echo.
echo ETAPE 6: Verification des packages Android installes...
echo.

:: Verifier les packages installes
if exist "%ANDROID_HOME%\cmdline-tools\4.0\bin\sdkmanager.bat" (
    echo Packages Android installes:
    "%ANDROID_HOME%\cmdline-tools\4.0\bin\sdkmanager.bat" --list_installed
) else (
    echo ATTENTION: sdkmanager non trouve
    echo Verifiez la structure des dossiers cmdline-tools
)

echo ETAPE 7: Nettoyage et preparation du projet...
echo.

:: Nettoyer le cache npm
echo Nettoyage du cache npm...
call npm cache clean --force

:: Nettoyer le projet Android si possible
if exist "android\gradlew.bat" (
    echo Nettoyage du projet Android...
    cd android
    call gradlew.bat clean
    cd ..
    echo Projet Android nettoye
)

:: Nettoyer Metro cache
echo Nettoyage du cache Metro...
call npx react-native start --reset-cache --port 8081 &
timeout /t 3 >nul
taskkill /f /im node.exe >nul 2>&1

echo.
echo ========================================================================
echo                           CONFIGURATION FINALISEE
echo ========================================================================
echo.
echo Configuration basee sur votre guide react_native_guide.md:
echo ✓ ANDROID_HOME: %ANDROID_HOME%
echo ✓ PATH mis a jour
echo ✓ local.properties cree
echo ✓ Gradle optimise
echo ✓ Caches nettoyes
echo.
echo IMPORTANT: Redemarrez votre terminal PowerShell pour que les
echo nouvelles variables d'environnement prennent effet.
echo.
echo PROCHAINES ETAPES:
echo 1. Redemarrez votre terminal
echo 2. Verifiez votre appareil: adb devices
echo 3. Testez: npm run android
echo.
echo Si vous avez encore des problemes:
echo - Verifiez que votre telephone est en mode debogage USB
echo - Autorisez la connexion sur votre telephone
echo - Executez: npx react-native doctor
echo.

pause
