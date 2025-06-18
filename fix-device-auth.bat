@echo off
echo ========================================================================
echo                    AUTORISATION APPAREIL ANDROID
echo ========================================================================
echo.

set ANDROID_HOME=C:\Android

echo ETAPE 1: Verification de la connexion de votre appareil...
echo.

:: Tester ADB
"%ANDROID_HOME%\platform-tools\adb.exe" devices
echo.

echo Si votre appareil apparait comme "unauthorized":
echo 1. Regardez l'ecran de votre telephone Infinix
echo 2. Vous devriez voir une popup "Autoriser le debogage USB ?"
echo 3. Cochez "Toujours autoriser depuis cet ordinateur"
echo 4. Appuyez sur "OK"
echo.

pause

echo ETAPE 2: Verification apres autorisation...
echo.

"%ANDROID_HOME%\platform-tools\adb.exe" devices
echo.

echo Si votre appareil apparait maintenant comme "device" (au lieu d'unauthorized),
echo vous pouvez tester votre application React Native !
echo.

echo ETAPE 3: Creation du fichier local.properties...
echo.

:: Creer le fichier local.properties
echo sdk.dir=C:\\Android > android\local.properties
echo Fichier local.properties cree dans android/

echo.
echo ========================================================================
echo                           PRET POUR LE TEST
echo ========================================================================
echo.
echo Votre configuration est maintenant prete !
echo.
echo Pour tester votre application Missing Alert:
echo   npm run android
echo.
echo Si ca ne marche pas encore:
echo 1. Redemarrez votre terminal PowerShell
echo 2. Verifiez que votre telephone est toujours connecte
echo 3. Reessayez: npm run android
echo.

pause
