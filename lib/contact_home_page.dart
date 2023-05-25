import 'dart:math';
import 'package:contact_app/database/database_helper.dart';
import 'package:contact_app/form_contact_page.dart';
import 'package:contact_app/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ContactHomePages extends StatefulWidget {
  final Database? database;
  const ContactHomePages({super.key, this.database});

  @override
  State<ContactHomePages> createState() => _ContactHomeState();
}

class _ContactHomeState extends State<ContactHomePages> {
  double _availableScreenWidth = 0;
  int _selectedIndex = 0;
  int amountContact = 0;
  late double promedioEdad = 0.0;
  List<Contact> listUpdatedContact = List.empty(growable: true);
  List<Contact> listContact = List.empty(growable: true);

  void prueba() async {
    var a = await DatabaseHelper.instance.getCountContacts();
    var b = await DatabaseHelper.instance.retrieveContacs();
    var c = await DatabaseHelper.instance.getRecentlyUpdate();
    debugPrint(a.toString());
  }

  String getSaludo() {
    var horaActual = DateTime.now().hour;

    if (horaActual >= 5 && horaActual < 12) {
      return 'Buenos días';
    } else if (horaActual >= 12 && horaActual < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
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
    _availableScreenWidth = MediaQuery.of(context).size.width - 50;
    //prueba();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          alignment: Alignment.bottomCenter,
          height: 170,
          decoration: BoxDecoration(color: Colors.blue.shade800),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Contact App',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text(getSaludo(),
                    style: const TextStyle(fontSize: 17, color: Colors.white)),
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
                            fontSize: 10,
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
        containerRecentlyUpdateContact(),
        Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Contacts',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      debugPrint('Siii');
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'New Contacts',
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
        buildlistContactsList(),
      ]),
      floatingActionButton: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [
          BoxShadow(color: Colors.white, spreadRadius: 7, blurRadius: 1)
        ]),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) =>
                        const FormContact(appBarTitle: 'Nuevo contacto')))
                .then((value) =>
                    {countContactCreated(), getAverage(), setState(() {})});
          },
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

  /*Widget buildlistContactsList() {
    return Expanded(
        child: ListView(
      padding: const EdgeInsets.all(25),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Contacts',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                debugPrint('Siii');
              },
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  'New Contacts',
                  style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        buildListContacts('Felipe'),
        buildListContacts('Manu'),
        buildListContacts('Rachel'),
        buildListContacts('Salo'),
      ],
    ));
  }*/

  Widget containerRecentlyUpdateContact() {
    if (amountContact > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ultimos actualizados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15,
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
          listContact = snapshot.data!;
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        //color: Colors.grey.shade200,
        elevation: .5,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Color((Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
            child: Text(contact.nombres[0] + contact.apellidos[0]),
          ),
          title: Text("${contact.nombres} ${contact.apellidos}"),
          subtitle: Text(
              "Edad: ${contact.edad} \nCel: ${contact.telefono} \nEmail: ${contact.email} "),
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

  /*FutureBuilder<List<Contact>> buildRecentlyUpdateContactsList() {
    return FutureBuilder(
        future: DatabaseHelper.instance.getRecentlyUpdate(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center();
          }
          listContact = snapshot.data!.getRange(0, 1).toList();
          return Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(25),
              itemCount: listContact.length,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = listContact[index];
                mostar(contact);
                return buildRecentlyUpdateContacts(contact.nombres, 'asd/asd/asd');
              },
            ),
          );
        });
  }*/

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
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                //shrinkWrap: true,
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
          padding: const EdgeInsets.all(38),
          height: 90,
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

  void navigateToDetail(Contact contact, String title) {
    //Navigator.pushNamed(context, FormContact.route, arguments: contact).then((value) => setState(() {}));
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) =>
              FormContact(appBarTitle: title, contactEdit: contact),
        ))
        .then((value) => {setState(() {})});
  }

  void deleteById(int id) async {
    await DatabaseHelper.instance
        .deleteContact(id)
        .then((value) => {countContactCreated(), getAverage()});
    //reloadContacts();
  }
}
