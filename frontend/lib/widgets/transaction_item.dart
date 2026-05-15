import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isRevenu = transaction['type'] == 'revenu';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isRevenu ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
          child: Icon(
            isRevenu ? Icons.arrow_upward : Icons.arrow_downward,
            color: isRevenu ? Colors.green : Colors.red,
          ),
        ),
        title: Text(transaction['categorie']),
        subtitle: Text(transaction['date']),
        trailing: Text(
          '${isRevenu ? "+" : "-"}${transaction['montant']} MRU',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isRevenu ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
