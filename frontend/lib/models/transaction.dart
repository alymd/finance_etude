class Transaction {
  final int? id;
  final int utilisateurId;
  final double montant;
  final String categorie;
  final String description;
  final String date;
  final String type; // 'revenu' ou 'depense'

  Transaction({
    this.id,
    required this.utilisateurId,
    required this.montant,
    required this.categorie,
    required this.description,
    required this.date,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json, String type) {
    return Transaction(
      id: json['id'],
      utilisateurId: json['utilisateur_id'],
      montant: double.parse(json['montant'].toString()),
      categorie: json['categorie'],
      description: json['description'] ?? '',
      date: json['date'],
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'utilisateur_id': utilisateurId,
      'montant': montant,
      'categorie': categorie,
      'description': description,
      'date': date,
    };
  }
}
