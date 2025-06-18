@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Missing Alert - Création des services
:: ============================================================================

echo.
echo ========================================================================
echo                    CRÉATION DES SERVICES
echo ========================================================================
echo.

set PROJECT_DIR=%CD%\MissingAlert
cd "%PROJECT_DIR%"

:: ============================================================================
:: Service Firebase
:: ============================================================================
echo Création du service Firebase...
(
echo import auth^(^) from '@react-native-firebase/auth';
echo import firestore^(^) from '@react-native-firebase/firestore';
echo import storage^(^) from '@react-native-firebase/storage';
echo import messaging^(^) from '@react-native-firebase/messaging';
echo import { User, Alert, Sighting } from '../types';
echo.
echo class FirebaseService {
echo   // Authentication
echo   async signInWithPhone^(phoneNumber: string^): Promise^<any^> {
echo     try {
echo       const confirmation = await auth^(^).signInWithPhoneNumber^(phoneNumber^);
echo       return confirmation;
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de l'\''authentification:', error^);
echo       throw error;
echo     }
echo   }
echo.
echo   async confirmCode^(confirmation: any, code: string^): Promise^<User ^| null^> {
echo     try {
echo       const userCredential = await confirmation.confirm^(code^);
echo       const user = userCredential.user;
echo       
echo       // Créer ou mettre à jour le profil utilisateur
echo       const userDoc = await this.getUserProfile^(user.uid^);
echo       if ^(!userDoc^) {
echo         await this.createUserProfile^(user.uid, {
echo           email: user.email ^|^| '',
echo           phone: user.phoneNumber ^|^| '',
echo           name: '',
echo           userType: 'volunteer',
echo           isVerified: false,
echo           createdAt: new Date^(^),
echo         }^);
echo       }
echo       
echo       return userDoc;
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de la confirmation:', error^);
echo       throw error;
echo     }
echo   }
echo.
echo   async signOut^(^): Promise^<void^> {
echo     try {
echo       await auth^(^).signOut^(^);
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de la déconnexion:', error^);
echo       throw error;
echo     }
echo   }
echo.
echo   // User Management
echo   async createUserProfile^(uid: string, userData: Omit^<User, 'id'^>^): Promise^<void^> {
echo     try {
echo       await firestore^(^).collection^('users'^).doc^(uid^).set^({
echo         ...userData,
echo         createdAt: firestore.FieldValue.serverTimestamp^(^),
echo       }^);
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de la création du profil:', error^);
echo       throw error;
echo     }
echo   }
echo.
echo   async getUserProfile^(uid: string^): Promise^<User ^| null^> {
echo     try {
echo       const doc = await firestore^(^).collection^('users'^).doc^(uid^).get^(^);
echo       if ^(doc.exists^) {
echo         return { id: doc.id, ...doc.data^(^) } as User;
echo       }
echo       return null;
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de la récupération du profil:', error^);
echo       throw error;
echo     }
echo   }
echo.
echo   // Alert Management
echo   async createAlert^(alertData: Omit^<Alert, 'id' ^| 'createdAt'^>^): Promise^<string^> {
echo     try {
echo       const docRef = await firestore^(^).collection^('alerts'^).add^({
echo         ...alertData,
echo         createdAt: firestore.FieldValue.serverTimestamp^(^),
echo         status: 'pending',
echo       }^);
echo       return docRef.id;
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de la création de l'\''alerte:', error^);
echo       throw error;
echo     }
echo   }
echo.
echo   async getActiveAlerts^(^): Promise^<Alert[]^> {
echo     try {
echo       const snapshot = await firestore^(^)
echo         .collection^('alerts'^)
echo         .where^('status', 'in', ['validated', 'pending']^)
echo         .orderBy^('createdAt', 'desc'^)
echo         .get^(^);
echo       
echo       return snapshot.docs.map^(doc =^> ^({
echo         id: doc.id,
echo         ...doc.data^(^),
echo       }^)^) as Alert[];
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de la récupération des alertes:', error^);
echo       throw error;
echo     }
echo   }
echo.
echo   async updateAlertStatus^(alertId: string, status: Alert['status']^): Promise^<void^> {
echo     try {
echo       await firestore^(^).collection^('alerts'^).doc^(alertId^).update^({
echo         status,
echo         ..^(status === 'validated' ^&^& { validatedAt: firestore.FieldValue.serverTimestamp^(^) }^),
echo         ..^(status === 'resolved' ^&^& { resolvedAt: firestore.FieldValue.serverTimestamp^(^) }^),
echo       }^);
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de la mise à jour de l'\''alerte:', error^);
echo       throw error;
echo     }
echo   }
echo.
echo   // Sighting Management
echo   async createSighting^(sightingData: Omit^<Sighting, 'id' ^| 'timestamp'^>^): Promise^<string^> {
echo     try {
echo       const docRef = await firestore^(^).collection^('sightings'^).add^({
echo         ...sightingData,
echo         timestamp: firestore.FieldValue.serverTimestamp^(^),
echo       }^);
echo       return docRef.id;
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de la création du signalement:', error^);
echo       throw error;
echo     }
echo   }
echo.
echo   // File Upload
echo   async uploadImage^(uri: string, path: string^): Promise^<string^> {
echo     try {
echo       const reference = storage^(^).ref^(path^);
echo       await reference.putFile^(uri^);
echo       const downloadURL = await reference.getDownloadURL^(^);
echo       return downloadURL;
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de l'\''upload:', error^);
echo       throw error;
echo     }
echo   }
echo.
echo   // Notifications
echo   async requestNotificationPermission^(^): Promise^<boolean^> {
echo     try {
echo       const authStatus = await messaging^(^).requestPermission^(^);
echo       const enabled =
echo         authStatus === messaging.AuthorizationStatus.AUTHORIZED ^|^|
echo         authStatus === messaging.AuthorizationStatus.PROVISIONAL;
echo       return enabled;
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de la demande de permission:', error^);
echo       return false;
echo     }
echo   }
echo.
echo   async getFCMToken^(^): Promise^<string ^| null^> {
echo     try {
echo       const token = await messaging^(^).getToken^(^);
echo       return token;
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de la récupération du token FCM:', error^);
echo       return null;
echo     }
echo   }
echo.
echo   async subscribeToAlerts^(userLocation: { latitude: number; longitude: number }^): Promise^<void^> {
echo     try {
echo       // Logique pour s'abonner aux alertes basées sur la localisation
echo       await messaging^(^).subscribeToTopic^('alerts_general'^);
echo       // Ajouter la logique pour les topics géographiques
echo     } catch ^(error^) {
echo       console.error^('Erreur lors de l'\''abonnement aux alertes:', error^);
echo       throw error;
echo     }
echo   }
echo }
echo.
echo export default new FirebaseService^(^);
) > src\services\firebase\FirebaseService.ts

:: ============================================================================
:: Service de géolocalisation
:: ============================================================================
echo Création du service de géolocalisation...
(
echo import Geolocation from 'react-native-geolocation-service';
echo import { PermissionsAndroid, Platform } from 'react-native';
echo import { Location } from '../types';
echo.
echo class GeolocationService {
echo   async requestLocationPermission^(^): Promise^<boolean^> {
echo     if ^(Platform.OS === 'android'^) {
echo       try {
echo         const granted = await PermissionsAndroid.request^(
echo           PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
echo           {
echo             title: 'Permission de localisation',
echo             message: 'Cette application a besoin d'\''accéder à votre localisation pour fonctionner correctement.',
echo             buttonNeutral: 'Demander plus tard',
echo             buttonNegative: 'Annuler',
echo             buttonPositive: 'OK',
echo           }
echo         ^);
echo         return granted === PermissionsAndroid.RESULTS.GRANTED;
echo       } catch ^(error^) {
echo         console.error^('Erreur lors de la demande de permission:', error^);
echo         return false;
echo       }
echo     }
echo     return true; // iOS gère les permissions automatiquement
echo   }
echo.
echo   async getCurrentLocation^(^): Promise^<Location^> {
echo     return new Promise^(^(resolve, reject^) =^> {
echo       Geolocation.getCurrentPosition^(
echo         ^(position^) =^> {
echo           resolve^({
echo             latitude: position.coords.latitude,
echo             longitude: position.coords.longitude,
echo           }^);
echo         },
echo         ^(error^) =^> {
echo           console.error^('Erreur de géolocalisation:', error^);
echo           reject^(error^);
echo         },
echo         {
echo           enableHighAccuracy: true,
echo           timeout: 15000,
echo           maximumAge: 10000,
echo         }
echo       ^);
echo     }^);
echo   }
echo.
echo   async watchPosition^(callback: ^(location: Location^) =^> void^): Promise^<number^> {
echo     return Geolocation.watchPosition^(
echo       ^(position^) =^> {
echo         callback^({
echo           latitude: position.coords.latitude,
echo           longitude: position.coords.longitude,
echo         }^);
echo       },
echo       ^(error^) =^> {
echo         console.error^('Erreur de suivi de position:', error^);
echo       },
echo       {
echo         enableHighAccuracy: true,
echo         distanceFilter: 10, // Mise à jour tous les 10 mètres
echo         interval: 5000, // Mise à jour toutes les 5 secondes
echo       }
echo     ^);
echo   }
echo.
echo   clearWatch^(watchId: number^): void {
echo     Geolocation.clearWatch^(watchId^);
echo   }
echo.
echo   calculateDistance^(
echo     location1: Location,
echo     location2: Location
echo   ^): number {
echo     const R = 6371; // Rayon de la Terre en kilomètres
echo     const dLat = this.toRadians^(location2.latitude - location1.latitude^);
echo     const dLon = this.toRadians^(location2.longitude - location1.longitude^);
echo     const a =
echo       Math.sin^(dLat / 2^) * Math.sin^(dLat / 2^) +
echo       Math.cos^(this.toRadians^(location1.latitude^)^) *
echo         Math.cos^(this.toRadians^(location2.latitude^)^) *
echo         Math.sin^(dLon / 2^) *
echo         Math.sin^(dLon / 2^);
echo     const c = 2 * Math.atan2^(Math.sqrt^(a^), Math.sqrt^(1 - a^)^);
echo     return R * c;
echo   }
echo.
echo   private toRadians^(degrees: number^): number {
echo     return degrees * ^(Math.PI / 180^);
echo   }
echo.
echo   isWithinRadius^(
echo     userLocation: Location,
echo     alertLocation: Location,
echo     radiusKm: number
echo   ^): boolean {
echo     const distance = this.calculateDistance^(userLocation, alertLocation^);
echo     return distance ^<= radiusKm;
echo   }
echo }
echo.
echo export default new GeolocationService^(^);
) > src\services\geolocation\GeolocationService.ts

echo.
echo ✓ Services créés avec succès!
echo.
echo Services créés:
echo - src\services\firebase\FirebaseService.ts
echo - src\services\geolocation\GeolocationService.ts
echo.
pause
