import 'package:contact_app/models/Contact.dart';
import 'package:flutter/material.dart';

class ListaHobbiesPage extends StatefulWidget {
  const ListaHobbiesPage({Key? key}) : super(key: key);

  @override
  State<ListaHobbiesPage> createState() => _ListaHobbiesPageState();
}

class _ListaHobbiesPageState extends State<ListaHobbiesPage> {
  List<Hobbie> _hobbies = [];

  @override
  void initState() {
    super.initState();
    _fetchHobbies();
  }

  void _fetchHobbies() async {
    List<Contact> contacts = await Contact.obtenerContactosDeBaseDeDatos();

    Map<String, int> hobbiesCount = {};

    for (Contact contact in contacts) {
      if (contact.hobbies != null) {
        for (String? hobbie in contact.hobbies!) {
          if (hobbie != null) {
            if (hobbiesCount.containsKey(hobbie)) {
              hobbiesCount[hobbie] = (hobbiesCount[hobbie] ?? 0) + 1;
            } else {
              hobbiesCount[hobbie] = 1;
            }
          }
        }
      }
    }

    _hobbies = hobbiesCount.entries
        .map((entry) => Hobbie(name: entry.key, likes: entry.value))
        .toList();

    // Mover el hobbie "Otros" al final de la lista
    int otrosIndex = _hobbies.indexWhere((hobbie) => hobbie.name == "Otros");
    if (otrosIndex != -1) {
      Hobbie otrosHobbie = _hobbies.removeAt(otrosIndex);
      _hobbies.add(otrosHobbie);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _hobbies.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(_hobbies[index].name),
            subtitle: Text(
              'Número de Personas: ${_hobbies[index].likes.toString()}',
            ),
          ),
        );
      },
    );
  }
}

class Hobbie {
  final String name;
  final int likes;

  Hobbie({required this.name, required this.likes});
}
