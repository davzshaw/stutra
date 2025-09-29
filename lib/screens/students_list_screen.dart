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
      MaterialPageRoute(
        builder: (context) => EditStudentScreen(student: student),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Estudiantes',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _loadStudents,
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.15),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SearchField(
              hintText: 'Buscar estudiante...',
              onChanged: _filterStudents,
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FormScreen()),
            );
            if (result == true) {
              _loadStudents();
            }
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Crear',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Cargando estudiantes...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.red[50]!, Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Error al cargar estudiantes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadStudents,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (filteredStudents.isEmpty) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  Colors.white,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.people_outline_rounded,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No hay estudiantes registrados',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Agrega el primer estudiante usando el botón +',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
      itemCount: filteredStudents.length,
      itemBuilder: (context, index) {
        final student = filteredStudents[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: StudentCard(
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
          ),
        );
      },
    );
  }
}
