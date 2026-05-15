# Étudiant Finance 💸

Un gestionnaire de finances personnelles développé avec Flutter, conçu spécifiquement pour les étudiants. Suivez vos revenus et dépenses, gérez vos budgets mensuels par catégorie et visualisez vos habitudes de consommation — le tout dans une application mobile claire et intuitive.

---

## Fonctionnalités

- **Tableau de bord** — Consultez votre solde actuel, le total des revenus et dépenses du mois, ainsi que vos 10 dernières transactions en un coup d'œil.
- **Transactions** — Historique complet avec icônes de catégorie, libellés et dates. Ajoutez une nouvelle entrée via un panneau coulissant.
- **Budget mensuel** — Définissez des plafonds de dépenses par catégorie et suivez votre consommation en temps réel grâce à une barre de progression.
- **Statistiques** — Un graphique en anneau dessiné sur mesure décompose vos dépenses par catégorie, avec une légende affichant les montants et pourcentages.

## Écrans

| Écran | Description |
|---|---|
| Tableau de bord | Solde, résumé revenus/dépenses, transactions récentes |
| Transactions | Liste complète de toutes les transactions |
| Budget | Plafonds mensuels par catégorie avec indicateurs de progression |
| Statistiques | Graphique en anneau de la répartition des dépenses |

## Stack technique

- **Flutter** (Dart SDK ≥ 3.0)
- **Material Design 3**
- **`ChangeNotifierProvider` personnalisé** — gestion d'état légère sans dépendance externe
- **`CustomPainter` personnalisé** — graphique en anneau dessiné manuellement (aucune bibliothèque de graphiques)
- **Police Nunito** — embarquée localement (Regular, Bold, ExtraBold)

## Structure du projet

```
lib/
├── main.dart                          # Point d'entrée & configuration du thème
├── state/
│   └── finance_state.dart             # État global : transactions, budgets, valeurs calculées
├── providers/
│   └── change_notifier_provider.dart  # Fournisseur d'état léger (InheritedWidget)
├── screens/
│   ├── main_shell.dart                # Navigation bas de page & routage
│   ├── dashboard_page.dart            # Écran d'accueil
│   ├── transactions_page.dart         # Liste des transactions
│   ├── budget_page.dart               # Budgets mensuels
│   └── stats_page.dart                # Statistiques de dépenses
└── widgets/
    ├── shared_widgets.dart            # Composants UI réutilisables
    ├── add_transaction_sheet.dart     # Panneau : ajouter une transaction
    └── add_budget_sheet.dart          # Panneau : ajouter un budget
assets/
└── fonts/
    ├── Nunito-Regular.ttf
    ├── Nunito-Bold.ttf
    └── Nunito-ExtraBold.ttf
```

## Modèle de données

**Transaction** — id, libellé, montant, type (`revenu` / `dépense`), catégorie, date.

**MonthlyBudget** — catégorie, plafond de dépense, montant dépensé (calculé automatiquement à partir des transactions du mois en cours).

**TransactionCategory** — alimentation, transport, loisirs, études, santé, shopping, loyer, salaire, bourse, autre. Chaque catégorie possède un libellé, une icône et une couleur.

> L'application est livrée avec des données de démonstration (bourse CROUS, job étudiant, et plusieurs dépenses) afin que l'interface soit déjà peuplée au premier lancement.

## Démarrage rapide

**Prérequis :** Flutter SDK ≥ 3.0 installé et un appareil ou émulateur connecté.

```bash
# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

Aucun package externe ni backend requis — tout fonctionne localement en mémoire.

## Devise

Les montants sont affichés en **MRU** (Ouguiya mauritanien). Pour changer le symbole de devise, recherchez `MRU` dans l'ensemble du projet et remplacez-le par le symbole souhaité.

## Remarques

- Les données sont **en mémoire uniquement** — elles sont réinitialisées à chaque redémarrage. Pour les persister entre les sessions, intégrez une base de données locale comme `sqflite` ou `hive`.
- L'interface est entièrement en **français**. Les chaînes de caractères sont écrites en dur ; extrayez-les dans des fichiers ARB et utilisez `flutter_localizations` pour ajouter le support multilingue.