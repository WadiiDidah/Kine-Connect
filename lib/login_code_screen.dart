import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'patient_home_screen.dart';
import 'phone_auth_service.dart';

class LoginCodeScreen extends StatefulWidget {
  final String login;
  final String password;
  final String num;

  const LoginCodeScreen({
    Key? key,
    required this.login,
    required this.password,
    required this.num,
  }) : super(key: key);

  @override
  State<LoginCodeScreen> createState() => _LoginCodeScreenState();
}

class _LoginCodeScreenState extends State<LoginCodeScreen> {
  String _code = '';
  bool _loading = false;

  Future<void> _verify() async {
    if (_code.length != 6) return;

    setState(() => _loading = true);
    final result = await verifyCode(_code);

    if (!mounted) return;
    setState(() => _loading = false);

    if (result == 'true') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
        (route) => false,
      );
      return;
    }

    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Code incorrect',
      text: 'Vérifiez le code reçu par SMS puis réessayez.',
      confirmBtnText: 'OK',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vérification')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/officiel.png', height: 110),
                const SizedBox(height: 24),
                const Text(
                  'Vérification du téléphone',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'Saisissez le code reçu sur ${widget.num}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 28),
                Pinput(
                  length: 6,
                  onChanged: (value) => _code = value,
                  onCompleted: (value) => _code = value,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _verify,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Vérifier le code'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
