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
      home: LoginPage(), // Cambiado a la página de inicio de sesión
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de sesión'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/background_image.jpg"), // Ruta de la imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200], // Color de fondo suave (gris claro)
              ),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Usuario'),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200], // Color de fondo suave (gris claro)
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              child: Text('Iniciar sesión'),
              onPressed: () {
                // Aquí puedes validar el usuario y la contraseña ingresados
                String username = _usernameController.text;
                String password = _passwordController.text;

                // Ejemplo de validación simple
                if (username == 'usuario' && password == 'contraseña') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error de inicio de sesión'),
                        content: Text('Usuario o contraseña incorrectos.'),
                        actions: [
                          TextButton(
                            child: Text('Aceptar'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
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
                              controller:
                                  TextEditingController(text: edad.toString()),
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
                              modificarPersona(
                                  0, Persona(nombre: nombre, edad: edad));
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
  List<String> hobbies;

  Persona({required this.nombre, required this.edad, this.hobbies = []});
}

