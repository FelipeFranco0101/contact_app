import 'package:contact_app/main.dart';
import 'package:flutter/material.dart';

class ContactHomePages extends StatefulWidget {
  const ContactHomePages({super.key});

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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScreenTwo()))
        },
        label: const Text('Contact'),
        icon: const Icon(Icons.person_add),
      )
    );
  }
}