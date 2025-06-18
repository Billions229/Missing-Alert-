@echo off
setlocal enabledelayedexpansion

:: ============================================================================
:: Missing Alert - Création des fichiers boilerplate
:: ============================================================================
:: Ce script crée tous les fichiers boilerplate nécessaires pour l'application
:: ============================================================================

echo.
echo ========================================================================
echo                    CRÉATION DES FICHIERS BOILERPLATE
echo ========================================================================
echo.

set PROJECT_DIR=%CD%\MissingAlert
cd "%PROJECT_DIR%"

:: ============================================================================
:: Écran d'accueil (Home Screen)
:: ============================================================================
echo Création de l'écran d'accueil...
(
echo import React from 'react';
echo import {
echo   View,
echo   Text,
echo   StyleSheet,
echo   TouchableOpacity,
echo   FlatList,
echo   Image,
echo } from 'react-native';
echo import { useAppStore } from '../../store';
echo import { Alert } from '../../types';
echo.
echo const HomeScreen: React.FC = ^(^) =^> {
echo   const { alerts, user } = useAppStore^(^);
echo.
echo   const renderAlert = ^({ item }: { item: Alert }^) =^> ^(
echo     ^<TouchableOpacity style={styles.alertCard}^>
echo       ^<Image source={{ uri: item.photoUrl }} style={styles.alertImage} /^>
echo       ^<View style={styles.alertInfo}^>
echo         ^<Text style={styles.alertName}^>{item.personName}^</Text^>
echo         ^<Text style={styles.alertAge}^>{item.age} ans^</Text^>
echo         ^<Text style={styles.alertStatus}^>Disparue il y a 2h^</Text^>
echo       ^</View^>
echo     ^</TouchableOpacity^>
echo   ^);
echo.
echo   return ^(
echo     ^<View style={styles.container}^>
echo       ^<Text style={styles.title}^>Missing Alert^</Text^>
echo       
echo       ^<TouchableOpacity style={styles.createAlertButton}^>
echo         ^<Text style={styles.createAlertText}^>Créer une alerte^</Text^>
echo       ^</TouchableOpacity^>
echo.
echo       ^<Text style={styles.sectionTitle}^>🚨 Alertes Actives ^({alerts.length}^)^</Text^>
echo       
echo       ^<FlatList
echo         data={alerts}
echo         renderItem={renderAlert}
echo         keyExtractor={^(item^) =^> item.id}
echo         style={styles.alertsList}
echo       /^>
echo.
echo       ^<View style={styles.footer}^>
echo         ^<Text style={styles.footerText}^>📍 Votre Zone: Cotonou^</Text^>
echo         ^<Text style={styles.footerText}^>👥 1,247 volontaires^</Text^>
echo       ^</View^>
echo     ^</View^>
echo   ^);
echo };
echo.
echo const styles = StyleSheet.create^(^{
echo   container: {
echo     flex: 1,
echo     backgroundColor: '#f5f5f5',
echo     padding: 16,
echo   },
echo   title: {
echo     fontSize: 24,
echo     fontWeight: 'bold',
echo     textAlign: 'center',
echo     marginBottom: 20,
echo     color: '#333',
echo   },
echo   createAlertButton: {
echo     backgroundColor: '#ff4444',
echo     padding: 16,
echo     borderRadius: 8,
echo     marginBottom: 20,
echo   },
echo   createAlertText: {
echo     color: 'white',
echo     textAlign: 'center',
echo     fontSize: 16,
echo     fontWeight: 'bold',
echo   },
echo   sectionTitle: {
echo     fontSize: 18,
echo     fontWeight: 'bold',
echo     marginBottom: 12,
echo     color: '#333',
echo   },
echo   alertsList: {
echo     flex: 1,
echo   },
echo   alertCard: {
echo     backgroundColor: 'white',
echo     padding: 12,
echo     borderRadius: 8,
echo     marginBottom: 12,
echo     flexDirection: 'row',
echo     shadowColor: '#000',
echo     shadowOffset: { width: 0, height: 2 },
echo     shadowOpacity: 0.1,
echo     shadowRadius: 4,
echo     elevation: 3,
echo   },
echo   alertImage: {
echo     width: 60,
echo     height: 60,
echo     borderRadius: 30,
echo     marginRight: 12,
echo   },
echo   alertInfo: {
echo     flex: 1,
echo   },
echo   alertName: {
echo     fontSize: 16,
echo     fontWeight: 'bold',
echo     color: '#333',
echo   },
echo   alertAge: {
echo     fontSize: 14,
echo     color: '#666',
echo   },
echo   alertStatus: {
echo     fontSize: 12,
echo     color: '#999',
echo   },
echo   footer: {
echo     marginTop: 16,
echo     padding: 12,
echo     backgroundColor: 'white',
echo     borderRadius: 8,
echo   },
echo   footerText: {
echo     textAlign: 'center',
echo     color: '#666',
echo     marginBottom: 4,
echo   },
echo }^);
echo.
echo export default HomeScreen;
) > src\screens\home\HomeScreen.tsx

