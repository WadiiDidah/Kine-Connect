# Kiné Connect

Application Flutter de suivi entre kinésithérapeutes et patients.

Kiné Connect centralise la gestion des patients, des rendez-vous et des séances dans une application mobile pensée pour rester simple à utiliser et conserver certaines données localement.

## Fonctionnalités

- Parcours distinct kinésithérapeute / patient
- Connexion et inscription patient
- Vérification du téléphone avec Firebase Authentication
- Liste et recherche de patients
- Gestion des rendez-vous
- Calendrier interactif
- Suivi des séances
- Visualisation de l'évolution
- Stockage local des données avec SQLite
- Communication avec une API REST Node.js
- Interface Flutter responsive

## Stack technique

- Flutter / Dart
- Node.js / Express
- Firebase Authentication
- API REST / HTTP
- SQLite avec `sqflite`
- TableCalendar
- FL Chart
- Material Design

## Architecture

```text
Flutter
│
├── API REST Node.js
│   └── Patients
│
├── Firebase
│   └── Authentification / vérification téléphone
│
└── SQLite
    ├── Rendez-vous
    └── Séances / suivi local
```

SQLite permet notamment de conserver les rendez-vous et données de suivi localement, afin qu'une partie de l'application reste exploitable sans connexion réseau.

## Structure

```text
lib/
├── api/
│   └── api_client.dart
├── config/
│   └── api_config.dart
├── data/
│   ├── appointment_database.dart
│   └── session_database.dart
├── introduction_screen.dart
├── profile_choice_screen.dart
├── practitioner_login_screen.dart
├── practitioner_home_screen.dart
├── patient_login_screen.dart
├── patient_registration_screen.dart
├── patient_home_screen.dart
├── patient_list_screen.dart
├── patient_session_screen.dart
├── patient_detail_screen.dart
├── appointment_calendar_screen.dart
├── progress_chart_screen.dart
├── login_code_screen.dart
├── registration_code_screen.dart
├── phone_auth_service.dart
├── app_bottom_navigation.dart
└── main.dart

server/
├── server.js
└── package.json
```

## Installation

### API Node.js

```bash
cd server
npm install
npm start
```

L'API est lancée par défaut sur le port `3000`.

### Application Flutter

Dans un second terminal :

```bash
flutter pub get
flutter run
```

## Configuration API

L'adresse de l'API n'est pas directement dispersée dans le code de l'application.

Elle est centralisée dans :

```text
lib/config/api_config.dart
```

L'adresse peut être fournie au lancement :

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:3000
```

Cela permet d'utiliser une configuration différente selon l'environnement sans modifier les appels HTTP de l'application.

## Firebase

La vérification du numéro de téléphone repose sur Firebase Authentication.

Pour exécuter cette fonctionnalité dans un nouvel environnement, la configuration Firebase de la plateforme ciblée doit être renseignée.

## Stockage local

Les rendez-vous et les données de suivi sont stockés localement avec SQLite.

Les accès à la base sont regroupés dans :

```text
lib/data/
```

Cette séparation permet de garder la logique de persistance indépendante des écrans Flutter.