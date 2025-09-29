import 'package:flutter/material.dart';

class CourseForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController creditsController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const CourseForm({
    super.key,
    required this.nameController,
    required this.creditsController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Crear Curso'),
        TextField(
          controller: nameController,
        ),
        TextField(
          controller: creditsController,
          keyboardType: TextInputType.number,
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: onSave,
              child: const Text('Guardar Curso'),
            ),
            ElevatedButton(
              onPressed: onCancel,
              child: const Text('Limpiar'),
            ),
          ],
        ),
      ],
    );
  }
}
