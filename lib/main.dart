import 'package:contact_app/database/database_helper.dart';
import 'package:contact_app/welcome_screen.dart';
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
  await DatabaseHelper.instance
      .initializeDB()
      .then((value) => database = value);
  databaseHelper.initializeDB().then((value) => database = value);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
