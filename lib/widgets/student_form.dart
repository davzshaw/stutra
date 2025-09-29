import 'package:flutter/material.dart';

class StudentForm extends StatelessWidget {
  final TextEditingController idController;
  final TextEditingController nameController;
  final TextEditingController lastnameController;
  final TextEditingController birthdayController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const StudentForm({
    super.key,
    required this.idController,
    required this.nameController,
    required this.lastnameController,
    required this.birthdayController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Crear Estudiante'),
        TextField(
          controller: idController,
        ),
        TextField(
          controller: nameController,
        ),
        TextField(
          controller: lastnameController,
        ),
        TextField(
          controller: birthdayController,
        ),
        Row(
          children: [
            TextButton(
              onPressed: onSave,
              child: Text('Guardar Estudiante'),
            ),
            TextButton(
              onPressed: onCancel,
              child: Text('Limpiar'),
            ),
          ],
        ),
      ],
    );
  }
}
