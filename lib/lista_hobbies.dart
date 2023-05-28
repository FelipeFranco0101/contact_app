import 'package:contact_app/models/Contact.dart';
import 'package:flutter/material.dart';

class ListaHobbiesPage extends StatefulWidget {
  const ListaHobbiesPage({Key? key}) : super(key: key);

  @override
  State<ListaHobbiesPage> createState() => _ListaHobbiesPageState();
}

class _ListaHobbiesPageState extends State<ListaHobbiesPage> {
  List<Hobby> _hobbies = [];

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
        for (String? hobby in contact.hobbies!) {
          if (hobby != null) {
            if (hobbiesCount.containsKey(hobby)) {
              hobbiesCount[hobby] = (hobbiesCount[hobby] ?? 0) + 1;
            } else {
              hobbiesCount[hobby] = 1;
            }
          }
        }
      }
    }

    _hobbies = hobbiesCount.entries
        .map((entry) => Hobby(name: entry.key, likes: entry.value))
        .toList();

    // Mover el hobby "Otros" al final de la lista
    int otrosIndex = _hobbies.indexWhere((hobby) => hobby.name == "Otros");
    if (otrosIndex != -1) {
      Hobby otrosHobby = _hobbies.removeAt(otrosIndex);
      _hobbies.add(otrosHobby);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Hobbies'),
      ),
      body: ListView.builder(
        itemCount: _hobbies.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(_hobbies[index].name),
              subtitle: Text(
                  'Número de Personas: ${_hobbies[index].likes.toString()}'),
            ),
          );
        },
      ),
    );
  }
}

class Hobby {
  final String name;
  final int likes;

  Hobby({required this.name, required this.likes});
}
