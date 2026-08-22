// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kine/app_bottom_navigation.dart';
import 'package:kine/patient_session_screen.dart';
import 'progress_chart_screen.dart';
import 'data/session_database.dart';

class PatientDetailScreen extends StatefulWidget {
  const PatientDetailScreen({Key? key}) : super(key: key);

  @override
  _PatientDetailScreenState createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  bool showDial = false;

  void showAlerte(BuildContext context, String id) {
    String eventName = "";
    String patientFirstName = "";
    DateTime startDate = DateTime.now();
    DateTime startTime = DateTime.now();
    var rating;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ajout d'un nouveau rendez-vous"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.star),
                    SizedBox(width: 10),
                    Text('Note de la séance (entre 0 et 10):'),
                  ],
                ),
                SizedBox(height: 5),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Mettre à jour la variable de note avec la valeur entrée
                    setState(() {
                      rating = value;
                    });
                  },
                  validator: (value) {
                    if (value != "") {
                      return 'Veuillez entrer une note.';
                    }
                    rating = int.tryParse(value!);
                    if (rating == null || rating < 0 || rating > 10) {
                      return 'Veuillez entrer une note valide entre 0 et 10.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(width: 10),
                    Text('Jour de la séance:'),
                  ],
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: startDate,
                      firstDate: DateTime(DateTime.now().year - 5),
                      lastDate: DateTime(DateTime.now().year + 5),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        startDate = selectedDate;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(startDate),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {

                final db = SessionDatabase.instance;
                await db.deleteAllSessions();
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Récapitulatif'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "Rendez vous avec  '$eventName' '$patientFirstName'"),
                          Text(
                              "Date du rendez-vous : ${DateFormat('yyyy-MM-dd').format(startDate)}"),
                          Text("Note de la séance: ${rating}"),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            final databaseHelper = SessionDatabase.instance;
                            int test = int.tryParse(rating)!;
                            await databaseHelper.insertSession(
                              note: test,
                              date: DateFormat('yyyy-MM-dd').format(startDate),
                              patient: id,
                            );
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {
        showDial = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profil"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_rounded),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          SizedBox(height: 50),
          Column(

            children: const [
              CircleAvatar(
                  radius: 50, backgroundImage: AssetImage("assets/icon.png")),
              SizedBox(height: 10),
              Text(
                "Profil patient",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Suivi en cours")
            ],
          ),


          const SizedBox(height: 35),
          ...List.generate(
            customListTiles.length,
                (index) {
              final tile = customListTiles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black12,
                  child: ListTile(
                      leading: Icon(tile.icon),
                      title: Text(tile.title),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Handle the onTap action for each CustomListTile
                        // You can access the tile properties (icon, title, etc.) here
                        // Add your code here

                        if (tile.title == "Visualiser Votre évolution") {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProgressChartScreen()));

                        } else {
                        }
                      }),
                ),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(),
    );
  }
}





class CustomListTile {
  final IconData icon;
  final String title;

  CustomListTile({
    required this.icon,
    required this.title,
  });
}

List<CustomListTile> customListTiles = [
  CustomListTile(
    icon: Icons.insights,
    title: "Visualiser Votre évolution",
  ),
  CustomListTile(
    icon: Icons.location_on_outlined,
    title: "Visualiser Vos Notes",
  ),
];
