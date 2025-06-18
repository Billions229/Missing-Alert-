@echo off
setlocal enabledelayedexpansion

echo ========================================================================
echo                    MISSING ALERT - AJOUT DE LA STRUCTURE
echo ========================================================================
echo.
echo Ajout de la structure et des fichiers pour l'application Missing Alert
echo sur le projet React Native existant
echo.

set CURRENT_DIR=%CD%

echo Repertoire courant: %CURRENT_DIR%
echo.

echo ETAPE 1: Creation de la structure de dossiers...
echo.

:: Creation des dossiers principaux
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

:: Creation des sous-dossiers pour les ecrans
mkdir src\screens\auth 2>nul
mkdir src\screens\home 2>nul
mkdir src\screens\alerts 2>nul
mkdir src\screens\profile 2>nul
mkdir src\screens\map 2>nul

:: Creation des sous-dossiers pour les composants
mkdir src\components\common 2>nul
mkdir src\components\forms 2>nul
mkdir src\components\alerts 2>nul
mkdir src\components\map 2>nul

:: Creation des dossiers de services
mkdir src\services\firebase 2>nul
mkdir src\services\geolocation 2>nul
mkdir src\services\notifications 2>nul

echo Structure de dossiers creee!
echo.

echo ETAPE 2: Installation des dependances manquantes...
echo.

:: Verification et installation des dependances necessaires pour Missing Alert
echo Installation des dependances de navigation...
call npm install @react-navigation/native @react-navigation/stack @react-navigation/bottom-tabs react-native-screens react-native-safe-area-context react-native-gesture-handler

echo Installation des dependances de gestion d'etat...
call npm install zustand

echo Installation des dependances de formulaires...
call npm install react-hook-form @hookform/resolvers yup

echo Installation des dependances Firebase...
call npm install @react-native-firebase/app @react-native-firebase/auth @react-native-firebase/firestore @react-native-firebase/messaging @react-native-firebase/storage

echo Installation des dependances de geolocalisation...
call npm install react-native-geolocation-service react-native-maps @react-native-community/geolocation

echo Installation des dependances d'images...
call npm install react-native-image-picker react-native-image-crop-picker

echo Dependances installees!
echo.

echo ETAPE 3: Creation des fichiers de configuration...
echo.

:: Creation du fichier .env
echo Creation du fichier .env...
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

:: Creation du fichier .env.example
copy .env .env.example >nul

:: Mise a jour du .gitignore
echo Mise a jour du .gitignore...
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
) >> .gitignore

echo Fichiers de configuration crees!
echo.

echo ETAPE 4: Creation des types TypeScript...
echo.

:: Types principaux
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

echo Types TypeScript crees!
echo.

echo ETAPE 5: Creation du store Zustand...
echo.

:: Store Zustand
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

echo Store Zustand cree!
echo.

echo ETAPE 6: Creation des utilitaires...
echo.

:: Fonctions utilitaires
(
echo import { Alert } from '../types';
echo.
echo export const formatTimeAgo = ^(date: Date^): string =^> {
echo   const now = new Date^(^);
echo   const diffInMs = now.getTime^(^) - date.getTime^(^);
echo   const diffInHours = Math.floor^(diffInMs / ^(1000 * 60 * 60^)^);
echo   const diffInDays = Math.floor^(diffInHours / 24^);
echo.
echo   if ^(diffInHours ^< 1^) {
echo     const diffInMinutes = Math.floor^(diffInMs / ^(1000 * 60^)^);
echo     return `il y a ${diffInMinutes} minute^(s^)`;
echo   } else if ^(diffInHours ^< 24^) {
echo     return `il y a ${diffInHours} heure^(s^)`;
echo   } else {
echo     return `il y a ${diffInDays} jour^(s^)`;
echo   }
echo };
echo.
echo export const validatePhoneNumber = ^(phone: string^): boolean =^> {
echo   const phoneRegex = /^\+229[0-9]{8}$/;
echo   return phoneRegex.test^(phone^);
echo };
echo.
echo export const getAlertStatusText = ^(status: Alert['status']^): string =^> {
echo   switch ^(status^) {
echo     case 'pending':
echo       return 'En attente de validation';
echo     case 'validated':
echo       return 'Validee';
echo     case 'resolved':
echo       return 'Resolue';
echo     case 'cancelled':
echo       return 'Annulee';
echo     default:
echo       return 'Statut inconnu';
echo   }
echo };
) > src\utils\index.ts

echo Utilitaires crees!
echo.

echo ========================================================================
echo                           STRUCTURE AJOUTEE
echo ========================================================================
echo.
echo Structure de dossiers creee dans src/
echo Dependances Missing Alert installees
echo Fichiers de configuration crees
echo Types TypeScript definis
echo Store Zustand configure
echo Utilitaires crees
echo.
echo PROCHAINES ETAPES:
echo 1. Executer les autres scripts pour creer les ecrans et services
echo 2. Configurer Firebase
echo 3. Tester l'application
echo.
echo La structure de base est maintenant prete!
echo.

pause
