import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/api_service.dart';
import '../widgets/search_field.dart';
import '../widgets/student_card.dart';
import 'student_detail_screen.dart';
import 'form_screen.dart';
import 'edit_student_screen.dart';

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  List<Student> students = [];
  List<Student> filteredStudents = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final loadedStudents = await ApiService.getStudents();

      setState(() {
        students = loadedStudents;
        filteredStudents = loadedStudents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStudents = students;
      } else {
        filteredStudents = students.where((student) {
          return student.name.toLowerCase().contains(query.toLowerCase()) ||
              student.lastname.toLowerCase().contains(query.toLowerCase()) ||
              student.id.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _deleteStudent(Student student) async {
    try {
      await ApiService.deleteStudent(student.id);
      _loadStudents();
    } catch (e) {
      // Papi, severo error, ni sé como manejarlo xd
    }
  }

  void _sendToEditStudent(student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditStudentScreen(student: student)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchField(
            hintText: 'Buscar...',
            onChanged: _filterStudents,
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen()),
          );
          if (result == true) {
            _loadStudents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: Text("Cargando..."));
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          children: [
            Text("Error"),
            Text(errorMessage),
            TextButton(onPressed: _loadStudents, child: Text("Reintentar")),
          ],
        ),
      );
    }

    if (filteredStudents.isEmpty) {
      return const Center(child: Text("No hay estudiantes"));
    }

    return ListView.builder(
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        final student = filteredStudents[index];
        return StudentCard(
          student: student,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentDetailScreen(student: student),
              ),
            );
            if (result == true) {
              _loadStudents();
            }
          },
          onEdit: () => _sendToEditStudent(student),
          onDelete: () => _deleteStudent(student),
        );
      },
    );
  }
}
