import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'api/api_client.dart';
import 'practitioner_home_screen.dart';

class PractitionerLoginScreen extends StatefulWidget {
  const PractitionerLoginScreen({Key? key}) : super(key: key);

  @override
  State<PractitionerLoginScreen> createState() => _PractitionerLoginScreenState();
}

class _PractitionerLoginScreenState extends State<PractitionerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await ApiClient.authenticate(
        login: _loginController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (response.body != 'false') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PractitionerHomeScreen()),
        );
        return;
      }

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Connexion impossible',
        text: 'Identifiant ou mot de passe incorrect.',
        confirmBtnText: 'OK',
      );
    } catch (_) {
      if (!mounted) return;
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Service indisponible',
        text: 'Impossible de contacter le service de connexion.',
        confirmBtnText: 'OK',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('assets/officiel.png', height: 120),
                    const SizedBox(height: 28),
                    const Text(
                      'Espace kinésithérapeute',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connectez-vous pour gérer vos patients et vos rendez-vous.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF64748B), height: 1.5),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _loginController,
                      decoration: const InputDecoration(
                        labelText: 'Identifiant',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Identifiant obligatoire'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Mot de passe obligatoire'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _signIn,
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Se connecter'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
