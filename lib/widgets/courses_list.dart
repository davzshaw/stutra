import 'package:flutter/material.dart';
import '../models/student_course.dart';

class CoursesList extends StatelessWidget {
  final List<StudentCourse> studentCourses;

  const CoursesList({
    super.key,
    required this.studentCourses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Cursos y Notas:'),
        Expanded(
          child: ListView.builder(
            itemCount: studentCourses.length,
            itemBuilder: (context, index) {
              final sc = studentCourses[index];
              return ListTile(
                title: Text('${sc.courseName} (${sc.mark})'),
                subtitle: Text('ID Curso: ${sc.courseId}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
