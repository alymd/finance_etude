// lib/utils/constantes.dart
// Constantes globales de l'application

import 'package:flutter/material.dart';

// ================================================
// URL de l'API Flask
// Modifier selon votre configuration réseau
// ================================================
class ApiConfig {
  // Pour émulateur Android : 10.0.2.2 (= localhost de la machine)
  // Pour appareil physique : adresse IP de votre machine (ex: 192.168.1.100)
  // Pour iOS Simulator : localhost ou 127.0.0.1
  static const String baseUrl = 'http://10.0.2.2:5000';
  
  // Routes API
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String dashboard = '$baseUrl/dashboard';
  static const String revenus = '$baseUrl/revenus';
  static const String depenses = '$baseUrl/depenses';
  static const String depensesStats = '$baseUrl/depenses/stats';
  static const String budget = '$baseUrl/budget';
}

// ================================================
// Thème de l'application
// ================================================
class AppTheme {
  // Couleurs principales
  static const Color primaire = Color(0xFF1A73E8);       // Bleu Google
  static const Color primaireClaire = Color(0xFF4A9EFF);
  static const Color primaireFonce = Color(0xFF0D47A1);
  static const Color accent = Color(0xFF00C853);          // Vert succès
  static const Color erreur = Color(0xFFE53935);          // Rouge erreur
  static const Color avertissement = Color(0xFFFF8F00);   // Orange alerte
  
  // Couleurs de fond
  static const Color fondClaire = Color(0xFFF8F9FA);
  static const Color fondBlanc = Color(0xFFFFFFFF);
  static const Color fondGris = Color(0xFFEEEEEE);
  
  // Couleurs de texte
  static const Color textePrincipal = Color(0xFF1A1A2E);
  static const Color texteSecondaire = Color(0xFF6B7280);
  static const Color texteClaire = Color(0xFF9CA3AF);
  
  // Couleurs des catégories
  static const Map<String, Color> couleursCategories = {
    'nourriture': Color(0xFFFF7043),
    'transport': Color(0xFF42A5F5),
    'internet': Color(0xFF7E57C2),
    'loisirs': Color(0xFFEC407A),
    'education': Color(0xFF26C6DA),
    'sante': Color(0xFF66BB6A),
    'logement': Color(0xFFFFCA28),
    'autres': Color(0xFF78909C),
    'bourse': Color(0xFF26A69A),
    'famille': Color(0xFFFF7043),
    'travail': Color(0xFF42A5F5),
    'freelance': Color(0xFF7E57C2),
    'vente': Color(0xFFEC407A),
  };
  
  // Dégradé principal
  static const LinearGradient degradePrincipal = LinearGradient(
    colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient degradeVert = LinearGradient(
    colors: [Color(0xFF00C853), Color(0xFF1B5E20)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient degradeRouge = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFF7F0000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Thème Material
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaire,
      brightness: Brightness.light,
    ),
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: fondClaire,
    appBarTheme: const AppBarTheme(
      backgroundColor: fondBlanc,
      foregroundColor: textePrincipal,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textePrincipal,
      ),
    ),
  
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaire,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: fondGris,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaire, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: erreur, width: 1),
      ),
      labelStyle: const TextStyle(color: texteSecondaire),
    ),
  );
}

// ================================================
// Catégories
// ================================================
class Categories {
  static const List<String> depenses = [
    'nourriture',
    'transport',
    'internet',
    'loisirs',
    'education',
    'sante',
    'logement',
    'autres',
  ];
  
  static const List<String> revenus = [
    'bourse',
    'famille',
    'travail',
    'freelance',
    'vente',
    'autres',
  ];
  
  static const Map<String, String> icones = {
    'nourriture': '🍽️',
    'transport': '🚌',
    'internet': '📱',
    'loisirs': '🎮',
    'education': '📚',
    'sante': '💊',
    'logement': '🏠',
    'autres': '📦',
    'bourse': '🎓',
    'famille': '👨‍👩‍👧',
    'travail': '💼',
    'freelance': '💻',
    'vente': '🛒',
  };
}

// ================================================
// Utilitaires de formatage
// ================================================
class FormatUtils {
  static String formatMontant(double montant) {
    if (montant >= 1000) {
      return '${montant.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]} ',
      )} MRU';
    }
    return '${montant.toStringAsFixed(2)} MRU';
  }
  
  static String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final mois = [
        'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
        'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
      ];
      return '${date.day} ${mois[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
  
  static String moisActuel() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }
  
  static String nomMois(String moisStr) {
    final mois = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    try {
      final parts = moisStr.split('-');
      final idx = int.parse(parts[1]) - 1;
      return '${mois[idx]} ${parts[0]}';
    } catch (_) {
      return moisStr;
    }
  }
}
