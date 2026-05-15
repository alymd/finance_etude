import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;
  final String? subtitle;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                Icon(icon, color: Colors.white70, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${amount.toStringAsFixed(2)} MRU',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  color: subtitle!.contains('dépassé') ? Colors.redAccent.shade100 : Colors.white60,
                  fontSize: 12,
                  fontWeight: subtitle!.contains('dépassé') ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
