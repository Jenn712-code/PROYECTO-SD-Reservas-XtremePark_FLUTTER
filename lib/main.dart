import 'package:flutter/material.dart';
import 'home_page.dart'; // Importa la nueva página que acabas de crear

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva Parque Extremo',
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de debug
      theme: ThemeData(
        // Puedes definir los colores principales aquí
        primarySwatch: Colors.green,
      ),
      // Muestra la HomePage como la pantalla inicial
      home: const HomePage(),
    );
  }
}