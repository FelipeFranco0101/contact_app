import 'package:contact_app/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    String contactDB = 'contact_database.db';

    debugPrint('DB LOCATION: $path');
    return openDatabase(join(path, contactDB), onCreate: _createDB, version: 1);
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(Contact.createQuery);
  }

  Future<List<Contact>> retrieveContacs() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> query = await db.query(Contact.tableName);
    return query.map((contactMap) => Contact.fromMap(contactMap)).toList();
  }

  Future<int?> getCountContacts() async {
    final Database db = await initializeDB();
    List<Map<String, dynamic>> amountContact = await db.rawQuery('SELECT COUNT(*) from ${Contact.tableName}');
    int? result = Sqflite.firstIntValue(amountContact);
    return result;
  }

  Future<int> updateContact(Contact contact) async {
    final Database db = await initializeDB();
    var result = await db.update(Contact.tableName, contact.toMap(), where: 'id = ?', whereArgs: [contact.id]);
    return result;
  }
}