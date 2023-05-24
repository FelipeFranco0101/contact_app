import 'package:contact_app/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:contact_app/database/database_helper.dart';

class FormContact extends StatefulWidget {
  static const String route = '/createOrUpdate';
  final String? appBarTitle;
  final Contact? contactEdit;

  const FormContact({super.key, this.appBarTitle, this.contactEdit});

  @override
  FormContactState createState() => FormContactState();
}

class FormContactState extends State<FormContact> {
  final _formKey = GlobalKey<FormState>();
  var nombresController = TextEditingController();
  var apellidosController = TextEditingController();
  var telefonoController = TextEditingController();
  var edadController = TextEditingController();
  var emailController = TextEditingController();

  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    //databaseHelper = DatabaseHelper();
    fillFormContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.appBarTitle ?? 'Crear contacto'),
            backgroundColor: Colors.blueAccent,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                  setState(() {});
                })),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pop(context, 'Back');
            setState(() {});
            return Future(
              () => false,
            );
          },
          child: Container(
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
                            prefixIcon: const Icon(Icons.person_2_outlined),
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
                            prefixIcon: const Icon(Icons.phone_android_outlined),
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
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: edadController,
                        decoration: InputDecoration(
                            labelText: 'Edad',
                            prefixIcon: const Icon(Icons.access_time_filled_outlined),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: edadController.clear,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, ingresa la edad';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Por favor, ingresa una edad válida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: emailController.clear,
                            )),
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b') // validación de formato de email
                                  .hasMatch(value)) {
                            return 'Por favor, ingresa un email válido';
                          }
                          return null;
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
        ));
  }

  OutlinedButton submitForm(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            widget.contactEdit != null ? updateContact() : _saveRecord();
          }
        },
        child: Text(widget.contactEdit != null ? 'Update' : 'Submit form', style: const TextStyle(fontWeight: FontWeight.bold)));
  }

  void _saveRecord() async {
    DateTime dateUpdateAt = DateTime.now();
    var nombres = nombresController.text;
    var apellidos = apellidosController.text;
    var telefono = telefonoController.text;
    var edad = edadController.text;
    var email = emailController.text;
    var newContact = Contact(id: -1, nombres: nombres, apellidos: apellidos, telefono: telefono, edad: edad, email: email, updateAt: dateUpdateAt);
    await DatabaseHelper.instance.insertContact(newContact);

    nombresController.text = "";
    apellidosController.text = "";
    telefonoController.text = "";
    edadController.text = "";
    emailController.text = "";

    _showToast("Contacto creado con exito");
  }

  int formatAge(String age) {
    return age.isNotEmpty ? int.parse(age) : 0;
  }

  String formatPhone(String phone) {
    final numberFormat = intl.NumberFormat('(###) ###-####', 'en_CO');
    return phone.isNotEmpty ? numberFormat.format(phone) : phone;
  }

  void _showToast(String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void updateContact() async {
    var updateContact = Contact(
        id: widget.contactEdit!.id,
        nombres: nombresController.text,
        apellidos: apellidosController.text,
        telefono: telefonoController.text,
        edad: edadController.text,
        email: emailController.text,
        updateAt: DateTime.now());

    await DatabaseHelper.instance.updateContact(updateContact).then((value) => _showToast("Contacto actualizado con exito"));
    //await databaseHelper.updateContact(updateContact);
    //_showToast("Contacto actualizado con exito");
  }

  void fillFormContact() {
    if (widget.contactEdit != null) {
      nombresController.text = widget.contactEdit!.nombres;
      apellidosController.text = widget.contactEdit!.apellidos;
      telefonoController.text = widget.contactEdit!.telefono;
      edadController.text = widget.contactEdit!.edad ?? "";
      emailController.text = widget.contactEdit!.email ?? "";
    }
  }
}
