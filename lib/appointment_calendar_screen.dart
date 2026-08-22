import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'app_bottom_navigation.dart';
import 'data/appointment_database.dart';

class AppointmentCalendarScreen extends StatefulWidget {
  const AppointmentCalendarScreen({super.key});

  @override
  State<AppointmentCalendarScreen> createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final Map<DateTime, List<Appointment>> _appointments = {};

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return _appointments[_normalizeDate(day)] ?? [];
  }

  Future<void> _loadAppointments() async {
    final appointments = await AppointmentDatabase.instance.getAppointments();

    final grouped = <DateTime, List<Appointment>>{};

    for (final appointment in appointments) {
      final day = _normalizeDate(appointment.startDate);

      grouped.putIfAbsent(day, () => []);

      grouped[day]!.add(appointment);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _appointments
        ..clear()
        ..addAll(grouped);
    });
  }

  Future<void> _showAddAppointmentDialog() async {
    final lastNameController = TextEditingController();
    final firstNameController = TextEditingController();

    DateTime selectedDate = _selectedDay;
    TimeOfDay selectedTime = TimeOfDay.now();

    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Nouveau rendez-vous'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 420,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom du patient',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'Prénom du patient',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 22),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_month),
                        title: const Text('Date'),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final result = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 5),
                          );

                          if (result != null) {
                            setDialogState(() {
                              selectedDate = result;
                            });
                          }
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.schedule),
                        title: const Text('Heure'),
                        subtitle: Text(selectedTime.format(context)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final result = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );

                          if (result != null) {
                            setDialogState(() {
                              selectedTime = result;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Annuler'),
                ),
                FilledButton(
                  onPressed: () async {
                    final lastName = lastNameController.text.trim();

                    final firstName = firstNameController.text.trim();

                    if (lastName.isEmpty || firstName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Le nom et le prénom sont obligatoires.',
                          ),
                        ),
                      );

                      return;
                    }

                    final appointmentDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    final appointment = Appointment(
                      nom: lastName,
                      prenom: firstName,
                      startDate: appointmentDateTime,
                      startTime: appointmentDateTime,
                    );

                    await AppointmentDatabase.instance.insertAppointment(
                      appointment,
                    );

                    if (!dialogContext.mounted) {
                      return;
                    }

                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );

    lastNameController.dispose();
    firstNameController.dispose();

    if (created == true) {
      await _loadAppointments();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Rendez-vous ajouté.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedAppointments = _getAppointmentsForDay(_selectedDay);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(title: const Text('Rendez-vous'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAppointmentDialog,
        icon: const Icon(Icons.add),
        label: const Text('Rendez-vous'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: TableCalendar<Appointment>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                eventLoader: _getAppointmentsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  markerDecoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  Text(
                    DateFormat('EEEE d MMMM', 'fr_FR').format(_selectedDay),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${selectedAppointments.length} rendez-vous',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: selectedAppointments.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_available_outlined,
                            size: 54,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Aucun rendez-vous ce jour.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: selectedAppointments.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final appointment = selectedAppointments[index];

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0EDFF),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${appointment.prenom} ${appointment.nom}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('HH:mm')
                                          .format(appointment.startTime),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(),
    );
  }
}
