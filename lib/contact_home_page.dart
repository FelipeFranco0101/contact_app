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

  @override
  Widget build(BuildContext context) {
    _availableScreenWidth = MediaQuery.of(context).size.width - 50;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          alignment: Alignment.bottomCenter,
          height: 170,
          decoration: BoxDecoration(color: Colors.blue.shade800),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Felipe', 
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)
                ),
                Text(
                  'Felipe Sub', 
                  style: TextStyle(fontSize: 17, color: Colors.white)
                ),
              ],
            ),
            Row(children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(.1)),
                child: IconButton(
                  onPressed: () {}, 
                  icon: const Icon(Icons.search, size: 28, color: Colors.white,),
                ),
              ),
              const SizedBox(width: 10,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(.1)),
                child: IconButton(
                  onPressed: () {}, 
                  icon: const Icon(Icons.people, size: 28, color: Colors.white,),
                ),
              )
            ]),
          ]),
        ),
        const SizedBox(
          height: 25,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(25),
            children: [
              const Text('Ultimos actualizados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 15,),
              Row(
                children: [
                  buildRecentlyUpdateContacts('Felipe', '20/05/2023'),
                  SizedBox(width: _availableScreenWidth *.03,),
                  buildRecentlyUpdateContacts('Felipe', '20/05/2023'),
                  SizedBox(width: _availableScreenWidth *.03,),
                  buildRecentlyUpdateContacts('Felipe', '20/05/2023')
                ],
              ),
              const Divider(height: 60,),

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
              const SizedBox(height: 20,),

              buildListContacts('Felipe'),
              buildListContacts('Manu'),
              buildListContacts('Rachel'),
              buildListContacts('Salo'),
          ],)
        ) 
      ]),

      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
           BoxShadow(color: Colors.white, spreadRadius: 7, blurRadius: 1) 
          ]
        ),
        child: FloatingActionButton(
          onPressed: () {},
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
            icon: Icon(Icons.access_time),
            label: 'Time',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Folder',
          ),
        ]
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

  Column buildRecentlyUpdateContacts(String nombres, String fecha) {
    return Column(
      children: [
        Container(
          width: _availableScreenWidth *.31,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(38),
          height: 110,
          child: const Icon(Icons.man),
        ),
        const SizedBox(
          height: 15,
        ),
        RichText(
          text: TextSpan(
              text: nombres,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: fecha,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}