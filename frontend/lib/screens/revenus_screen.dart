import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/finance_provider.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class RevenusScreen extends StatefulWidget {
  const RevenusScreen({super.key});

  @override
  State<RevenusScreen> createState() => _RevenusScreenState();
}

class _RevenusScreenState extends State<RevenusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      Provider.of<FinanceProvider>(context, listen: false).fetchRevenus(user!.id);
    });
  }

  void _showAddDialog() {
    final amountController = TextEditingController();
    final descController = TextEditingController();
    String selectedCategory = 'Bourse';
    final categories = ['Bourse', 'Salaire', 'Cadeau', 'Aide Familiale', 'Autre'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter un Revenu'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Montant (MRU)'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => selectedCategory = val!,
                decoration: const InputDecoration(labelText: 'Catégorie'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final user = Provider.of<AuthProvider>(context, listen: false).user;
              final transaction = Transaction(
                utilisateurId: user!.id,
                montant: double.parse(amountController.text),
                categorie: selectedCategory,
                description: descController.text,
                date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                type: 'revenu',
              );
              await Provider.of<FinanceProvider>(context, listen: false).addTransaction(transaction);
              await Provider.of<FinanceProvider>(context, listen: false).fetchRevenus(user.id);
              Navigator.pop(ctx);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Revenus')),
      body: finance.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: finance.revenus.length,
              itemBuilder: (ctx, i) {
                final t = finance.revenus[i];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.add, color: Colors.green)),
                  title: Text(t.categorie),
                  subtitle: Text('${t.date} - ${t.description}'),
                  trailing: Text('+${t.montant} MRU', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  onLongPress: () async {
                    await finance.deleteTransaction(t.id!, 'revenu', user!.id);
                    await finance.fetchRevenus(user.id);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
