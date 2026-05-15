import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final result = await Provider.of<AuthProvider>(context, listen: false)
          .login(_emailController.text, _passwordController.text);
      
      if (result['user'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Erreur de connexion')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une erreur est survenue')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_balance_wallet, size: 80, color: Color(0xFF1A237E)),
                const SizedBox(height: 20),
                const Text(
                  'Gestion Financière',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                ),
                const Text('Connectez-vous pour continuer'),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer votre email' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? 'Minimum 6 caractères' : null,
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A237E),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('SE CONNECTER'),
                        ),
                      ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: const Text('Pas de compte ? Inscrivez-vous'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
