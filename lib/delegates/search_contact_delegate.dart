import 'package:contact_app/database/database_helper.dart';
import 'package:contact_app/form_contact_page.dart';
import 'package:contact_app/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class SearchContactDelegate extends SearchDelegate {
  final List<Contact> _listContact;
  List<Contact> _filter = List.empty(growable: true);
  final Database? database;
  late DatabaseHelper databaseHelper = DatabaseHelper();

  SearchContactDelegate(this._listContact, this.database);

  @override
  String get searchFieldLabel => 'Buscar contacto';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () {
        query = '';
      }, 
      icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
      //Navigator.of(context).pop();
      close(context, null); // TODO: Probar
    }, 
    icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return contactItemFilter();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _filter = _listContact.where((Contact contact) => contact.nombres.toLowerCase().trim().contains(query.toLowerCase().trim())).toList();
    return contactItemFilter();
  }

  Widget contactItemFilter() {
    return  Visibility(
      visible: _filter.isNotEmpty,
      replacement: const Center(
        child:  Text('No hay elementos'),
              
      ),
      child: ListView.builder(
          itemCount: _filter.length,
          itemBuilder: (BuildContext context, int index) {
            Contact contact = _filter[index];
            final id = contact.id;
            return Card(
              color: Colors.white,
              elevation: .5,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(contact.nombres[0] + contact.apellidos[0]),
                ),
                title: Text("${contact.nombres} ${contact.apellidos}"),
                subtitle: Text(
                    "Edad: ${contact.edad} \nCel: ${contact.telefono} \nEmail: ${contact.email} "),
                trailing: IconButton(
                  onPressed: () {
                    _filter.removeWhere((element) => element.id == id);
                    _listContact.removeWhere((element) => element.id == id);
                    query = '';
                    deleteById(id);
                    showResults(context);
                  },
                  icon: const Icon(Icons.delete),
                ),
                onTap: () {
                  debugPrint("Accion para editar el contacto");
                  navigateToDetail(contact, 'Editar Contacto', context);
                  showResults(context);
                },
              ),
            );
          }),
    );
  }

  void navigateToDetail(Contact contact, String title, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormContact(database: database, appBarTitle: title, contactEdit: contact),)).then((value) => {
      if (value != null) {
        debugPrint(value.toString()),
        _filter.removeWhere((element) => element.id == value.id),
        _filter.add(value)
      }
    });
  }

  Future<void> deleteById(int id) async {
    await databaseHelper.deleteContact(id);
  }
}