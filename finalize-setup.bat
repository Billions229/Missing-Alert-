@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Missing Alert - Finalisation de la configuration
:: ============================================================================

echo.
echo ========================================================================
echo                    FINALISATION DE LA CONFIGURATION
echo ========================================================================
echo.

set PROJECT_DIR=%CD%\MissingAlert
cd "%PROJECT_DIR%"

:: ============================================================================
:: Mise à jour du fichier App.tsx principal
:: ============================================================================
echo Mise à jour du fichier App.tsx...
(
echo import React, { useEffect } from 'react';
echo import { StatusBar } from 'react-native';
echo import AppNavigator from './src/navigation/AppNavigator';
echo import FirebaseService from './src/services/firebase/FirebaseService';
echo import GeolocationService from './src/services/geolocation/GeolocationService';
echo import { useAppStore } from './src/store';
echo.
echo const App: React.FC = ^(^) =^> {
echo   const { setLoading } = useAppStore^(^);
echo.
echo   useEffect^(^(^) =^> {
echo     initializeApp^(^);
echo   }, []^);
echo.
echo   const initializeApp = async ^(^) =^> {
echo     setLoading^(true^);
echo     
echo     try {
echo       // Demander les permissions de notification
echo       await FirebaseService.requestNotificationPermission^(^);
echo       
echo       // Demander les permissions de géolocalisation
echo       await GeolocationService.requestLocationPermission^(^);
echo       
echo       // Autres initialisations...
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de l'\''initialisation:', error^);
echo     } finally {
echo       setLoading^(false^);
echo     }
echo   };
echo.
echo   return ^(
echo     ^<^>
echo       ^<StatusBar barStyle="dark-content" backgroundColor="#f5f5f5" /^>
echo       ^<AppNavigator /^>
echo     ^<^/^>
echo   ^);
echo };
echo.
echo export default App;
) > App.tsx

:: ============================================================================
:: Création du fichier de configuration Firebase
:: ============================================================================
echo Création du fichier de configuration Firebase...
(
echo // Configuration Firebase pour React Native
echo // Ce fichier doit être configuré avec vos propres clés Firebase
echo.
echo import { FirebaseApp, initializeApp } from '@react-native-firebase/app';
echo.
echo const firebaseConfig = {
echo   apiKey: process.env.FIREBASE_API_KEY,
echo   authDomain: process.env.FIREBASE_AUTH_DOMAIN,
echo   projectId: process.env.FIREBASE_PROJECT_ID,
echo   storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
echo   messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
echo   appId: process.env.FIREBASE_APP_ID,
echo };
echo.
echo // Initialisation de Firebase
echo let app: FirebaseApp;
echo.
echo if ^(!app^) {
echo   app = initializeApp^(firebaseConfig^);
echo }
echo.
echo export default app;
) > src\services\firebase\config.ts

:: ============================================================================
:: Création des hooks personnalisés
:: ============================================================================
echo Création des hooks personnalisés...
(
echo import { useEffect, useState } from 'react';
echo import { Alert } from 'react-native';
echo import GeolocationService from '../services/geolocation/GeolocationService';
echo import { Location } from '../types';
echo.
echo export const useLocation = ^(^) =^> {
echo   const [location, setLocation] = useState^<Location ^| null^>^(null^);
echo   const [loading, setLoading] = useState^(true^);
echo   const [error, setError] = useState^<string ^| null^>^(null^);
echo.
echo   useEffect^(^(^) =^> {
echo     getCurrentLocation^(^);
echo   }, []^);
echo.
echo   const getCurrentLocation = async ^(^) =^> {
echo     try {
echo       setLoading^(true^);
echo       setError^(null^);
echo       
echo       const hasPermission = await GeolocationService.requestLocationPermission^(^);
echo       if ^(!hasPermission^) {
echo         throw new Error^('Permission de géolocalisation refusée'^);
echo       }
echo.
echo       const currentLocation = await GeolocationService.getCurrentLocation^(^);
echo       setLocation^(currentLocation^);
echo     } catch ^(err^) {
echo       const errorMessage = err instanceof Error ? err.message : 'Erreur de géolocalisation';
echo       setError^(errorMessage^);
echo       Alert.alert^('Erreur', errorMessage^);
echo     } finally {
echo       setLoading^(false^);
echo     }
echo   };
echo.
echo   return {
echo     location,
echo     loading,
echo     error,
echo     refreshLocation: getCurrentLocation,
echo   };
echo };
echo.
echo export const useAlerts = ^(^) =^> {
echo   const [alerts, setAlerts] = useState^([]^);
echo   const [loading, setLoading] = useState^(true^);
echo.
echo   useEffect^(^(^) =^> {
echo     // Logique pour récupérer les alertes
echo     // Cette fonction sera implémentée avec Firebase
echo   }, []^);
echo.
echo   return {
echo     alerts,
echo     loading,
echo   };
echo };
) > src\hooks\index.ts

