import 'dart:convert';
import 'package:http/http.dart' as http;  
import '../models/transaction.dart';

class ApiService {
  // Remplacez par l'adresse IP de votre serveur Flask
  static const String baseUrl = 'http://10.0.2.2:5000'; // Pour l'émulateur Android

  // --- AUTH ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'mot_de_passe': password}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> register(String nom, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nom': nom, 'email': email, 'mot_de_passe': password}),
    );
    return jsonDecode(response.body);
  }

  // --- DASHBOARD ---
  Future<Map<String, dynamic>> getDashboard(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard?user_id=$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erreur lors de la récupération du tableau de bord');
  }

  // --- REVENUS ---
  Future<List<Transaction>> getRevenus(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/revenus?user_id=$userId'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Transaction.fromJson(data, 'revenu')).toList();
    }
    throw Exception('Erreur lors de la récupération des revenus');
  }

  Future<void> addRevenu(Transaction transaction) async {
    await http.post(
      Uri.parse('$baseUrl/revenus'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );
  }

  Future<void> updateRevenu(Transaction transaction) async {
    await http.put(
      Uri.parse('$baseUrl/revenus/${transaction.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );
  }

  Future<void> deleteRevenu(int id) async {
    await http.delete(Uri.parse('$baseUrl/revenus/$id'));
  }

  // --- DEPENSES ---
  Future<List<Transaction>> getDepenses(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/depenses?user_id=$userId'));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Transaction.fromJson(data, 'depense')).toList();
    }
    throw Exception('Erreur lors de la récupération des dépenses');
  }

  Future<void> addDepense(Transaction transaction) async {
    await http.post(
      Uri.parse('$baseUrl/depenses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );
  }

  Future<void> updateDepense(Transaction transaction) async {
    await http.put(
      Uri.parse('$baseUrl/depenses/${transaction.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );
  }

  Future<void> deleteDepense(int id) async {
    await http.delete(Uri.parse('$baseUrl/depenses/$id'));
  }

  // --- BUDGET ---
  Future<double> getBudget(int userId, String mois) async {
    final response = await http.get(Uri.parse('$baseUrl/budget?user_id=$userId&mois=$mois'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return double.parse(data['montant'].toString());
    }
    return 0.0;
  }

  Future<void> setBudget(int userId, double montant, String mois) async {
    await http.post(
      Uri.parse('$baseUrl/budget'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'utilisateur_id': userId,
        'montant': montant,
        'mois': mois,
      }),
    );
  }
}
