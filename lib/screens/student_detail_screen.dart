import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/student_course.dart';
import '../services/api_service.dart';
import '../widgets/student_info_card.dart';
import '../widgets/courses_list.dart';

class StudentDetailScreen extends StatefulWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  List<StudentCourse> studentCourses = [];
  bool isLoading = true;
  String errorMessage = '';
  late Student currentStudent;

  @override
  void initState() {
    super.initState();
    currentStudent = widget.student;
    _loadStudentCourses();
  }

  Future<void> _loadStudentCourses() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final courses =
          await ApiService.getStudentCoursesByStudent(currentStudent.id);

      if (mounted) {
        setState(() {
          studentCourses = courses;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle Estudiante'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStudentCourses,
          ),
        ],
      ),
      body: Column(
        children: [
          StudentInfoCard(student: currentStudent),
          Expanded(child: _buildCoursesSection()),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Error al cargar cursos'),
          Text(errorMessage),
          ElevatedButton(
            onPressed: _loadStudentCourses,
            child: const Text('Reintentar'),
          ),
        ],
      );
    }

    if (studentCourses.isEmpty) {
      return const Center(child: Text('No hay cursos matriculados'));
    }

    return CoursesList(studentCourses: studentCourses);
  }
}
