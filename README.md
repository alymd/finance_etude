📚 Gestion Financière Étudiante

Application mobile développée avec Flutter et Flask permettant aux étudiants de gérer facilement leurs finances personnelles.

---

🚀 Fonctionnalités
 • 🔐 Authentification (connexion / inscription)
 • 💰 Gestion des revenus
 • 💸 Gestion des dépenses
 • 📊 Tableau de bord financier
 • 📈 Statistiques et suivi du budget
 • 🗄️ Stockage des données avec MySQL

---

🛠️ Technologies Utilisées

Frontend
 • Flutter
 • Dart
 • Material Design

Backend
 • Flask
 • Python
 • Flask-CORS

Base de données
 • MySQL

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
git clone <url-du-repository>
cd gestion-financiere-etudiante
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

Projet réalisé dans le cadre d’un projet universitaire en informatique.
