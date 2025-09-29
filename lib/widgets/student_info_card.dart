import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentInfoCard extends StatelessWidget {
  final Student student;

  const StudentInfoCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${student.name} ${student.lastname}'),
        Text('ID: ${student.id}'),
        Text('Fecha de Nacimiento: ${student.birthday}'),
      ],
    );
  }
}
