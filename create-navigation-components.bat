@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Missing Alert - Création de la navigation et composants
:: ============================================================================

echo.
echo ========================================================================
echo                    CRÉATION DE LA NAVIGATION ET COMPOSANTS
echo ========================================================================
echo.

set PROJECT_DIR=%CD%\MissingAlert
cd "%PROJECT_DIR%"

:: ============================================================================
:: Configuration de la navigation principale
:: ============================================================================
echo Création de la navigation principale...
(
echo import React from 'react';
echo import { NavigationContainer } from '@react-navigation/native';
echo import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
echo import { createStackNavigator } from '@react-navigation/stack';
echo import HomeScreen from '../screens/home/HomeScreen';
echo import CreateAlertScreen from '../screens/alerts/CreateAlertScreen';
echo import MapScreen from '../screens/map/MapScreen';
echo import ProfileScreen from '../screens/profile/ProfileScreen';
echo import AuthScreen from '../screens/auth/AuthScreen';
echo import { useAppStore } from '../store';
echo.
echo const Tab = createBottomTabNavigator^(^);
echo const Stack = createStackNavigator^(^);
echo.
echo const TabNavigator: React.FC = ^(^) =^> {
echo   return ^(
echo     ^<Tab.Navigator
echo       screenOptions={{
echo         tabBarActiveTintColor: '#ff4444',
echo         tabBarInactiveTintColor: '#999',
echo         headerShown: false,
echo       }}
echo     ^>
echo       ^<Tab.Screen
echo         name="Home"
echo         component={HomeScreen}
echo         options={{
echo           tabBarLabel: 'Accueil',
echo           tabBarIcon: ^({ color }^) =^> ^(
echo             ^<Text style={{ color, fontSize: 20 }}^>🏠^</Text^>
echo           ^),
echo         }}
echo       /^>
echo       ^<Tab.Screen
echo         name="CreateAlert"
echo         component={CreateAlertScreen}
echo         options={{
echo           tabBarLabel: 'Alerte',
echo           tabBarIcon: ^({ color }^) =^> ^(
echo             ^<Text style={{ color, fontSize: 20 }}^>🚨^</Text^>
echo           ^),
echo         }}
echo       /^>
echo       ^<Tab.Screen
echo         name="Map"
echo         component={MapScreen}
echo         options={{
echo           tabBarLabel: 'Carte',
echo           tabBarIcon: ^({ color }^) =^> ^(
echo             ^<Text style={{ color, fontSize: 20 }}^>🗺️^</Text^>
echo           ^),
echo         }}
echo       /^>
echo       ^<Tab.Screen
echo         name="Profile"
echo         component={ProfileScreen}
echo         options={{
echo           tabBarLabel: 'Profil',
echo           tabBarIcon: ^({ color }^) =^> ^(
echo             ^<Text style={{ color, fontSize: 20 }}^>👤^</Text^>
echo           ^),
echo         }}
echo       /^>
echo     ^</Tab.Navigator^>
echo   ^);
echo };
echo.
echo const AppNavigator: React.FC = ^(^) =^> {
echo   const { user } = useAppStore^(^);
echo.
echo   return ^(
echo     ^<NavigationContainer^>
echo       ^<Stack.Navigator screenOptions={{ headerShown: false }}^>
echo         {user ? ^(
echo           ^<Stack.Screen name="Main" component={TabNavigator} /^>
echo         ^) : ^(
echo           ^<Stack.Screen name="Auth" component={AuthScreen} /^>
echo         ^)}
echo       ^</Stack.Navigator^>
echo     ^</NavigationContainer^>
echo   ^);
echo };
echo.
echo export default AppNavigator;
) > src\navigation\AppNavigator.tsx

