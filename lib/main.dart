import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Personas',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Persona> personas = [];
  int contadorPersonas = 0;
  double promedioEdad = 0;

  void agregarPersona(Persona persona) {
    setState(() {
      personas.add(persona);
      contadorPersonas++;
      calcularPromedioEdad();
    });
  }

  void eliminarPersona(int index) {
    setState(() {
      personas.removeAt(index);
      contadorPersonas--;
      calcularPromedioEdad();
    });
  }

void modificarPersona(int index, Persona persona) {
    setState(() {
      personas[index] = persona;
      calcularPromedioEdad();
    });
  }

  void calcularPromedioEdad() {
    if (personas.isNotEmpty) {
      int sumaEdades = 0;
      for (var persona in personas) {
        sumaEdades += persona.edad;
      }
      promedioEdad = sumaEdades / personas.length;
    } else {
      promedioEdad = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Personas'),
      ),
      body: Column(
        children: [
          IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String nombre = ''; // Variable para almacenar el nombre
              int edad = 0; // Variable para almacenar la edad

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Modificar Persona'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(labelText: 'Nombre'),
                          onChanged: (value) {
                            setState(() {
                              nombre = value;
                            });
                          },
                          controller: TextEditingController(text: nombre),
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Edad'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              edad = int.tryParse(value) ?? 0;
                            });
                          },
                          controller: TextEditingController(text: edad.toString()),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('Guardar'),
                        onPressed: () {
                          modificarPersona(Persona(nombre: nombre, edad: edad));
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),

          Expanded(
            child: ListView.builder(
              itemCount: personas.length,
              itemBuilder: (BuildContext context, int index) {
                final persona = personas[index];
                return ListTile(
                  title: Text(persona.nombre),
                  subtitle: Text('Edad: ${persona.edad}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => eliminarPersona(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Personas registradas: $contadorPersonas'),
              Text('Promedio de edad: ${promedioEdad.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String nombre = ''; // Variable para almacenar el nombre
              int edad = 0; // Variable para almacenar la edad

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Text('Agregar Persona'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(labelText: 'Nombre'),
                          onChanged: (value) {
                            setState(() {
                              nombre = value;
                            });
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: 'Edad'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              edad = int.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('Agregar'),
                        onPressed: () {
                          agregarPersona(Persona(nombre: nombre, edad: edad));
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class Persona {
  final String nombre;
  final int edad;

  Persona({required this.nombre, required this.edad});
}
