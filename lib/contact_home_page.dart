import 'dart:math';
import 'package:contact_app/database/database_helper.dart';
import 'package:contact_app/form_contact_page.dart';
import 'package:contact_app/models/Contact.dart';
import 'package:contact_app/lista_hobbies.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContactHomePages extends StatefulWidget {
  final Database? database;
  final String usuario;
  const ContactHomePages({super.key, this.database, required this.usuario});

  @override
  State<ContactHomePages> createState() => _ContactHomeState();
}

class _ContactHomeState extends State<ContactHomePages> {
  bool isFilter = false;
  double _availableScreenWidth = 0;
  int _selectedIndex = 0;
  int amountContact = 0;
  late double promedioEdad = 0.0;
  List<Contact> listUpdatedContact = List.empty(growable: true);
  List<Contact> listContact = List.empty(growable: true);

  void _irAListaHobbies() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ListaHobbiesPage(),
      ),
    );
  }

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

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    countContactCreated();
    getAverage();
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

  @override
  Widget build(BuildContext context) {
    _availableScreenWidth = MediaQuery.of(context).size.width - 80;
    //prueba();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          alignment: Alignment.bottomCenter,
          height: 150,
          decoration: BoxDecoration(color: Colors.blue.shade800),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('App Personas',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(getSaludo(),
                    style: const TextStyle(fontSize: 17, color: Colors.white)),
                Text(
                  capitalizeFirstLetter(widget.usuario),
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(.1)),
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
                        fontSize: 13,
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
                    color: Colors.black.withOpacity(.1)),
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
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ]),
        ),
        Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: _irAListaHobbies, // Agrega el enlace al botón
                child: const Text('Ir a Lista de Hobbies'),
              ),
            ),
          ],
        ),
        containerRecentlyUpdateContact(),
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Contactos',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () => navigateCreateContact(),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Nuevo Contacto',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => _filterContact(value),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                        vertical: 10.0, horizontal: 15),
                    hintText: 'Buscar',
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide())),
              ),
            ],
          ),
        ),
        buildlistContactsList(),
      ]),
      floatingActionButton: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(color: Colors.white, spreadRadius: 7, blurRadius: 1)
        ]),
        child: FloatingActionButton(
          onPressed: () => navigateCreateContact(),
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            debugPrint(index.toString());
            setState(() {
              _selectedIndex = index;
            });
            debugPrint(_selectedIndex.toString());
          },
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Time',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Folder',
            ),
          ]),
    );
  }

  Widget containerRecentlyUpdateContact() {
    if (amountContact > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Últimos creados/actualizados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                buildRecentlyUpdateContactsList(),
              ],
            ),
            const Divider(
              height: 5,
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget buildlistContactsList() {
    return FutureBuilder(
        future: DatabaseHelper.instance.retrieveContacs(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!isFilter) {
            listContact = snapshot.data!;
          }

          //listContact = snapshot.data!;
          return Expanded(
            child: ListView.builder(
              itemCount: listContact.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = listContact[index];
                return buildListContactsCard(contact);
              },
            ),
          );
        });
  }

  Widget buildListContactsCard(Contact contact) {
    String hobbiesText = contact.hobbies?.join(', ') ?? 'N/A';

    if (hobbiesText.contains('otros')) {
      List<String> hobbiesList = hobbiesText.split(', ');
      hobbiesList.remove('otros');
      hobbiesList.add('otros');
      hobbiesText = hobbiesList.join(', ');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        color: Colors.grey.shade200,
        elevation: .5,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
            child: Text(contact.nombres[0] + contact.apellidos[0]),
          ),
          title: Text("${contact.nombres} ${contact.apellidos}"),
          subtitle: Text(
            "Edad: ${contact.edad} \nCel: ${contact.telefono} \nEmail: ${contact.email} \nHobbies: $hobbiesText",
          ),
          trailing: Wrap(
            spacing: -8,
            children: <Widget>[
              IconButton(
                onPressed: () => navigateToDetail(contact, 'Editar Contacto'),
                icon: const Icon(Icons.edit),
              ), // icon-1
              IconButton(
                onPressed: () => deleteById(contact.id),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildListContacts(String nombres) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.folder,
                color: Colors.blue[200],
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                nombres,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget buildRecentlyUpdateContactsList() {
    return FutureBuilder(
        future: DatabaseHelper.instance.getRecentlyUpdate(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          listUpdatedContact = snapshot.data!;
          return Expanded(
            child: SizedBox(
              height: 135,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                //padding: const EdgeInsets.all(25),
                itemCount: listUpdatedContact.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = listUpdatedContact[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildRecentlyUpdateContacts(
                          contact.nombres, contact.updateAt),
                      SizedBox(
                        width: _availableScreenWidth * .03,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        });
  }

  Column buildRecentlyUpdateContacts(String nombres, DateTime? fecha) {
    return Column(
      children: [
        Container(
          width: _availableScreenWidth * .31,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(10),
          height: 60,
          child: const Icon(Icons.man),
        ),
        const SizedBox(
          height: 15,
        ),
        RichText(
          text: TextSpan(
              text: nombres,
              style: const TextStyle(color: Colors.black, fontSize: 12),
              children: [
                TextSpan(
                  text: fecha != null
                      ? ' | ${fecha.toIso8601String().split('T').first}'
                      : '',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 10,
                  ),
                ),
              ]),
        ),
      ],
    );
  }

  void navigateCreateContact() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) =>
                const FormContact(appBarTitle: 'Nuevo contacto')))
        .then((value) => {
              countContactCreated(),
              isFilter = false,
              getAverage(),
              setState(() {})
            });
  }

  void navigateToDetail(Contact contact, String title) {
    //Navigator.pushNamed(context, FormContact.route, arguments: contact).then((value) => setState(() {}));
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) =>
              FormContact(appBarTitle: title, contactEdit: contact),
        ))
        .then((value) => {getAverage(), isFilter = false, setState(() {})});
  }

  void deleteById(int id) async {
    await DatabaseHelper.instance
        .deleteContact(id)
        .then((value) => {countContactCreated(), getAverage()});
    //reloadContacts();
  }

  List<Contact> _filterContact(String enterKeyboard) {
    List<Contact> result = [];
    if (enterKeyboard.isEmpty) {
      isFilter = false;
      result = listContact;
    } else {
      isFilter = true;
      result = listContact
          .where((element) => element.nombres
              .toLowerCase()
              .trim()
              .contains(enterKeyboard.toLowerCase().trim()))
          .toList();
    }

    setState(() {
      listContact = result;
    });
    return listContact;
  }
}
