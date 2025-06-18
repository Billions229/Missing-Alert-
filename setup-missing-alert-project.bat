@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Missing Alert - Script de Configuration Automatique du Projet
:: ============================================================================
:: Ce script configure automatiquement un projet React Native complet
:: basé sur les spécifications du fichier missing-alert-app-readme.md
:: ============================================================================

echo.
echo ========================================================================
echo                    MISSING ALERT - SETUP AUTOMATIQUE
echo ========================================================================
echo.
echo Configuration d'un projet React Native complet pour l'application
echo d'alerte communautaire Missing Alert
echo.

:: Variables de configuration
set PROJECT_NAME=MissingAlert
set PROJECT_DIR=%CD%\%PROJECT_NAME%
set CURRENT_DIR=%CD%
set ERROR_COUNT=0

:: Couleurs pour les messages (si supportées)
set GREEN=[92m
set RED=[91m
set YELLOW=[93m
set BLUE=[94m
set RESET=[0m

:: ============================================================================
:: FONCTION: Afficher un message avec timestamp
:: ============================================================================
:log_message
echo %BLUE%[%time%]%RESET% %~1
goto :eof

:: ============================================================================
:: FONCTION: Afficher un message d'erreur
:: ============================================================================
:log_error
echo %RED%[ERREUR %time%]%RESET% %~1
set /a ERROR_COUNT+=1
goto :eof

:: ============================================================================
:: FONCTION: Afficher un message de succès
:: ============================================================================
:log_success
echo %GREEN%[SUCCES %time%]%RESET% %~1
goto :eof

:: ============================================================================
:: FONCTION: Vérifier si une commande existe
:: ============================================================================
:check_command
where %1 >nul 2>&1
if %errorlevel% neq 0 (
    call :log_error "Commande '%1' non trouvée. Veuillez l'installer."
    exit /b 1
)
goto :eof

:: ============================================================================
:: ÉTAPE 1: Vérification des prérequis
:: ============================================================================
call :log_message "ÉTAPE 1/8: Vérification des prérequis..."

call :check_command node
if %errorlevel% neq 0 goto :error_exit

call :check_command npm
if %errorlevel% neq 0 goto :error_exit

call :check_command git
if %errorlevel% neq 0 goto :error_exit

:: Vérifier la version de Node.js
for /f "tokens=1" %%i in ('node --version') do set NODE_VERSION=%%i
call :log_message "Node.js version détectée: %NODE_VERSION%"

call :log_success "Tous les prérequis sont satisfaits"

:: ============================================================================
:: ÉTAPE 2: Création du projet React Native
:: ============================================================================
call :log_message "ÉTAPE 2/8: Création du projet React Native..."

if exist "%PROJECT_DIR%" (
    call :log_message "Le dossier %PROJECT_NAME% existe déjà. Suppression..."
    rmdir /s /q "%PROJECT_DIR%"
)

call :log_message "Initialisation du projet React Native avec TypeScript..."
npx react-native@latest init %PROJECT_NAME% --template react-native-template-typescript
if %errorlevel% neq 0 (
    call :log_error "Échec de la création du projet React Native"
    goto :error_exit
)

cd "%PROJECT_DIR%"
call :log_success "Projet React Native créé avec succès"

:: ============================================================================
:: ÉTAPE 3: Installation des dépendances principales
:: ============================================================================
call :log_message "ÉTAPE 3/8: Installation des dépendances principales..."

call :log_message "Installation des dépendances de navigation..."
npm install @react-navigation/native @react-navigation/stack @react-navigation/bottom-tabs
if %errorlevel% neq 0 (
    call :log_error "Échec de l'installation des dépendances de navigation"
    goto :error_exit
)

call :log_message "Installation des dépendances React Native..."
npm install react-native-screens react-native-safe-area-context react-native-gesture-handler
if %errorlevel% neq 0 (
    call :log_error "Échec de l'installation des dépendances React Native"
    goto :error_exit
)

call :log_message "Installation des dépendances de gestion d'état..."
npm install zustand @reduxjs/toolkit react-redux
if %errorlevel% neq 0 (
    call :log_error "Échec de l'installation des dépendances de gestion d'état"
    goto :error_exit
)

call :log_message "Installation des dépendances de formulaires..."
npm install react-hook-form @hookform/resolvers yup
if %errorlevel% neq 0 (
    call :log_error "Échec de l'installation des dépendances de formulaires"
    goto :error_exit
)

call :log_success "Dépendances principales installées"

:: ============================================================================
:: ÉTAPE 4: Installation des dépendances Firebase et géolocalisation
:: ============================================================================
call :log_message "ÉTAPE 4/8: Installation des dépendances Firebase et géolocalisation..."

call :log_message "Installation de Firebase..."
npm install @react-native-firebase/app @react-native-firebase/auth @react-native-firebase/firestore @react-native-firebase/messaging @react-native-firebase/storage
if %errorlevel% neq 0 (
    call :log_error "Échec de l'installation de Firebase"
    goto :error_exit
)

call :log_message "Installation des dépendances de géolocalisation..."
npm install react-native-geolocation-service react-native-maps @react-native-community/geolocation
if %errorlevel% neq 0 (
    call :log_error "Échec de l'installation des dépendances de géolocalisation"
    goto :error_exit
)

call :log_message "Installation des dépendances d'images et médias..."
npm install react-native-image-picker react-native-image-crop-picker
if %errorlevel% neq 0 (
    call :log_error "Échec de l'installation des dépendances d'images"
    goto :error_exit
)

call :log_success "Dépendances Firebase et géolocalisation installées"

:: ============================================================================
:: ÉTAPE 5: Installation des dépendances de développement
:: ============================================================================
call :log_message "ÉTAPE 5/8: Installation des dépendances de développement..."

call :log_message "Installation des outils de développement..."
npm install --save-dev @types/react @types/react-native eslint prettier @typescript-eslint/eslint-plugin @typescript-eslint/parser
if %errorlevel% neq 0 (
    call :log_error "Échec de l'installation des outils de développement"
    goto :error_exit
)

call :log_message "Installation des outils de test..."
npm install --save-dev jest @testing-library/react-native @testing-library/jest-native
if %errorlevel% neq 0 (
    call :log_error "Échec de l'installation des outils de test"
    goto :error_exit
)

call :log_success "Dépendances de développement installées"

:: ============================================================================
:: ÉTAPE 6: Création de la structure de dossiers
:: ============================================================================
call :log_message "ÉTAPE 6/8: Création de la structure de dossiers..."

call :log_message "Création des dossiers principaux..."
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

call :log_message "Création des sous-dossiers pour les écrans..."
mkdir src\screens\auth 2>nul
mkdir src\screens\home 2>nul
mkdir src\screens\alerts 2>nul
mkdir src\screens\profile 2>nul
mkdir src\screens\map 2>nul

call :log_message "Création des sous-dossiers pour les composants..."
mkdir src\components\common 2>nul
mkdir src\components\forms 2>nul
mkdir src\components\alerts 2>nul
mkdir src\components\map 2>nul

call :log_message "Création des dossiers de services..."
mkdir src\services\firebase 2>nul
mkdir src\services\geolocation 2>nul
mkdir src\services\notifications 2>nul

call :log_success "Structure de dossiers créée"

:: ============================================================================
:: ÉTAPE 7: Création des fichiers de configuration
:: ============================================================================
call :log_message "ÉTAPE 7/8: Création des fichiers de configuration..."

:: Continuer avec la suite du script...
goto :continue_setup

:error_exit
call :log_error "Le script s'est arrêté à cause d'erreurs. Nombre d'erreurs: %ERROR_COUNT%"
pause
exit /b 1

:continue_setup

:: Création du fichier .env
call :log_message "Création du fichier de configuration .env..."
(
echo # Configuration Firebase
echo FIREBASE_API_KEY=your_api_key_here
echo FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
echo FIREBASE_PROJECT_ID=your_project_id
echo FIREBASE_STORAGE_BUCKET=your_project.appspot.com
echo FIREBASE_MESSAGING_SENDER_ID=your_sender_id
echo FIREBASE_APP_ID=your_app_id
echo.
echo # Configuration Google Maps
echo GOOGLE_MAPS_API_KEY=your_google_maps_api_key
echo.
echo # Configuration de l'environnement
echo NODE_ENV=development
echo API_BASE_URL=https://your-api-url.com
) > .env

:: Création du fichier .env.example
call :log_message "Création du fichier .env.example..."
copy .env .env.example >nul

:: Mise à jour du .gitignore
call :log_message "Mise à jour du fichier .gitignore..."
(
echo.
echo # Environment variables
echo .env
echo .env.local
echo .env.development.local
echo .env.test.local
echo .env.production.local
echo.
echo # Firebase
echo google-services.json
echo GoogleService-Info.plist
echo.
echo # IDE
echo .vscode/
echo .idea/
echo.
echo # Logs
echo *.log
echo npm-debug.log*
echo yarn-debug.log*
echo yarn-error.log*
) >> .gitignore

:: Configuration ESLint
call :log_message "Configuration d'ESLint..."
(
echo {
echo   "root": true,
echo   "extends": [
echo     "@react-native-community",
echo     "@typescript-eslint/recommended"
echo   ],
echo   "parser": "@typescript-eslint/parser",
echo   "plugins": ["@typescript-eslint"],
echo   "rules": {
echo     "@typescript-eslint/no-unused-vars": "error",
echo     "@typescript-eslint/explicit-function-return-type": "off",
echo     "react-native/no-inline-styles": "warn"
echo   }
echo }
) > .eslintrc.json

:: Configuration Prettier
call :log_message "Configuration de Prettier..."
(
echo {
echo   "semi": true,
echo   "trailingComma": "es5",
echo   "singleQuote": true,
echo   "printWidth": 80,
echo   "tabWidth": 2,
echo   "useTabs": false
echo }
) > .prettierrc

call :log_success "Fichiers de configuration créés"

:: ============================================================================
:: ÉTAPE 8: Création des fichiers boilerplate
:: ============================================================================
call :log_message "ÉTAPE 8/8: Création des fichiers boilerplate..."

:: Types principaux
call :log_message "Création des types TypeScript..."
(
echo export interface User {
echo   id: string;
echo   email: string;
echo   phone: string;
echo   name: string;
echo   userType: 'family' ^| 'volunteer' ^| 'super_observer' ^| 'authority';
echo   isVerified: boolean;
echo   createdAt: Date;
echo }
echo.
echo export interface Alert {
echo   id: string;
echo   personName: string;
echo   age: number;
echo   description: string;
echo   photoUrl: string;
echo   lastKnownLocation: Location;
echo   frequentPlaces: string[];
echo   status: 'pending' ^| 'validated' ^| 'resolved' ^| 'cancelled';
echo   createdBy: string;
echo   createdAt: Date;
echo   validatedAt?: Date;
echo   resolvedAt?: Date;
echo }
echo.
echo export interface Location {
echo   latitude: number;
echo   longitude: number;
echo   address?: string;
echo }
echo.
echo export interface Sighting {
echo   id: string;
echo   alertId: string;
echo   reportedBy: string;
echo   location: Location;
echo   photoUrl?: string;
echo   comment?: string;
echo   timestamp: Date;
echo }
) > src\types\index.ts

:: Store Zustand
call :log_message "Création du store Zustand..."
(
echo import { create } from 'zustand';
echo import { User, Alert } from '../types';
echo.
echo interface AppState {
echo   user: User ^| null;
echo   alerts: Alert[];
echo   isLoading: boolean;
echo   setUser: ^(user: User ^| null^) =^> void;
echo   setAlerts: ^(alerts: Alert[]^) =^> void;
echo   setLoading: ^(loading: boolean^) =^> void;
echo   addAlert: ^(alert: Alert^) =^> void;
echo   updateAlert: ^(id: string, updates: Partial^<Alert^>^) =^> void;
echo }
echo.
echo export const useAppStore = create^<AppState^>^(^(set^) =^> ^({
echo   user: null,
echo   alerts: [],
echo   isLoading: false,
echo   setUser: ^(user^) =^> set^({ user }^),
echo   setAlerts: ^(alerts^) =^> set^({ alerts }^),
echo   setLoading: ^(isLoading^) =^> set^({ isLoading }^),
echo   addAlert: ^(alert^) =^> set^(^(state^) =^> ^({
echo     alerts: [...state.alerts, alert]
echo   }^)^),
echo   updateAlert: ^(id, updates^) =^> set^(^(state^) =^> ^({
echo     alerts: state.alerts.map^(alert =^>
echo       alert.id === id ? { ...alert, ...updates } : alert
echo     ^)
echo   }^)^),
echo }^)^);
) > src\store\index.ts

call :log_success "Fichiers boilerplate créés"

:: ============================================================================
:: FINALISATION
:: ============================================================================
call :log_message "Finalisation de la configuration..."

:: Mise à jour du package.json avec des scripts personnalisés
call :log_message "Ajout de scripts personnalisés..."
npm pkg set scripts.lint="eslint . --ext .js,.jsx,.ts,.tsx"
npm pkg set scripts.lint:fix="eslint . --ext .js,.jsx,.ts,.tsx --fix"
npm pkg set scripts.format="prettier --write \"src/**/*.{js,jsx,ts,tsx}\""
npm pkg set scripts.type-check="tsc --noEmit"

call :log_success "Configuration terminée avec succès!"

echo.
echo ========================================================================
echo                           CONFIGURATION TERMINÉE
echo ========================================================================
echo.
echo %GREEN%✓ Projet React Native créé: %PROJECT_NAME%%RESET%
echo %GREEN%✓ Toutes les dépendances installées%RESET%
echo %GREEN%✓ Structure de dossiers créée%RESET%
echo %GREEN%✓ Fichiers de configuration générés%RESET%
echo %GREEN%✓ Fichiers boilerplate créés%RESET%
echo.
echo %YELLOW%PROCHAINES ÉTAPES:%RESET%
echo 1. Configurer Firebase dans votre console Firebase
echo 2. Mettre à jour le fichier .env avec vos clés API
echo 3. Ajouter google-services.json ^(Android^) et GoogleService-Info.plist ^(iOS^)
echo 4. Exécuter: cd %PROJECT_NAME% ^&^& npm run android ^(ou ios^)
echo.
echo %BLUE%STRUCTURE CRÉÉE:%RESET%
echo %PROJECT_NAME%/
echo ├── src/
echo │   ├── components/     ^(Composants réutilisables^)
echo │   ├── screens/        ^(Écrans de l'application^)
echo │   ├── navigation/     ^(Configuration de navigation^)
echo │   ├── services/       ^(Services Firebase, géolocalisation^)
echo │   ├── store/          ^(Gestion d'état Zustand^)
echo │   ├── types/          ^(Types TypeScript^)
echo │   ├── utils/          ^(Fonctions utilitaires^)
echo │   ├── hooks/          ^(Hooks personnalisés^)
echo │   └── assets/         ^(Images, icônes^)
echo ├── .env               ^(Variables d'environnement^)
echo ├── .eslintrc.json     ^(Configuration ESLint^)
echo └── .prettierrc        ^(Configuration Prettier^)
echo.
echo %GREEN%Le projet est prêt pour le développement!%RESET%
echo.

if %ERROR_COUNT% gtr 0 (
    echo %YELLOW%Attention: %ERROR_COUNT% erreur^(s^) détectée^(s^) pendant la configuration.%RESET%
    echo Veuillez vérifier les messages ci-dessus.
)

pause
goto :eof
