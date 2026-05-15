import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final result = await Provider.of<AuthProvider>(context, listen: false)
          .register(_nomController.text, _emailController.text, _passwordController.text);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );

      if (result['message'].contains('succès')) {
        Navigator.of(context).pop();
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
      appBar: AppBar(title: const Text('Inscription')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom complet',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value!.isEmpty ? 'Veuillez entrer votre nom' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => !value!.contains('@') ? 'Email invalide' : null,
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
                        child: const Text('S\'INSCRIRE'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
