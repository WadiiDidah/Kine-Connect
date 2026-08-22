import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'data/session_database.dart';

class ProgressChartScreen extends StatefulWidget {
  const ProgressChartScreen({super.key});

  @override
  State<ProgressChartScreen> createState() => _ProgressChartScreenState();
}

class _ProgressChartScreenState extends State<ProgressChartScreen> {
  late Future<List<Map<String, dynamic>>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = SessionDatabase.instance.getSessions();
  }

  Future<void> _refresh() async {
    setState(() {
      _sessionsFuture = SessionDatabase.instance.getSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Évolution des séances'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Impossible de charger les données de suivi.',
              ),
            );
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 180),
                  Icon(
                    Icons.bar_chart_rounded,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Aucune séance enregistrée pour le moment.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          final bars = <BarChartGroupData>[];

          for (int i = 0; i < sessions.length; i++) {
            final rawNote = sessions[i]['note'];

            double note = 0;

            if (rawNote is int) {
              note = rawNote.toDouble();
            } else if (rawNote is double) {
              note = rawNote;
            } else {
              note = double.tryParse(rawNote.toString()) ?? 0;
            }

            bars.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: note,
                    width: 18,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            );
          }

          double maxValue = 10;

          for (final session in sessions) {
            final value =
                double.tryParse(session['note'].toString()) ?? 0;

            if (value > maxValue) {
              maxValue = value + 2;
            }
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Progression',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${sessions.length} séance(s) enregistrée(s)',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    28,
                    16,
                    16,
                  ),
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
                  child: SizedBox(
                    height: 320,
                    child: BarChart(
                      BarChartData(
                        maxY: maxValue,
                        alignment:
                            BarChartAlignment.spaceAround,
                        gridData: const FlGridData(
                          show: true,
                          drawVerticalLine: false,
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: bars,
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: false),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 35,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 42,
                              getTitlesWidget: (
                                value,
                                meta,
                              ) {
                                final index = value.toInt();

                                if (index < 0 ||
                                    index >= sessions.length) {
                                  return const SizedBox.shrink();
                                }

                                final date =
                                    sessions[index]['date']
                                        ?.toString() ??
                                    '';

                                final label =
                                    date.length >= 10
                                        ? date.substring(5, 10)
                                        : date;

                                return Padding(
                                  padding:
                                      const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}