:: ============================================================================
:: Écran d'authentification
:: ============================================================================
echo Création de l'écran d'authentification...
(
echo import React, { useState } from 'react';
echo import {
echo   View,
echo   Text,
echo   StyleSheet,
echo   TextInput,
echo   TouchableOpacity,
echo   Alert,
echo } from 'react-native';
echo import FirebaseService from '../../services/firebase/FirebaseService';
echo import { useAppStore } from '../../store';
echo.
echo const AuthScreen: React.FC = ^(^) =^> {
echo   const [phoneNumber, setPhoneNumber] = useState^(''^);
echo   const [verificationCode, setVerificationCode] = useState^(''^);
echo   const [confirmation, setConfirmation] = useState^<any^>^(null^);
echo   const [loading, setLoading] = useState^(false^);
echo   const { setUser } = useAppStore^(^);
echo.
echo   const sendVerificationCode = async ^(^) =^> {
echo     if ^(!phoneNumber^) {
echo       Alert.alert^('Erreur', 'Veuillez entrer votre numéro de téléphone'^);
echo       return;
echo     }
echo.
echo     setLoading^(true^);
echo     try {
echo       const confirmationResult = await FirebaseService.signInWithPhone^(phoneNumber^);
echo       setConfirmation^(confirmationResult^);
echo       Alert.alert^('Succès', 'Code de vérification envoyé'^);
echo     } catch ^(error^) {
echo       Alert.alert^('Erreur', 'Impossible d'\''envoyer le code de vérification'^);
echo     } finally {
echo       setLoading^(false^);
echo     }
echo   };
echo.
echo   const confirmCode = async ^(^) =^> {
echo     if ^(!verificationCode^) {
echo       Alert.alert^('Erreur', 'Veuillez entrer le code de vérification'^);
echo       return;
echo     }
echo.
echo     setLoading^(true^);
echo     try {
echo       const user = await FirebaseService.confirmCode^(confirmation, verificationCode^);
echo       setUser^(user^);
echo     } catch ^(error^) {
echo       Alert.alert^('Erreur', 'Code de vérification invalide'^);
echo     } finally {
echo       setLoading^(false^);
echo     }
echo   };
echo.
echo   return ^(
echo     ^<View style={styles.container}^>
echo       ^<Text style={styles.title}^>Missing Alert^</Text^>
echo       ^<Text style={styles.subtitle}^>Connexion^</Text^>
echo.
echo       {!confirmation ? ^(
echo         ^<^>
echo           ^<TextInput
echo             style={styles.input}
echo             placeholder="Numéro de téléphone ^(+229...^)"
echo             value={phoneNumber}
echo             onChangeText={setPhoneNumber}
echo             keyboardType="phone-pad"
echo           /^>
echo           ^<TouchableOpacity
echo             style={styles.button}
echo             onPress={sendVerificationCode}
echo             disabled={loading}
echo           ^>
echo             ^<Text style={styles.buttonText}^>
echo               {loading ? 'Envoi...' : 'Envoyer le code'}
echo             ^</Text^>
echo           ^</TouchableOpacity^>
echo         ^<^/^>
echo       ^) : ^(
echo         ^<^>
echo           ^<Text style={styles.infoText}^>
echo             Code envoyé au {phoneNumber}
echo           ^</Text^>
echo           ^<TextInput
echo             style={styles.input}
echo             placeholder="Code de vérification"
echo             value={verificationCode}
echo             onChangeText={setVerificationCode}
echo             keyboardType="numeric"
echo             maxLength={6}
echo           /^>
echo           ^<TouchableOpacity
echo             style={styles.button}
echo             onPress={confirmCode}
echo             disabled={loading}
echo           ^>
echo             ^<Text style={styles.buttonText}^>
echo               {loading ? 'Vérification...' : 'Vérifier'}
echo             ^</Text^>
echo           ^</TouchableOpacity^>
echo         ^<^/^>
echo       ^)}
echo     ^</View^>
echo   ^);
echo };
echo.
echo const styles = StyleSheet.create^(^{
echo   container: {
echo     flex: 1,
echo     justifyContent: 'center',
echo     padding: 20,
echo     backgroundColor: '#f5f5f5',
echo   },
echo   title: {
echo     fontSize: 32,
echo     fontWeight: 'bold',
echo     textAlign: 'center',
echo     marginBottom: 10,
echo     color: '#ff4444',
echo   },
echo   subtitle: {
echo     fontSize: 18,
echo     textAlign: 'center',
echo     marginBottom: 40,
echo     color: '#333',
echo   },
echo   input: {
echo     backgroundColor: 'white',
echo     padding: 15,
echo     borderRadius: 8,
echo     marginBottom: 15,
echo     fontSize: 16,
echo   },
echo   button: {
echo     backgroundColor: '#ff4444',
echo     padding: 15,
echo     borderRadius: 8,
echo     marginBottom: 15,
echo   },
echo   buttonText: {
echo     color: 'white',
echo     textAlign: 'center',
echo     fontSize: 16,
echo     fontWeight: 'bold',
echo   },
echo   infoText: {
echo     textAlign: 'center',
echo     marginBottom: 20,
echo     color: '#666',
echo   },
echo }^);
echo.
echo export default AuthScreen;
) > src\screens\auth\AuthScreen.tsx

:: ============================================================================
:: Écran de carte
:: ============================================================================
echo Création de l'écran de carte...
(
echo import React, { useEffect, useState } from 'react';
echo import { View, StyleSheet, Text } from 'react-native';
echo import MapView, { Marker } from 'react-native-maps';
echo import { useAppStore } from '../../store';
echo import GeolocationService from '../../services/geolocation/GeolocationService';
echo import { Location } from '../../types';
echo.
echo const MapScreen: React.FC = ^(^) =^> {
echo   const { alerts } = useAppStore^(^);
echo   const [userLocation, setUserLocation] = useState^<Location ^| null^>^(null^);
echo.
echo   useEffect^(^(^) =^> {
echo     getCurrentLocation^(^);
echo   }, []^);
echo.
echo   const getCurrentLocation = async ^(^) =^> {
echo     try {
echo       const hasPermission = await GeolocationService.requestLocationPermission^(^);
echo       if ^(hasPermission^) {
echo         const location = await GeolocationService.getCurrentLocation^(^);
echo         setUserLocation^(location^);
echo       }
echo     } catch ^(error^) {
echo       console.error^('Erreur de géolocalisation:', error^);
echo     }
echo   };
echo.
echo   return ^(
echo     ^<View style={styles.container}^>
echo       {userLocation ? ^(
echo         ^<MapView
echo           style={styles.map}
echo           initialRegion={{
echo             latitude: userLocation.latitude,
echo             longitude: userLocation.longitude,
echo             latitudeDelta: 0.0922,
echo             longitudeDelta: 0.0421,
echo           }}
echo         ^>
echo           ^<Marker
echo             coordinate={userLocation}
echo             title="Votre position"
echo             pinColor="blue"
echo           /^>
echo           {alerts.map^(^(alert^) =^> ^(
echo             ^<Marker
echo               key={alert.id}
echo               coordinate={alert.lastKnownLocation}
echo               title={alert.personName}
echo               description={`${alert.age} ans - ${alert.description}`}
echo               pinColor="red"
echo             /^>
echo           ^)^)}
echo         ^</MapView^>
echo       ^) : ^(
echo         ^<View style={styles.loadingContainer}^>
echo           ^<Text^>Chargement de la carte...^</Text^>
echo         ^</View^>
echo       ^)}
echo     ^</View^>
echo   ^);
echo };
echo.
echo const styles = StyleSheet.create^(^{
echo   container: {
echo     flex: 1,
echo   },
echo   map: {
echo     flex: 1,
echo   },
echo   loadingContainer: {
echo     flex: 1,
echo     justifyContent: 'center',
echo     alignItems: 'center',
echo   },
echo }^);
echo.
echo export default MapScreen;
) > src\screens\map\MapScreen.tsx

:: ============================================================================
:: Écran de profil
:: ============================================================================
echo Création de l'écran de profil...
(
echo import React from 'react';
echo import {
echo   View,
echo   Text,
echo   StyleSheet,
echo   TouchableOpacity,
echo   Alert,
echo } from 'react-native';
echo import { useAppStore } from '../../store';
echo import FirebaseService from '../../services/firebase/FirebaseService';
echo.
echo const ProfileScreen: React.FC = ^(^) =^> {
echo   const { user, setUser } = useAppStore^(^);
echo.
echo   const handleSignOut = async ^(^) =^> {
echo     Alert.alert^(
echo       'Déconnexion',
echo       'Êtes-vous sûr de vouloir vous déconnecter ?',
echo       [
echo         { text: 'Annuler', style: 'cancel' },
echo         {
echo           text: 'Déconnexion',
echo           style: 'destructive',
echo           onPress: async ^(^) =^> {
echo             try {
echo               await FirebaseService.signOut^(^);
echo               setUser^(null^);
echo             } catch ^(error^) {
echo               Alert.alert^('Erreur', 'Impossible de se déconnecter'^);
echo             }
echo           },
echo         },
echo       ]
echo     ^);
echo   };
echo.
echo   return ^(
echo     ^<View style={styles.container}^>
echo       ^<Text style={styles.title}^>Profil^</Text^>
echo.
echo       {user ^&^& ^(
echo         ^<View style={styles.userInfo}^>
echo           ^<Text style={styles.userName}^>{user.name ^|^| 'Utilisateur'}^</Text^>
echo           ^<Text style={styles.userPhone}^>{user.phone}^</Text^>
echo           ^<Text style={styles.userType}^>
echo             Type: {user.userType === 'volunteer' ? 'Volontaire' : user.userType}
echo           ^</Text^>
echo         ^</View^>
echo       ^)}
echo.
echo       ^<TouchableOpacity style={styles.signOutButton} onPress={handleSignOut}^>
echo         ^<Text style={styles.signOutText}^>Déconnexion^</Text^>
echo       ^</TouchableOpacity^>
echo     ^</View^>
echo   ^);
echo };
echo.
echo const styles = StyleSheet.create^(^{
echo   container: {
echo     flex: 1,
echo     padding: 20,
echo     backgroundColor: '#f5f5f5',
echo   },
echo   title: {
echo     fontSize: 24,
echo     fontWeight: 'bold',
echo     textAlign: 'center',
echo     marginBottom: 30,
echo     color: '#333',
echo   },
echo   userInfo: {
echo     backgroundColor: 'white',
echo     padding: 20,
echo     borderRadius: 8,
echo     marginBottom: 30,
echo   },
echo   userName: {
echo     fontSize: 18,
echo     fontWeight: 'bold',
echo     marginBottom: 5,
echo     color: '#333',
echo   },
echo   userPhone: {
echo     fontSize: 16,
echo     color: '#666',
echo     marginBottom: 5,
echo   },
echo   userType: {
echo     fontSize: 14,
echo     color: '#999',
echo   },
echo   signOutButton: {
echo     backgroundColor: '#ff4444',
echo     padding: 15,
echo     borderRadius: 8,
echo   },
echo   signOutText: {
echo     color: 'white',
echo     textAlign: 'center',
echo     fontSize: 16,
echo     fontWeight: 'bold',
echo   },
echo }^);
echo.
echo export default ProfileScreen;
) > src\screens\profile\ProfileScreen.tsx

echo.
echo ✓ Navigation et composants créés avec succès!
echo.
echo Fichiers créés:
echo - src\navigation\AppNavigator.tsx
echo - src\screens\auth\AuthScreen.tsx
echo - src\screens\map\MapScreen.tsx
echo - src\screens\profile\ProfileScreen.tsx
echo.
pause
