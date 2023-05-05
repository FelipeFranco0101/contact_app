import 'package:flutter/material.dart';

class FormContact extends StatefulWidget {
  const FormContact({super.key});

  @override
  FormContactState createState() => FormContactState();
}

class FormContactState extends State<FormContact> {
  final _formKey = GlobalKey<FormState>();
  var nombresController = TextEditingController();
  var apellidosController = TextEditingController();

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
                            return (value!.isEmpty) ? 'Por favor ingrese un nombre' : null;
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
      onPressed: null, 
      child: const Text('Submit form', style: TextStyle(fontWeight: FontWeight.bold))
    );
  }
  
}