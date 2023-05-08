import 'package:flutter/material.dart';
import 'dart:math';
import 'registrar.dart';
// import 'modificar.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<Persona> personas = [];
  int totalPersonas = 0;
  double promedioEdad = 0.0;

  void _agregarPersona(Persona persona) {
    setState(() {
      personas.add(persona);
      totalPersonas = personas.length;
      promedioEdad = roundDouble(_calcularPromedioEdad(), 2);
    });
  }

  void _eliminarPersona(Persona persona) {
    setState(() {
      personas.remove(persona);
      totalPersonas = personas.length;
      promedioEdad = roundDouble(_calcularPromedioEdad(), 2);
    });
  }
  // cdiaz: Función para redondear el promedio de edad a 2 decimales:
  // (Usa la biblioteca Math de Dart)

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  double _calcularPromedioEdad() {
    if (personas.isEmpty) return 0.0;
    double sum = 0;
    for (var persona in personas) {
      sum += persona.edad;
    }
    return sum / personas.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('App Personas versión 0.1')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Personas registradas: $totalPersonas',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Promedio de edad: $promedioEdad',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: personas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(personas[index].nombreCompleto),
                  subtitle: Row(
                    children: [
                      Text('Edad: ${personas[index].edad}'),
                      const Text(' /// '),
                      Text('Email: ${personas[index].email}')
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _eliminarPersona(personas[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrarPersona()),
          );
          if (result != null) {
            _agregarPersona(result);
          }
        },
      ),
    );
  }
}
