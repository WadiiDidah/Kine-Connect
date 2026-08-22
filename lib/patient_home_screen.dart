import 'package:flutter/material.dart';
import 'patient_detail_screen.dart';
import 'appointment_calendar_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  Widget _menuCard({
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
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7EAF2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 20,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF1FF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: const Color(0xFF4F61D7)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF718096), fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon suivi'),
        backgroundColor: const Color(0xFF3F51B5),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
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
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bienvenue', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 6),
                        Text(
                          'Suivez votre parcours de soin',
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Retrouvez vos rendez-vous et les informations liées à votre suivi kiné.',
                          style: TextStyle(color: Colors.white70, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text('Mon espace', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  _menuCard(
                    context: context,
                    icon: Icons.calendar_month_outlined,
                    title: 'Mes rendez-vous',
                    subtitle: 'Consulter les prochaines séances et le calendrier.',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AppointmentCalendarScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  _menuCard(
                    context: context,
                    icon: Icons.monitor_heart_outlined,
                    title: 'Mon évolution',
                    subtitle: 'Accéder aux informations et au suivi de progression.',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => PatientDetailScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAFBF4),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, color: Color(0xFF159A73)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Pensez à consulter régulièrement votre suivi et vos prochains rendez-vous.',
                            style: TextStyle(color: Color(0xFF246B58), fontSize: 12, height: 1.5),
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
