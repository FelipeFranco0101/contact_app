import 'package:contact_app/contact_home_page.dart';
import 'package:contact_app/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  createDatabase();
  runApp(const MyApp());
}

Database? database;
late DatabaseHelper databaseHelper;

void createDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  databaseHelper = DatabaseHelper.instance;
  // Inicializar la base de datos
  await DatabaseHelper.instance.initializeDB().then((value) => database = value);
  databaseHelper.initializeDB().then((value) => database = value);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactHomePages(
        database: database,
      ),
    );
  }
}
