import 'package:contact_app/delegates/search_contact_delegate.dart';
import 'package:contact_app/form_contact_page.dart';
import 'package:contact_app/main.dart';
import 'package:contact_app/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';
import 'package:badges/badges.dart' as badges;

class ContactHomePages extends StatefulWidget {
  final Database? database;
  const ContactHomePages({super.key, this.database});

  @override
  ContactHomeState createState() => ContactHomeState();
}

class ContactHomeState extends State<ContactHomePages> {
  List<Contact> listContact = List.empty(growable: true);
  late double promedioEdad = 0.0;
  late int amountPeopel = 0;

  @override
  void initState() {
    super.initState();
    getAmounPeople();
    getAverage();
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contactos    media: $promedioEdad'),
        backgroundColor: Colors.teal,
        actions: [
          Center(
            child: IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchContactDelegate(listContact, database)
                ).then((value) => reloadContacts());
              },
              icon: const Icon(Icons.search),
            ),
          ),
          Center(
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -12, end: 18),
              badgeContent: Text('$amountPeopel', style: const TextStyle(color: Colors.white),),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.orange,
                padding: EdgeInsets.all(5)
              ),
              child: const Icon(Icons.people),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: databaseHelper.retrieveContacs(), 
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          //getAmounPeople();
          List<Contact> lstContact = snapshot.data!;
          listContact = snapshot.data!;
          //getAmounPeopleTest(lstContact.length);
          return ListView.builder(
            itemCount: lstContact.length,
            itemBuilder: (BuildContext context, int index) {
              //amountPeopel = lstContact.length;
              //getAmounPeople();
              Contact contact = lstContact[index];
              final id = contact.id;
              return Card(
                color: Colors.white,
                elevation: .5,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                    child: Text(contact.nombres[0]+contact.apellidos[0]),
                  ),
                  title: Text("${contact.nombres} ${contact.apellidos}"),
                  subtitle: Text("Edad: ${contact.edad} \nCel: ${contact.telefono} \nEmail: ${contact.email} "),
                  trailing: IconButton(
                          onPressed: () => deleteById(id),
                          icon: const Icon(Icons.delete),
                        ),
                  onTap: () {
                    debugPrint("Accion para editar el contacto");
                    navigateToDetail(contact, 'Editar Contacto');
                  },
                ),
              );
            });
        }
      ),  
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormContact(database: database,))).then((value) => reloadContacts())
        },
        label: const Text('Contact'),
        icon: const Icon(Icons.person_add),
      )
    );
  }

  void navigateToDetail(Contact contact, String title) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormContact(database: database, appBarTitle: title, contactEdit: contact),)).then((value) => {
      reloadContacts(),
      setState(() {})
    });
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  double _calcularPromedioEdad(List<Contact> contacts) {
    if (contacts.isEmpty) return 0.0;
    double sum = 0;
    for (var contact in contacts) {
      sum += int.parse((contact.edad ?? "").isNotEmpty ? contact.edad.toString() : "0");
    }
    return sum / contacts.length;
  }

  getAmounPeople() async {
    final amount = await databaseHelper.getCountContacts();
    amountPeopel = amount!;
    setState(() {});
  }

  getAverage() async {
    final lstContact = await databaseHelper.retrieveContacs();
    promedioEdad = roundDouble(_calcularPromedioEdad(lstContact), 2);
    setState(() {});
  }

  Future<void> deleteById(int id) async {
    databaseHelper.deleteContact(id);
    reloadContacts();
  }

  reloadContacts() async {
    getAmounPeople();
    getAverage();
    setState(() {});
  }
}
