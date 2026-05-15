import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/finance_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);
    final stats = finance.dashboardData?['stats_categories'] as List? ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: stats.isEmpty
          ? const Center(child: Text('Aucune donnée à afficher'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Répartition des Dépenses',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sections: stats.asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.cyan];
                          return PieChartSectionData(
                            color: colors[index % colors.length],
                            value: double.parse(data['total'].toString()),
                            title: '${data['categorie']}\n${data['total']} MRU',
                            radius: 100,
                            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: ListView.builder(
                      itemCount: stats.length,
                      itemBuilder: (ctx, i) {
                        final data = stats[i];
                        final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.cyan];
                        return ListTile(
                          leading: Container(width: 16, height: 16, color: colors[i % colors.length]),
                          title: Text(data['categorie']),
                          trailing: Text('${data['total']} MRU', style: const TextStyle(fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
