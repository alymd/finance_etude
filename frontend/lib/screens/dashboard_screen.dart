import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/finance_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_item.dart';
import 'revenus_screen.dart';
import 'depenses_screen.dart';
import 'budget_screen.dart';
import 'stats_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null) {
        Provider.of<FinanceProvider>(context, listen: false).fetchDashboard(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(),
          ),
        ],
      ),
      body: finance.isLoading || finance.dashboardData == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => finance.fetchDashboard(user!.id),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour, ${user?.nom}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    SummaryCard(
                      title: 'Solde Actuel',
                      amount: finance.dashboardData!['solde'],
                      color: Colors.blue.shade900,
                      icon: Icons.account_balance_wallet,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: 'Revenus',
                            amount: finance.dashboardData!['total_revenus'],
                            color: Colors.green,
                            icon: Icons.arrow_upward,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SummaryCard(
                            title: 'Dépenses',
                            amount: finance.dashboardData!['total_depenses'],
                            color: Colors.red,
                            icon: Icons.arrow_downward,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SummaryCard(
                      title: 'Budget Mensuel',
                      amount: finance.dashboardData!['budget_mensuel'],
                      color: Colors.orange.shade800,
                      icon: Icons.pie_chart,
                      subtitle: finance.dashboardData!['total_depenses'] > finance.dashboardData!['budget_mensuel']
                          ? 'Budget dépassé !'
                          : 'Reste: ${(finance.dashboardData!['budget_mensuel'] - finance.dashboardData!['total_depenses']).toStringAsFixed(2)} MRU',
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Dernières Transactions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...finance.dashboardData!['dernieres_transactions'].map((t) => TransactionItem(transaction: t)).toList(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const RevenusScreen()));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => const DepensesScreen()));
          if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetScreen()));
          if (index == 4) Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsScreen()));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Revenus'),
          BottomNavigationBarItem(icon: Icon(Icons.remove_circle_outline), label: 'Dépenses'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }
}
