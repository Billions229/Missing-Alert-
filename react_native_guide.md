# Guide d'installation React Native sur Windows sans Android Studio

## Prérequis
- Windows 10/11
- VS Code installé
- Au moins 8 GB de RAM disponible
- Connexion internet stable

## Étape 1 : Installer Chocolatey

Ouvrez PowerShell en tant qu'administrateur et exécutez :

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

## Étape 2 : Installer Node.js et Java

Dans l'invite de commande (en tant qu'administrateur) :

```cmd
choco install -y nodejs.install openjdk8
```

## Étape 3 : Installer React Native CLI

```cmd
npm install -g react-native-cli
# ou avec yarn
yarn global add react-native-cli
```

## Étape 4 : Télécharger et configurer Android SDK

### 4.1 Télécharger SDK Command Line Tools
1. Allez sur : https://developer.android.com/studio#command-tools
2. Téléchargez "Command line tools only"
3. Créez un dossier `C:\Android`
4. Décompressez le fichier dans `C:\Android\cmdline-tools`

### 4.2 Structurer les dossiers correctement
1. Ouvrez le fichier `source.properties` dans les fichiers décompressés
2. Notez la version (ex: 4.0)
3. Créez un dossier avec cette version : `C:\Android\cmdline-tools\4.0`
4. Déplacez tous les fichiers décompressés dans ce dossier

La structure finale : `C:\Android\cmdline-tools\4.0\bin`

## Étape 5 : Configurer les variables d'environnement

### 5.1 Accéder aux variables d'environnement
1. Clic droit sur "Ce PC" → Propriétés
2. Paramètres système avancés
3. Variables d'environnement

### 5.2 Ajouter les variables
**Variables système :**
- `ANDROID_HOME` : `C:\Android`
- `JAVA_HOME` : Chemin vers votre installation Java (généralement `C:\Program Files\OpenJDK\openjdk-8...`)

**Path (ajouter ces chemins) :**
- `C:\Android\cmdline-tools\4.0\bin`
- `C:\Android\cmdline-tools\4.0`
- `C:\Android\platform-tools`

## Étape 6 : Installer les packages Android SDK

Ouvrez une nouvelle invite de commande et exécutez :

### 6.1 Platform Tools (ADB & Fastboot)
```cmd
sdkmanager "platform-tools"
```

### 6.2 Android Platform (API 30 recommandé)
```cmd
sdkmanager "platforms;android-30"
```

### 6.3 System Images
```cmd
sdkmanager "system-images;android-30;google_apis;x86_64"
```

### 6.4 Build Tools
```cmd
sdkmanager "build-tools;30.0.3"
```

## Étape 7 : Créer votre premier projet React Native

```cmd
npx react-native init MonProjet
cd MonProjet
```

## Étape 8 : Configurer votre appareil Android

### Option A : Appareil physique
1. Activez le mode développeur sur votre téléphone
2. Activez le débogage USB
3. Connectez votre téléphone via USB
4. Vérifiez la connexion : `adb devices`

### Option B : Émulateur (optionnel)
```cmd
# Installer l'émulateur
sdkmanager --channel=3 emulator

# Créer un émulateur
avdmanager create avd -n MonEmulateur -k "system-images;android-30;google_apis;x86_64"

# Lancer l'émulateur
emulator -avd MonEmulateur
```

## Étape 9 : Extensions VS Code recommandées

Installez ces extensions dans VS Code :
- React Native Tools
- ES7+ React/Redux/React-Native snippets
- React-Native/React/Redux snippets for es6/es7
- Auto Rename Tag
- Bracket Pair Colorizer
- Prettier - Code formatter

## Étape 10 : Lancer votre application

Dans le dossier de votre projet :

```cmd
# Démarrer Metro bundler
npx react-native start

# Dans un nouveau terminal, lancer sur Android
npx react-native run-android
```

## Commandes utiles

```cmd
# Lister tous les packages disponibles
sdkmanager --list

# Lister les packages installés
sdkmanager --list_installed

# Mettre à jour les packages
sdkmanager --update

# Vérifier les appareils connectés
adb devices

# Nettoyer le projet
cd android && ./gradlew clean
```

## Résolution des problèmes courants

### "adb not recognized"
- Vérifiez que `C:\Android\platform-tools` est dans votre PATH
- Redémarrez votre invite de commande

### "JAVA_HOME not set"
- Vérifiez la variable JAVA_HOME dans les variables d'environnement
- Redémarrez votre système après modification

### "SDK location not found"
- Créez un fichier `local.properties` dans le dossier `android/` de votre projet
- Ajoutez : `sdk.dir=C:\\Android`

### Problèmes de permissions
- Lancez l'invite de commande en tant qu'administrateur
- Sur votre téléphone, autorisez le débogage USB

## Configuration finale VS Code

Créez un fichier `.vscode/settings.json` dans votre projet :

```json
{
  "react-native-tools.showUserTips": false,
  "react-native-tools.projectRoot": "./",
  "emmet.includeLanguages": {
    "javascript": "javascriptreact"
  }
}
```

Félicitations ! Vous avez maintenant un environnement React Native fonctionnel sur Windows sans Android Studio, utilisable avec VS Code.