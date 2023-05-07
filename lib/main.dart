import 'package:contact_app/contact_home_page.dart';
import 'package:contact_app/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
  createDatabase();
}

Future<Database>? database;

void createDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = openDatabase(join(await getDatabasesPath(), "contact_database.db"), version: 1,
    onCreate: (db, version) => {
      db.execute(Contact.createQuery)
    }
  );
  print('DB LOCATION ${await getDatabasesPath()}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactHomePages(database: database,),
    );
  }
}