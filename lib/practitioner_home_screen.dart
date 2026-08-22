import 'package:flutter/material.dart';
import 'patient_list_screen.dart';
import 'appointment_calendar_screen.dart';

class PractitionerHomeScreen extends StatelessWidget {
  const PractitionerHomeScreen({Key? key}) : super(key: key);

  Widget _actionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7EAF2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF1FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF4F61D7)),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF718096), fontSize: 12, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace kinésithérapeute'),
        backgroundColor: const Color(0xFF3F51B5),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3346BD), Color(0xFF6574DD)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Bonjour',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Votre espace de suivi',
                          style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Accédez rapidement à vos patients et à votre planning de rendez-vous.',
                          style: TextStyle(color: Colors.white70, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Accès rapide',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 620;
                      final cards = [
                        _actionCard(
                          context: context,
                          icon: Icons.people_alt_outlined,
                          title: 'Mes patients',
                          subtitle: 'Consulter la liste des patients et accéder à leur suivi.',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => PatientListScreen()),
                            );
                          },
                        ),
                        _actionCard(
                          context: context,
                          icon: Icons.calendar_month_outlined,
                          title: 'Rendez-vous',
                          subtitle: 'Consulter le calendrier et gérer les prochaines séances.',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => AppointmentCalendarScreen()),
                            );
                          },
                        ),
                      ];

                      if (!isWide) {
                        return Column(
                          children: [
                            cards[0],
                            const SizedBox(height: 14),
                            cards[1],
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: cards[0]),
                          const SizedBox(width: 14),
                          Expanded(child: cards[1]),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE7EAF2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAFBF4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.health_and_safety_outlined, color: Color(0xFF159A73)),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Suivi centralisé', style: TextStyle(fontWeight: FontWeight.w800)),
                              SizedBox(height: 4),
                              Text(
                                'Les informations utiles restent accessibles depuis un seul espace.',
                                style: TextStyle(color: Color(0xFF718096), fontSize: 12, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
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
