import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class FinanceProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Map<String, dynamic>? _dashboardData;
  List<Transaction> _revenus = [];
  List<Transaction> _depenses = [];
  double _currentBudget = 0.0;
  bool _isLoading = false;

  Map<String, dynamic>? get dashboardData => _dashboardData;
  List<Transaction> get revenus => _revenus;
  List<Transaction> get depenses => _depenses;
  double get currentBudget => _currentBudget;
  bool get isLoading => _isLoading;

  Future<void> fetchDashboard(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _dashboardData = await _apiService.getDashboard(userId);
      _currentBudget = _dashboardData!['budget_mensuel'];
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchRevenus(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _revenus = await _apiService.getRevenus(userId);
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDepenses(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _depenses = await _apiService.getDepenses(userId);
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    if (transaction.type == 'revenu') {
      await _apiService.addRevenu(transaction);
    } else {
      await _apiService.addDepense(transaction);
    }
    await fetchDashboard(transaction.utilisateurId);
  }

  Future<void> deleteTransaction(int id, String type, int userId) async {
    if (type == 'revenu') {
      await _apiService.deleteRevenu(id);
    } else {
      await _apiService.deleteDepense(id);
    }
    await fetchDashboard(userId);
  }

  Future<void> updateBudget(int userId, double montant) async {
    String mois = DateFormat('yyyy-MM-01').format(DateTime.now());
    await _apiService.setBudget(userId, montant, mois);
    await fetchDashboard(userId);
  }
}
