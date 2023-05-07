import 'package:contact_app/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class FormContact extends StatefulWidget {
  final Future<Database>? database;

  const FormContact({super.key, this.database});

  @override
  FormContactState createState() => FormContactState();
}

class FormContactState extends State<FormContact> {
  final _formKey = GlobalKey<FormState>();
  var nombresController = TextEditingController();
  var apellidosController = TextEditingController();
  var telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Crear contacto'),
          backgroundColor: Colors.blueAccent),
          body: Container(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nombresController,
                        decoration: InputDecoration(
                          labelText: 'Nombres',
                          prefixIcon: const Icon(Icons.person),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: nombresController.clear,
                          )),
                          validator: (value) {
                            return (value!.isEmpty) ? 'Por favor ingrese un nombre' : null;
                          },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: apellidosController,
                        decoration: InputDecoration(
                          labelText: 'Apellidos',
                          prefixIcon: const Icon(Icons.person),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: apellidosController.clear,
                          )),
                          validator: (value) {
                            return (value!.isEmpty) ? 'Por favor ingrese el apellido' : null;
                          },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: telefonoController,
                        decoration: InputDecoration(
                          labelText: 'Telefono',
                          prefixIcon: const Icon(Icons.person),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: telefonoController.clear,
                          )),
                          validator: (value) {
                            return (value!.isEmpty) ? 'Por favor ingrese el numero de telefono' : null;
                          },
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
                submitForm(context),
              ],
            ),
          ),
    );    
  }

  OutlinedButton submitForm(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
      onPressed: () {
        (_formKey.currentState!.validate()) ? _saveRecord() : null;
      }, 
      child: const Text('Submit form', style: TextStyle(fontWeight: FontWeight.bold))
    );
  }
  
  void _saveRecord() async {
    var db = await widget.database;

    var nombres = nombresController.text;
    var apellidos = apellidosController.text;
    var telefono = telefonoController.text;

    await db?.insert(Contact.tableName,
      Contact(id: -1, nombres: nombres, apellidos: apellidos, telefono: telefono).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    nombresController.text = "";
    apellidosController.text = "";
    telefonoController.text = "";

    _showToast();
  }

  void _showToast() {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Processing Data'),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