:: ============================================================================
:: Création des utilitaires
:: ============================================================================
echo Création des fonctions utilitaires...
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
echo   // Validation pour les numéros béninois ^(+229^)
echo   const phoneRegex = /^\+229[0-9]{8}$/;
echo   return phoneRegex.test^(phone^);
echo };
echo.
echo export const getAlertStatusText = ^(status: Alert['status']^): string =^> {
echo   switch ^(status^) {
echo     case 'pending':
echo       return 'En attente de validation';
echo     case 'validated':
echo       return 'Validée';
echo     case 'resolved':
echo       return 'Résolue';
echo     case 'cancelled':
echo       return 'Annulée';
echo     default:
echo       return 'Statut inconnu';
echo   }
echo };
echo.
echo export const getAlertStatusColor = ^(status: Alert['status']^): string =^> {
echo   switch ^(status^) {
echo     case 'pending':
echo       return '#ff9800';
echo     case 'validated':
echo       return '#ff4444';
echo     case 'resolved':
echo       return '#4caf50';
echo     case 'cancelled':
echo       return '#9e9e9e';
echo     default:
echo       return '#333';
echo   }
echo };
) > src\utils\index.ts

:: ============================================================================
:: Création du fichier README du projet
:: ============================================================================
echo Création du README du projet...
(
echo # Missing Alert - Application Mobile
echo.
echo Application React Native pour l'alerte communautaire en cas de disparition.
echo.
echo ## 🚀 Installation
echo.
echo ```bash
echo # Installer les dépendances
echo npm install
echo.
echo # iOS
echo cd ios ^&^& pod install ^&^& cd ..
echo.
echo # Lancer l'application
echo npm run android  # Pour Android
echo npm run ios      # Pour iOS
echo ```
echo.
echo ## 📁 Structure du Projet
echo.
echo ```
echo src/
echo ├── components/          # Composants réutilisables
echo │   ├── common/         # Composants communs
echo │   ├── forms/          # Composants de formulaires
echo │   ├── alerts/         # Composants spécifiques aux alertes
echo │   └── map/            # Composants de carte
echo ├── screens/            # Écrans de l'application
echo │   ├── auth/           # Écrans d'authentification
echo │   ├── home/           # Écran d'accueil
echo │   ├── alerts/         # Écrans de gestion d'alertes
echo │   ├── map/            # Écran de carte
echo │   └── profile/        # Écran de profil
echo ├── navigation/         # Configuration de navigation
echo ├── services/           # Services ^(Firebase, géolocalisation^)
echo │   ├── firebase/       # Services Firebase
echo │   ├── geolocation/    # Services de géolocalisation
echo │   └── notifications/  # Services de notifications
echo ├── store/              # Gestion d'état ^(Zustand^)
echo ├── types/              # Types TypeScript
echo ├── utils/              # Fonctions utilitaires
echo ├── hooks/              # Hooks personnalisés
echo └── assets/             # Ressources ^(images, icônes^)
echo ```
echo.
echo ## 🔧 Configuration
echo.
echo ### 1. Firebase
echo 1. Créer un projet Firebase
echo 2. Ajouter les applications Android/iOS
echo 3. Télécharger les fichiers de configuration:
echo    - `google-services.json` ^(Android^)
echo    - `GoogleService-Info.plist` ^(iOS^)
echo 4. Mettre à jour le fichier `.env` avec vos clés
echo.
echo ### 2. Google Maps
echo 1. Obtenir une clé API Google Maps
echo 2. L'ajouter dans le fichier `.env`
echo 3. Configurer les permissions dans les fichiers natifs
echo.
echo ## 📱 Fonctionnalités Implémentées
echo.
echo - ✅ Authentification par SMS
echo - ✅ Navigation entre écrans
echo - ✅ Gestion d'état avec Zustand
echo - ✅ Services Firebase
echo - ✅ Géolocalisation
echo - ✅ Structure de base pour les alertes
echo.
echo ## 🔄 Prochaines Étapes
echo.
echo 1. Configurer Firebase dans la console
echo 2. Implémenter la logique métier complète
echo 3. Ajouter les tests
echo 4. Optimiser les performances
echo 5. Préparer pour la production
echo.
echo ## 🛠️ Scripts Disponibles
echo.
echo ```bash
echo npm run android         # Lancer sur Android
echo npm run ios             # Lancer sur iOS
echo npm run lint            # Vérifier le code
echo npm run lint:fix        # Corriger automatiquement
echo npm run format          # Formater le code
echo npm run type-check      # Vérifier les types TypeScript
echo ```
echo.
echo ## 📞 Support
echo.
echo Pour toute question ou problème, consultez la documentation ou contactez l'équipe de développement.
) > README.md

echo.
echo ✓ Configuration finalisée avec succès!
echo.
echo Fichiers créés/mis à jour:
echo - App.tsx ^(mis à jour^)
echo - src\services\firebase\config.ts
echo - src\hooks\index.ts
echo - src\utils\index.ts
echo - README.md
echo.
echo 🎉 Le projet Missing Alert est maintenant prêt pour le développement!
echo.
pause
