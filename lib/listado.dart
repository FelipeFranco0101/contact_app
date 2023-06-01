import 'dart:math';
import 'package:contact_app/database/database_helper.dart';
import 'package:contact_app/form_contact_page.dart';
import 'package:contact_app/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ListadoPage extends StatefulWidget {
  final Database? database;

  const ListadoPage({Key? key, this.database}) : super(key: key);

  @override
  State<ListadoPage> createState() => _ListadoPageState();
}

class _ListadoPageState extends State<ListadoPage> {
  List<Contact> listContact = [];
  bool isFilter = false;

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  void getContacts() async {
    List<Contact> contacts = await DatabaseHelper.instance.retrieveContacs();
    setState(() {
      listContact = contacts;
    });
  }

  void deleteContact(int id) async {
    await DatabaseHelper.instance.deleteContact(id);
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextField(
            onChanged: (value) => _filterContact(value),
            decoration: InputDecoration(
              hintText: 'Buscar',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: listContact.length,
            itemBuilder: (context, index) {
              Contact contact = listContact[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Color((Random().nextDouble() * 0xFFFFFF).toInt())
                          .withOpacity(1.0),
                  child: Text(contact.nombres[0] + contact.apellidos[0]),
                ),
                title: Text("${contact.nombres} ${contact.apellidos}"),
                subtitle: Text(
                  "Edad: ${contact.edad} \nCel: ${contact.telefono} \nEmail: ${contact.email ?? ''}",
                ),
                trailing: Wrap(
                  spacing: -8,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormContact(
                            appBarTitle: 'Editar Contacto',
                            contactEdit: contact,
                          ),
                        ),
                      ).then((value) => getContacts()),
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => deleteContact(contact.id),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _filterContact(String enterKeyboard) {
    if (enterKeyboard.isEmpty) {
      setState(() {
        isFilter = false;
        getContacts(); // Restablecer la lista completa de contactos
      });
    } else {
      List<Contact> filteredList = listContact
          .where((contact) =>
              contact.nombres
                  .toLowerCase()
                  .contains(enterKeyboard.toLowerCase()) ||
              contact.apellidos
                  .toLowerCase()
                  .contains(enterKeyboard.toLowerCase()) ||
              contact.telefono
                  .toLowerCase()
                  .contains(enterKeyboard.toLowerCase()) ||
              (contact.email != null &&
                  contact.email!
                      .toLowerCase()
                      .contains(enterKeyboard.toLowerCase())))
          .toList();
      setState(() {
        listContact = filteredList;
        isFilter = true;
      });
    }
  }
}
