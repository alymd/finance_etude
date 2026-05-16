# 📚 Gestion Financière Étudiante

Application complète de gestion financière destinée aux étudiants, développée avec **Flutter** pour le frontend mobile et **Flask + MySQL** pour le backend API.

---

# 🚀 Présentation du Projet

Cette application permet aux étudiants de :

- Gérer leurs revenus
- Suivre leurs dépenses
- Définir un budget mensuel
- Visualiser leurs statistiques financières
- Consulter un tableau de bord dynamique
- Créer un compte et se connecter

Le projet utilise une architecture moderne séparant :

- **Frontend Mobile** → Flutter
- **Backend API** → Flask
- **Base de données** → MySQL

---

# 🛠️ Technologies Utilisées

## Frontend
- Flutter
- Dart
- Provider (gestion d’état)
- Material Design 3

## Backend
- Python
- Flask
- Flask-CORS
- MySQL Connector

## Base de données
- MySQL
  
---

📂 Structure du Projet
```bash
project/
│
├── lib/
│   ├── models/
│   ├── providers/
│   ├── screens/
│   ├── services/
│   ├── utils/
│   └── widgets/
│
├── database/
│   └── db_config.py
│
├── routes/
│   ├── auth.py
│   ├── transactions.py
│   ├── depenses.py
│   └── revenus.py
│
├── app.py
└── README.md
```
---

# ⚙️ Installation

## 1️⃣ Cloner le projet

```bash
git clone https://github.com/alymd/finance_etude.git
cd finance_etude
```

---

# 🐍 Installation du Backend Flask

## Installer les dépendances

```bash
pip install -r requirements.txt 
---

## Configurer la base de données

Créer une base MySQL :

```sql
CREATE DATABASE finance_etude;
```

---

## Configurer les variables d’environnement

Créer un fichier `.env` :

```env
DB_HOST=localhost
DB_NAME=finance_etude
DB_USER=root
DB_PASSWORD=
```

---

## Lancer le serveur Flask

```bash
python app.py
```

Le serveur démarre sur :

```bash
http://127.0.0.1:5000
```

---

# 📱 Installation du Frontend Flutter

## Installer les dépendances Flutter

```bash
flutter pub get
```

---

## Lancer l’application

```bash
flutter run
```

---

📸 Écrans Principaux
 • Connexion
 • Inscription
 • Dashboard
 • Revenus
 • Dépenses
 • Budget
 • Statistiques

⸻

👨‍💻 Auteur

