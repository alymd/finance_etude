import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_finance_etudiante/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
  });
}
