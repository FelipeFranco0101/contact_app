import 'dart:math';
import 'package:contact_app/database/database_helper.dart';
import 'package:contact_app/form_contact_page.dart';
import 'package:contact_app/models/Contact.dart';
import 'package:contact_app/lista_hobbies.dart';
import 'package:contact_app/listado.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContactHomePages extends StatefulWidget {
  final Database? database;
  final String usuario;
  const ContactHomePages({Key? key, this.database, required this.usuario})
      : super(key: key);

  @override
  State<ContactHomePages> createState() => _ContactHomeState();
}

class _ContactHomeState extends State<ContactHomePages>
    with SingleTickerProviderStateMixin {
  bool isFilter = false;
  int amountContact = 0;
  late double promedioEdad = 0.0;
  late TabController _tabController;
  final int _numTabs = 3;
  List<Contact> listUpdatedContact = List.empty(growable: true);
  List<Contact> listContact = List.empty(growable: true);

  String getSaludo() {
    var horaActual = DateTime.now().hour;

    if (horaActual >= 5 && horaActual < 12) {
      return 'Buenos días,';
    } else if (horaActual >= 12 && horaActual < 18) {
      return 'Buenas tardes,';
    } else {
      return 'Buenas noches,';
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _numTabs, vsync: this);
    countContactCreated();
    getAverage();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void countContactCreated() async {
    await DatabaseHelper.instance
        .getCountContacts()
        .then((value) => setState(() {
              amountContact = value ?? 0;
            }));
  }

  void getAverage() async {
    await DatabaseHelper.instance
        .retrieveContacs()
        .then((value) => setState(() {
              promedioEdad = roundDouble(_calcularPromedioEdad(value), 2);
              debugPrint(promedioEdad.toString());
            }));
  }

  double _calcularPromedioEdad(List<Contact> contacts) {
    if (contacts.isEmpty) return 0.0;
    double sum = 0;
    for (var contact in contacts) {
      sum += int.parse(
          (contact.edad ?? "").isNotEmpty ? contact.edad.toString() : "0");
    }
    return sum / contacts.length;
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
            alignment: Alignment.bottomCenter,
            height: 150,
            decoration: BoxDecoration(color: Colors.blue.shade800),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'App Personas',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      getSaludo(),
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Text(
                      capitalizeFirstLetter(widget.usuario),
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Promedio edad',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$promedioEdad',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(.1),
                      ),
                      child: Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.people,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$amountContact', // Número de notificaciones
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Listado',
              ),
              Tab(text: 'Registro'),
              Tab(text: 'Hobbies'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            labelStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ListadoPage(), // Contenido del tab 'Listado'
                FormContact(), // Contenido del tab 'Registro'
                ListaHobbiesPage(), // Contenido del tab 'Hobbies'
              ],
            ),
          ),
        ],
      ),
    );
  }
}
