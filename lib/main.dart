import 'package:contact_app/contact_home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ContactHomePages(),
    );
  }
}

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({super.key});

  @override
  Screen2State createState() => Screen2State();
}

class Screen2State extends State<ScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Crear contacto'),
          backgroundColor: Colors.blueAccent),
    );    
  }
  
}