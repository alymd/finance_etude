// lib/models/utilisateur.dart

class Utilisateur {
  final int id;
  final String nom;
  final String email;
  final String role;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.email,
    required this.role,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      role: json['role'] ?? 'etudiant',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'email': email,
    'role': role,
  };
  
  bool get estAdmin => role == 'admin';
}


// lib/models/revenu.dart
class Revenu {
  final int? id;
  final int utilisateurId;
  final double montant;
  final String categorie;
  final String description;
  final String date;

  Revenu({
    this.id,
    required this.utilisateurId,
    required this.montant,
    required this.categorie,
    required this.description,
    required this.date,
  });

  factory Revenu.fromJson(Map<String, dynamic> json) {
    return Revenu(
      id: json['id'],
      utilisateurId: json['utilisateur_id'] ?? 0,
      montant: (json['montant'] as num).toDouble(),
      categorie: json['categorie'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'utilisateur_id': utilisateurId,
    'montant': montant,
    'categorie': categorie,
    'description': description,
    'date': date,
  };
  
  Revenu copyWith({
    int? id,
    double? montant,
    String? categorie,
    String? description,
    String? date,
  }) => Revenu(
    id: id ?? this.id,
    utilisateurId: utilisateurId,
    montant: montant ?? this.montant,
    categorie: categorie ?? this.categorie,
    description: description ?? this.description,
    date: date ?? this.date,
  );
}


// lib/models/depense.dart
class Depense {
  final int? id;
  final int utilisateurId;
  final double montant;
  final String categorie;
  final String description;
  final String date;

  Depense({
    this.id,
    required this.utilisateurId,
    required this.montant,
    required this.categorie,
    required this.description,
    required this.date,
  });

  factory Depense.fromJson(Map<String, dynamic> json) {
    return Depense(
      id: json['id'],
      utilisateurId: json['utilisateur_id'] ?? 0,
      montant: (json['montant'] as num).toDouble(),
      categorie: json['categorie'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'utilisateur_id': utilisateurId,
    'montant': montant,
    'categorie': categorie,
    'description': description,
    'date': date,
  };
  
  Depense copyWith({
    int? id,
    double? montant,
    String? categorie,
    String? description,
    String? date,
  }) => Depense(
    id: id ?? this.id,
    utilisateurId: utilisateurId,
    montant: montant ?? this.montant,
    categorie: categorie ?? this.categorie,
    description: description ?? this.description,
    date: date ?? this.date,
  );
}


// lib/models/budget.dart
class Budget {
  final int? id;
  final int utilisateurId;
  final double montant;
  final String mois;
  final double depenses;
  final double restant;
  final bool depasse;
  final double pourcentage;

  Budget({
    this.id,
    required this.utilisateurId,
    required this.montant,
    required this.mois,
    this.depenses = 0,
    this.restant = 0,
    this.depasse = false,
    this.pourcentage = 0,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      utilisateurId: json['utilisateur_id'] ?? 0,
      montant: (json['montant'] as num).toDouble(),
      mois: json['mois'] ?? '',
      depenses: (json['depenses'] as num?)?.toDouble() ?? 0,
      restant: (json['restant'] as num?)?.toDouble() ?? 0,
      depasse: json['depasse'] == true,
      pourcentage: (json['pourcentage'] as num?)?.toDouble() ?? 0,
    );
  }
}


// lib/models/dashboard_data.dart
class DashboardData {
  final double solde;
  final double totalRevenus;
  final double totalDepenses;
  final String moisActuel;
  final double revenusMois;
  final double depensesMois;
  final double budgetMensuel;
  final double budgetRestant;
  final bool budgetDepasse;
  final double pourcentageBudget;
  final List<Map<String, dynamic>> dernieresTransactions;
  final List<Map<String, dynamic>> statsCategories;
  final List<Map<String, dynamic>> evolutionMensuelle;

  DashboardData({
    required this.solde,
    required this.totalRevenus,
    required this.totalDepenses,
    required this.moisActuel,
    required this.revenusMois,
    required this.depensesMois,
    required this.budgetMensuel,
    required this.budgetRestant,
    required this.budgetDepasse,
    required this.pourcentageBudget,
    required this.dernieresTransactions,
    required this.statsCategories,
    required this.evolutionMensuelle,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      solde: (json['solde'] as num).toDouble(),
      totalRevenus: (json['total_revenus'] as num).toDouble(),
      totalDepenses: (json['total_depenses'] as num).toDouble(),
      moisActuel: json['mois_actuel'] ?? '',
      revenusMois: (json['revenus_mois'] as num).toDouble(),
      depensesMois: (json['depenses_mois'] as num).toDouble(),
      budgetMensuel: (json['budget_mensuel'] as num).toDouble(),
      budgetRestant: (json['budget_restant'] as num).toDouble(),
      budgetDepasse: json['budget_depasse'] == true,
      pourcentageBudget: (json['pourcentage_budget'] as num).toDouble(),
      dernieresTransactions: List<Map<String, dynamic>>.from(
        json['dernieres_transactions'] ?? []
      ),
      statsCategories: List<Map<String, dynamic>>.from(
        json['stats_categories'] ?? []
      ),
      evolutionMensuelle: List<Map<String, dynamic>>.from(
        json['evolution_mensuelle'] ?? []
      ),
    );
  }
  
  // Solde avec couleur
  bool get soldePositif => solde >= 0;
}
