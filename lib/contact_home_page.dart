import 'package:contact_app/form_contact_page.dart';
import 'package:contact_app/main.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContactHomePages extends StatefulWidget {
  final Future<Database>? database;
  const ContactHomePages({super.key, this.database});

  @override
  ContactHomeState createState() => ContactHomeState();
}

class ContactHomeState extends State<ContactHomePages> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Se listaran los contactos:',
            ),
            Text(
              'Contacto',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),  
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormContact(database: database,)))
        },
        label: const Text('Contact'),
        icon: const Icon(Icons.person_add),
      )
    );
  }
}