import 'package:flutter/material.dart';
import 'screens/students_list_screen.dart';

// * //
// Juro solemnemente que no hice practicamente nada de los estilos
// * //

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StuTrac - Gestor de Estudiantes',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const StudentsListScreen(),
    );
  }
}