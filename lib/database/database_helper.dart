import 'package:contact_app/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  static DatabaseHelper get instance => _instance;

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    String contactDB = 'contact_database.db';

    debugPrint('DB LOCATION: $path');
    return openDatabase(join(path, contactDB), onCreate: _createDB, version: 1);
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(Contact.createQuery);
  }

  Future<int> insertContact(Contact contact) async {
    final Database db = await DatabaseHelper.instance.initializeDB();
    return await db.insert(Contact.tableName, contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Contact>> retrieveContacs() async {
    final Database db = await DatabaseHelper.instance.initializeDB();
    final List<Map<String, dynamic>> query = await db.query(Contact.tableName);
    return query.map((contactMap) => Contact.fromMap(contactMap)).toList();
  }

  Future<int?> getCountContacts() async {
    final Database db = await initializeDB();
    List<Map<String, dynamic>> amountContact = await db.rawQuery('SELECT COUNT(*) from ${Contact.tableName}');
    int? result = Sqflite.firstIntValue(amountContact);
    return result;
  }

  Future<List<Contact>> getRecentlyUpdate() async {
    final Database db = await DatabaseHelper.instance.initializeDB();
    final List<Map<String, dynamic>> query = await db.rawQuery('SELECT * from ${Contact.tableName} ORDER BY datetime(updateAt) DESC LIMIT 3');

    return query.map((contactMap) => Contact.fromMap(contactMap)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final Database db = await initializeDB();
    var result = await db.update(Contact.tableName, contact.toMap(), where: 'id = ?', whereArgs: [contact.id]);
    return result;
  }

  Future<int> deleteContact(int id) async {
    final Database db = await initializeDB();
    var result = await db.delete(Contact.tableName, where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
