import 'package:flutter/material.dart';
import 'practitioner_login_screen.dart';
import 'patient_login_screen.dart';

class ProfileChoiceScreen extends StatelessWidget {
  const ProfileChoiceScreen({Key? key}) : super(key: key);
  Widget _profileCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE7EAF2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF1FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: const Color(0xFF4F61D7), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF1FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset('assets/officiel.png'),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Bienvenue',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choisissez votre espace pour accéder aux fonctionnalités adaptées à votre suivi.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  _profileCard(
                    context: context,
                    icon: Icons.medical_services_outlined,
                    title: 'Je suis kinésithérapeute',
                    description: 'Gérer les patients, les rendez-vous et le suivi des séances.',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PractitionerLoginScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _profileCard(
                    context: context,
                    icon: Icons.person_outline_rounded,
                    title: 'Je suis patient',
                    description: 'Consulter votre suivi, vos rendez-vous et votre évolution.',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PatientLoginScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 26),
                  const Center(
                    child: Text(
                      'Kiné Connect · Suivi simple et centralisé',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
