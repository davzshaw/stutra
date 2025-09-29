import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/course.dart';

class EnrollmentForm extends StatelessWidget {
  final List<Student> students;
  final List<Course> courses;
  final String? selectedStudentId;
  final int? selectedCourseId;
  final TextEditingController markController;
  final ValueChanged<String?> onStudentChanged;
  final ValueChanged<int?> onCourseChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EnrollmentForm({
    super.key,
    required this.students,
    required this.courses,
    required this.selectedStudentId,
    required this.selectedCourseId,
    required this.markController,
    required this.onStudentChanged,
    required this.onCourseChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Crear Matrícula'),
        DropdownButton<String>(
          value: selectedStudentId,
          hint: const Text('Seleccionar estudiante'),
          items: students.map((student) {
            return DropdownMenuItem<String>(
              value: student.id,
              child: Text('${student.name} ${student.lastname} (${student.id})'),
            );
          }).toList(),
          onChanged: onStudentChanged,
        ),
        DropdownButton<int>(
          value: selectedCourseId,
          hint: const Text('Seleccionar curso'),
          items: courses.map((course) {
            return DropdownMenuItem<int>(
              value: course.id,
              child: Text('${course.name} (${course.credits} créditos)'),
            );
          }).toList(),
          onChanged: onCourseChanged,
        ),
        TextField(
          controller: markController,
          keyboardType: TextInputType.number,
        ),
        Row(
          children: [
            TextButton(
              onPressed: onSave,
              child: const Text('Crear Matrícula'),
            ),
            TextButton(
              onPressed: onCancel,
              child: const Text('Limpiar'),
            ),
          ],
        ),
      ],
    );
  }
}
