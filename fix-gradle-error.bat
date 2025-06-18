@echo off
setlocal enabledelayedexpansion

echo ========================================================================
echo                    CORRECTION ERREUR GRADLE
echo ========================================================================
echo.

set ANDROID_HOME=C:\Android
set CURRENT_DIR=%CD%

echo ETAPE 1: Nettoyage du fichier local.properties...
echo.

:: Recreer le fichier local.properties proprement
echo sdk.dir=C:\\Android > android\local.properties
echo Fichier local.properties recree

echo ETAPE 2: Verification des variables d'environnement...
echo.

:: Configurer les variables d'environnement pour cette session
set ANDROID_HOME=C:\Android
set PATH=%PATH%;C:\Android\platform-tools;C:\Android\cmdline-tools\4.0\bin

echo ANDROID_HOME: %ANDROID_HOME%
echo PATH mis a jour pour cette session

echo ETAPE 3: Nettoyage des caches Gradle...
echo.

:: Supprimer les caches Gradle corrompus
if exist "%USERPROFILE%\.gradle\caches" (
    echo Suppression des caches Gradle...
    rmdir /s /q "%USERPROFILE%\.gradle\caches" 2>nul
    echo Caches Gradle supprimes
)

:: Nettoyer le projet Android
echo Nettoyage du projet Android...
cd android
if exist "build" (
    rmdir /s /q build 2>nul
    echo Dossier build supprime
)

:: Nettoyer avec gradlew
echo Execution du nettoyage Gradle...
call gradlew.bat clean
cd ..

echo ETAPE 4: Verification de la connexion de l'appareil...
echo.

:: Verifier la connexion ADB
C:\Android\platform-tools\adb.exe devices
echo.

echo ETAPE 5: Configuration optimisee de Gradle...
echo.

:: Creer un gradle.properties optimise
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
echo systemProp.https.socketTimeout=60000
echo systemProp.https.connectionTimeout=60000
) > android\gradle.properties

echo Configuration Gradle optimisee

echo ETAPE 6: Test de compilation...
echo.

echo Tentative de compilation...
echo Cela peut prendre quelques minutes...
echo.

:: Essayer de compiler
cd android
call gradlew.bat assembleDebug
set BUILD_RESULT=%errorlevel%
cd ..

if %BUILD_RESULT% equ 0 (
    echo ✓ Compilation reussie !
    echo.
    echo Maintenant, essayez:
    echo   npm run android
) else (
    echo ✗ Compilation echouee
    echo.
    echo Solutions alternatives:
    echo 1. Redemarrez votre terminal PowerShell
    echo 2. Executez: set ANDROID_HOME=C:\Android
    echo 3. Reessayez: npm run android
    echo.
    echo Ou essayez directement:
    echo   cd android
    echo   gradlew.bat installDebug
)

echo.
echo ========================================================================
echo                           CORRECTION TERMINEE
echo ========================================================================
echo.

pause
