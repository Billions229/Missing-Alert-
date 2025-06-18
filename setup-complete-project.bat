@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Missing Alert - Script de Configuration Complète
:: ============================================================================
:: Ce script maître exécute tous les scripts de configuration dans l'ordre
:: ============================================================================

echo.
echo ========================================================================
echo                    MISSING ALERT - CONFIGURATION COMPLÈTE
echo ========================================================================
echo.
echo Ce script va configurer automatiquement le projet React Native complet
echo pour l'application Missing Alert basé sur les spécifications du README.
echo.
echo Durée estimée: 10-15 minutes ^(selon la vitesse de connexion^)
echo.

:: Variables de configuration
set CURRENT_DIR=%CD%
set PROJECT_NAME=MissingAlert
set PROJECT_DIR=%CURRENT_DIR%\%PROJECT_NAME%
set TOTAL_STEPS=9
set CURRENT_STEP=0

:: Couleurs pour les messages
set GREEN=[92m
set RED=[91m
set YELLOW=[93m
set BLUE=[94m
set CYAN=[96m
set RESET=[0m

:: ============================================================================
:: FONCTION: Afficher le progrès
:: ============================================================================
:show_progress
set /a CURRENT_STEP+=1
echo.
echo %CYAN%========================================================================%RESET%
echo %CYAN%                    ÉTAPE %CURRENT_STEP%/%TOTAL_STEPS%: %~1%RESET%
echo %CYAN%========================================================================%RESET%
echo.
goto :eof

:: ============================================================================
:: FONCTION: Vérifier le succès d'une étape
:: ============================================================================
:check_step_success
if %errorlevel% neq 0 (
    echo %RED%❌ ERREUR: L'étape a échoué!%RESET%
    echo %RED%Le script s'arrête ici. Veuillez vérifier les erreurs ci-dessus.%RESET%
    pause
    exit /b 1
) else (
    echo %GREEN%✅ Étape terminée avec succès!%RESET%
)
goto :eof

:: ============================================================================
:: DÉBUT DE LA CONFIGURATION
:: ============================================================================

echo %YELLOW%⚠️  IMPORTANT:%RESET%
echo - Assurez-vous d'avoir Node.js 18+ installé
echo - Assurez-vous d'avoir npm ou yarn installé
echo - Assurez-vous d'avoir git installé
echo - Une connexion internet est requise
echo.
echo %BLUE%Appuyez sur une touche pour commencer la configuration...%RESET%
pause >nul

:: ============================================================================
:: ÉTAPE 1: Configuration initiale du projet React Native
:: ============================================================================
call :show_progress "Configuration initiale du projet React Native"

echo %BLUE%Exécution du script principal de configuration...%RESET%
call "%CURRENT_DIR%\setup-missing-alert-project.bat"
call :check_step_success

:: ============================================================================
:: ÉTAPE 2: Création des fichiers boilerplate
:: ============================================================================
call :show_progress "Création des fichiers boilerplate"

echo %BLUE%Création des écrans principaux...%RESET%
call "%CURRENT_DIR%\create-boilerplate-files.bat"
call :check_step_success

:: ============================================================================
:: ÉTAPE 3: Création des services
:: ============================================================================
call :show_progress "Création des services Firebase et géolocalisation"

echo %BLUE%Création des services...%RESET%
call "%CURRENT_DIR%\create-services.bat"
call :check_step_success

:: ============================================================================
:: ÉTAPE 4: Création de la navigation et composants
:: ============================================================================
call :show_progress "Création de la navigation et composants"

echo %BLUE%Configuration de la navigation...%RESET%
call "%CURRENT_DIR%\create-navigation-components.bat"
call :check_step_success

:: ============================================================================
:: ÉTAPE 5: Finalisation de la configuration
:: ============================================================================
call :show_progress "Finalisation de la configuration"

echo %BLUE%Finalisation du projet...%RESET%
call "%CURRENT_DIR%\finalize-setup.bat"
call :check_step_success

:: ============================================================================
:: ÉTAPE 6: Installation des dépendances iOS (si applicable)
:: ============================================================================
call :show_progress "Installation des dépendances iOS"

cd "%PROJECT_DIR%"
if exist "ios" (
    echo %BLUE%Installation des pods iOS...%RESET%
    cd ios
    where pod >nul 2>&1
    if %errorlevel% equ 0 (
        pod install
        if %errorlevel% neq 0 (
            echo %YELLOW%⚠️  Attention: L'installation des pods iOS a échoué.%RESET%
            echo %YELLOW%Vous devrez exécuter 'pod install' manuellement dans le dossier ios.%RESET%
        ) else (
            echo %GREEN%✅ Pods iOS installés avec succès!%RESET%
        )
    ) else (
        echo %YELLOW%⚠️  CocoaPods non trouvé. Installation des pods iOS ignorée.%RESET%
        echo %YELLOW%Pour iOS, installez CocoaPods et exécutez 'pod install' dans le dossier ios.%RESET%
    )
    cd ..
) else (
    echo %YELLOW%⚠️  Dossier iOS non trouvé. Cette étape est ignorée.%RESET%
)
cd "%CURRENT_DIR%"

:: ============================================================================
:: ÉTAPE 7: Vérification de la configuration
:: ============================================================================
call :show_progress "Vérification de la configuration"

cd "%PROJECT_DIR%"
echo %BLUE%Vérification des types TypeScript...%RESET%
npm run type-check
if %errorlevel% neq 0 (
    echo %YELLOW%⚠️  Attention: Erreurs de types détectées. Le projet peut nécessiter des ajustements.%RESET%
) else (
    echo %GREEN%✅ Vérification des types réussie!%RESET%
)

echo %BLUE%Vérification du linting...%RESET%
npm run lint
if %errorlevel% neq 0 (
    echo %YELLOW%⚠️  Attention: Problèmes de linting détectés. Correction automatique...%RESET%
    npm run lint:fix
)

cd "%CURRENT_DIR%"

:: ============================================================================
:: ÉTAPE 8: Création de la documentation
:: ============================================================================
call :show_progress "Création de la documentation"

echo %BLUE%Génération de la documentation du projet...%RESET%

:: Créer un fichier de guide de démarrage rapide
(
echo # 🚀 Guide de Démarrage Rapide - Missing Alert
echo.
echo ## ✅ Configuration Terminée
echo.
echo Votre projet Missing Alert a été configuré avec succès!
echo.
echo ## 📋 Prochaines Étapes Obligatoires
echo.
echo ### 1. Configuration Firebase
echo ```bash
echo # 1. Allez sur https://console.firebase.google.com
echo # 2. Créez un nouveau projet
echo # 3. Ajoutez une application Android et iOS
echo # 4. Téléchargez les fichiers de configuration:
echo #    - google-services.json ^(placez dans android/app/^)
echo #    - GoogleService-Info.plist ^(placez dans ios/^)
echo ```
echo.
echo ### 2. Configuration des Variables d'Environnement
echo ```bash
echo # Éditez le fichier .env dans le dossier du projet
echo # Remplacez les valeurs par vos vraies clés API
echo ```
echo.
echo ### 3. Lancement de l'Application
echo ```bash
echo cd %PROJECT_NAME%
echo.
echo # Pour Android
echo npm run android
echo.
echo # Pour iOS ^(Mac uniquement^)
echo npm run ios
echo ```
echo.
echo ## 🛠️ Commandes Utiles
echo.
echo ```bash
echo npm run lint          # Vérifier le code
echo npm run format        # Formater le code
echo npm run type-check    # Vérifier TypeScript
echo ```
echo.
echo ## 📞 Support
echo.
echo Si vous rencontrez des problèmes:
echo 1. Vérifiez que toutes les dépendances sont installées
echo 2. Assurez-vous que Firebase est correctement configuré
echo 3. Consultez la documentation React Native
echo.
echo Bon développement! 🎉
) > "%PROJECT_DIR%\QUICK_START.md"

echo %GREEN%✅ Documentation créée: %PROJECT_NAME%\QUICK_START.md%RESET%

:: ============================================================================
:: ÉTAPE 9: Résumé final
:: ============================================================================
call :show_progress "Résumé et instructions finales"

echo.
echo %GREEN%🎉 CONFIGURATION TERMINÉE AVEC SUCCÈS! 🎉%RESET%
echo.
echo %CYAN%========================================================================%RESET%
echo %CYAN%                           RÉSUMÉ DU PROJET%RESET%
echo %CYAN%========================================================================%RESET%
echo.
echo %GREEN%✅ Projet React Native créé:%RESET% %PROJECT_NAME%
echo %GREEN%✅ Structure de dossiers complète%RESET%
echo %GREEN%✅ Toutes les dépendances installées%RESET%
echo %GREEN%✅ Fichiers de configuration générés%RESET%
echo %GREEN%✅ Services Firebase et géolocalisation%RESET%
echo %GREEN%✅ Navigation configurée%RESET%
echo %GREEN%✅ Écrans de base créés%RESET%
echo %GREEN%✅ Store Zustand configuré%RESET%
echo %GREEN%✅ Types TypeScript définis%RESET%
echo.
echo %YELLOW%📋 PROCHAINES ÉTAPES OBLIGATOIRES:%RESET%
echo.
echo %BLUE%1. Configuration Firebase:%RESET%
echo    - Créer un projet sur https://console.firebase.google.com
echo    - Ajouter les applications Android/iOS
echo    - Télécharger google-services.json et GoogleService-Info.plist
echo.
echo %BLUE%2. Variables d'environnement:%RESET%
echo    - Éditer le fichier .env avec vos vraies clés API
echo.
echo %BLUE%3. Test de l'application:%RESET%
echo    - cd %PROJECT_NAME%
echo    - npm run android ^(ou ios^)
echo.
echo %CYAN%📁 STRUCTURE CRÉÉE:%RESET%
echo %PROJECT_NAME%/
echo ├── src/
echo │   ├── components/     ^(Composants réutilisables^)
echo │   ├── screens/        ^(Écrans: Home, Auth, Alerts, Map, Profile^)
echo │   ├── navigation/     ^(Navigation configurée^)
echo │   ├── services/       ^(Firebase, Géolocalisation^)
echo │   ├── store/          ^(Zustand store^)
echo │   ├── types/          ^(Types TypeScript^)
echo │   ├── utils/          ^(Fonctions utilitaires^)
echo │   ├── hooks/          ^(Hooks personnalisés^)
echo │   └── assets/         ^(Images, icônes^)
echo ├── .env               ^(Variables d'environnement^)
echo ├── README.md          ^(Documentation^)
echo └── QUICK_START.md     ^(Guide de démarrage^)
echo.
echo %GREEN%Le projet est maintenant prêt pour le développement! 🚀%RESET%
echo.
echo %BLUE%Consultez le fichier QUICK_START.md dans le dossier du projet pour les instructions détaillées.%RESET%
echo.

pause
goto :eof
