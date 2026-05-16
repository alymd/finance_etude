import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/finance_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FinanceProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Gestion Financière Étudiante',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1A237E),
              primary: const Color(0xFF1A237E),
              secondary: const Color(0xFF0D47A1),
            ),
          ),
          home: auth.isAuthenticated 
            ? const DashboardScreen() 
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                    authResultSnapshot.connectionState == ConnectionState.waiting
                        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                        : const LoginScreen(),
              ),
          routes: {
            '/dashboard': (ctx) => const DashboardScreen(),
            '/login': (ctx) => const LoginScreen(),
          },
        ),
      ),
    );
  }
}
