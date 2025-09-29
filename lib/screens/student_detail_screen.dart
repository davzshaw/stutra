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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Detalle del Estudiante',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _loadStudentCourses,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: StudentInfoCard(student: currentStudent),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCoursesSection(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
          ),
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
