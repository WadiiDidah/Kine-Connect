import 'package:flutter/material.dart';
import 'patient_session_screen.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({Key? key}) : super(key: key);

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final List<Map<String, dynamic>> _patients = [
    {'id': 1, 'name': 'Lucie Martin', 'age': 29},
    {'id': 2, 'name': 'Karim Benali', 'age': 41},
    {'id': 3, 'name': 'Emma Robert', 'age': 34},
    {'id': 4, 'name': 'Thomas Bernard', 'age': 52},
    {'id': 5, 'name': 'Sofia Morel', 'age': 26},
  ];

  late List<Map<String, dynamic>> _filteredPatients;

  @override
  void initState() {
    super.initState();
    _filteredPatients = List.from(_patients);
  }

  void _filterPatients(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    setState(() {
      if (normalizedQuery.isEmpty) {
        _filteredPatients = List.from(_patients);
        return;
      }

      _filteredPatients = _patients.where((patient) {
        final name = patient['name'].toString().toLowerCase();
        return name.contains(normalizedQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes patients'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: _filterPatients,
              decoration: InputDecoration(
                hintText: 'Rechercher un patient',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredPatients.isEmpty
                  ? const Center(child: Text('Aucun patient trouvé.'))
                  : ListView.separated(
                      itemCount: _filteredPatients.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final patient = _filteredPatients[index];

                        return Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: const CircleAvatar(
                              backgroundImage: AssetImage('assets/icon.png'),
                            ),
                            title: Text(
                              patient['name'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text('${patient['age']} ans'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const PatientSessionScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
