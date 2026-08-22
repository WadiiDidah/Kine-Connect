import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'phone_auth_service.dart';
import 'registration_code_screen.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  String _phoneNumber = '';
  bool _hidePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _continueRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    if (_phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le numéro de téléphone est obligatoire.')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await Firebase.initializeApp();
      await sendVerificationCode(_phoneNumber);

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RegistrationCodeScreen(
            login: _loginController.text.trim(),
            password: _passwordController.text,
            num: _phoneNumber,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte patient')),
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
                    Image.asset('assets/officiel.png', height: 110),
                    const SizedBox(height: 24),
                    const Text(
                      'Inscription patient',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Créez votre accès puis validez votre numéro par SMS.',
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
                      validator: (value) => value == null || value.length < 6
                          ? '6 caractères minimum'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    IntlPhoneField(
                      decoration: const InputDecoration(
                        labelText: 'Numéro de téléphone',
                        border: OutlineInputBorder(),
                      ),
                      initialCountryCode: 'FR',
                      onChanged: (value) => _phoneNumber = value.completeNumber,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _continueRegistration,
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Continuer'),
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
