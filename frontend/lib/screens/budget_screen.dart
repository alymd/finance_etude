import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/finance_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final finance = Provider.of<FinanceProvider>(context, listen: false);
    _budgetController.text = finance.currentBudget.toString();
  }

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Budget Mensuel')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Définissez votre budget pour ce mois',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _budgetController,
              decoration: const InputDecoration(
                labelText: 'Montant du budget (MRU)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await finance.updateBudget(user!.id, double.parse(_budgetController.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Budget mis à jour avec succès')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                ),
                child: const Text('ENREGISTRER LE BUDGET'),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Résumé du mois',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Budget défini', '${finance.currentBudget} MRU'),
            _buildInfoRow('Dépenses actuelles', '${finance.dashboardData?['total_depenses'] ?? 0} MRU'),
            const Divider(),
            _buildInfoRow(
              'Reste à dépenser', 
              '${(finance.currentBudget - (finance.dashboardData?['total_depenses'] ?? 0)).toStringAsFixed(2)} MRU',
              isBold: true,
              color: (finance.currentBudget - (finance.dashboardData?['total_depenses'] ?? 0)) < 0 ? Colors.red : Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value, 
            style: TextStyle(
              fontSize: 16, 
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            )
          ),
        ],
      ),
    );
  }
}