:: ============================================================================
:: Écran de création d'alerte
:: ============================================================================
echo Création de l'écran de création d'alerte...
(
echo import React, { useState } from 'react';
echo import {
echo   View,
echo   Text,
echo   StyleSheet,
echo   TextInput,
echo   TouchableOpacity,
echo   Image,
echo   ScrollView,
echo   Alert,
echo } from 'react-native';
echo import { useForm, Controller } from 'react-hook-form';
echo import { launchImageLibrary } from 'react-native-image-picker';
echo.
echo interface CreateAlertForm {
echo   name: string;
echo   age: string;
echo   height: string;
echo   clothing: string;
echo   lastLocation: string;
echo   frequentPlaces: string;
echo }
echo.
echo const CreateAlertScreen: React.FC = ^(^) =^> {
echo   const [selectedImage, setSelectedImage] = useState^<string ^| null^>^(null^);
echo   const { control, handleSubmit, formState: { errors } } = useForm^<CreateAlertForm^>^(^);
echo.
echo   const selectImage = ^(^) =^> {
echo     launchImageLibrary^({ mediaType: 'photo' }, ^(response^) =^> {
echo       if ^(response.assets ^&^& response.assets[0]^) {
echo         setSelectedImage^(response.assets[0].uri ^|^| null^);
echo       }
echo     }^);
echo   };
echo.
echo   const onSubmit = ^(data: CreateAlertForm^) =^> {
echo     if ^(!selectedImage^) {
echo       Alert.alert^('Erreur', 'Veuillez ajouter une photo'^);
echo       return;
echo     }
echo     // Logique de soumission
echo     console.log^('Données du formulaire:', data^);
echo     Alert.alert^('Succès', 'Alerte soumise pour validation'^);
echo   };
echo.
echo   return ^(
echo     ^<ScrollView style={styles.container}^>
echo       ^<Text style={styles.title}^>Signaler Disparition^</Text^>
echo.
echo       ^<TouchableOpacity style={styles.imageButton} onPress={selectImage}^>
echo         {selectedImage ? ^(
echo           ^<Image source={{ uri: selectedImage }} style={styles.selectedImage} /^>
echo         ^) : ^(
echo           ^<Text style={styles.imageButtonText}^>📷 Ajouter Photo^</Text^>
echo         ^)}
echo       ^</TouchableOpacity^>
echo.
echo       ^<Controller
echo         control={control}
echo         name="name"
echo         rules={{ required: 'Le nom est requis' }}
echo         render={^({ field: { onChange, value } }^) =^> ^(
echo           ^<TextInput
echo             style={styles.input}
echo             placeholder="Nom complet"
echo             value={value}
echo             onChangeText={onChange}
echo           /^>
echo         ^)}
echo       /^>
echo       {errors.name ^&^& ^<Text style={styles.errorText}^>{errors.name.message}^</Text^>}
echo.
echo       ^<Controller
echo         control={control}
echo         name="age"
echo         rules={{ required: 'L'\''âge est requis' }}
echo         render={^({ field: { onChange, value } }^) =^> ^(
echo           ^<TextInput
echo             style={styles.input}
echo             placeholder="Âge"
echo             value={value}
echo             onChangeText={onChange}
echo             keyboardType="numeric"
echo           /^>
echo         ^)}
echo       /^>
echo.
echo       ^<TouchableOpacity style={styles.submitButton} onPress={handleSubmit^(onSubmit^)}^>
echo         ^<Text style={styles.submitButtonText}^>Soumettre pour validation^</Text^>
echo       ^</TouchableOpacity^>
echo     ^</ScrollView^>
echo   ^);
echo };
echo.
echo const styles = StyleSheet.create^(^{
echo   container: {
echo     flex: 1,
echo     backgroundColor: '#f5f5f5',
echo     padding: 16,
echo   },
echo   title: {
echo     fontSize: 24,
echo     fontWeight: 'bold',
echo     textAlign: 'center',
echo     marginBottom: 20,
echo     color: '#333',
echo   },
echo   imageButton: {
echo     height: 150,
echo     backgroundColor: '#e0e0e0',
echo     borderRadius: 8,
echo     justifyContent: 'center',
echo     alignItems: 'center',
echo     marginBottom: 16,
echo   },
echo   imageButtonText: {
echo     fontSize: 16,
echo     color: '#666',
echo   },
echo   selectedImage: {
echo     width: '100%',
echo     height: '100%',
echo     borderRadius: 8,
echo   },
echo   input: {
echo     backgroundColor: 'white',
echo     padding: 12,
echo     borderRadius: 8,
echo     marginBottom: 12,
echo     fontSize: 16,
echo   },
echo   errorText: {
echo     color: '#ff4444',
echo     fontSize: 12,
echo     marginBottom: 8,
echo   },
echo   submitButton: {
echo     backgroundColor: '#ff4444',
echo     padding: 16,
echo     borderRadius: 8,
echo     marginTop: 20,
echo   },
echo   submitButtonText: {
echo     color: 'white',
echo     textAlign: 'center',
echo     fontSize: 16,
echo     fontWeight: 'bold',
echo   },
echo }^);
echo.
echo export default CreateAlertScreen;
) > src\screens\alerts\CreateAlertScreen.tsx

echo.
echo ✓ Fichiers boilerplate créés avec succès!
echo.
echo Fichiers créés:
echo - src\screens\home\HomeScreen.tsx
echo - src\screens\alerts\CreateAlertScreen.tsx
echo.
pause
