import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/course.dart';
import '../models/student_course.dart';
import '../services/api_service.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _studentIdController = TextEditingController();
  final _studentNameController = TextEditingController();
  final _studentLastnameController = TextEditingController();
  final _studentBirthdayController = TextEditingController();

  final _courseNameController = TextEditingController();
  final _courseCreditsController = TextEditingController();

  final _markController = TextEditingController();

  List<Student> students = [];
  List<Course> courses = [];
  String? selectedStudentId;
  int? selectedCourseId;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loadedStudents = await ApiService.getStudents();
      final loadedCourses = await ApiService.getCourses();

      if (mounted) {
        setState(() {
          students = loadedStudents;
          courses = loadedCourses;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    }
  }

  Future<void> _saveStudent() async {
    if (_studentIdController.text.isEmpty ||
        _studentNameController.text.isEmpty ||
        _studentLastnameController.text.isEmpty ||
        _studentBirthdayController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor complete todos los campos')),
        );
      }
      return;
    }

    if (mounted) setState(() => isLoading = true);

    try {
      final student = Student(
        id: _studentIdController.text,
        name: _studentNameController.text,
        lastname: _studentLastnameController.text,
        birthday: _studentBirthdayController.text,
      );

      await ApiService.addStudent(student);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estudiante creado exitosamente')),
        );
        _clearStudentForm();
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear estudiante: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _saveCourse() async {
    if (_courseNameController.text.isEmpty ||
        _courseCreditsController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor complete todos los campos')),
        );
      }
      return;
    }

    if (mounted) setState(() => isLoading = true);

    try {
      final course = Course(
        id: 0,
        name: _courseNameController.text,
        credits: int.parse(_courseCreditsController.text),
      );

      await ApiService.addCourse(course);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Curso creado exitosamente')),
        );
        _clearCourseForm();
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear curso: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _saveEnrollment() async {
    if (selectedStudentId == null || selectedCourseId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione estudiante y curso')),
        );
      }
      return;
    }

    if (mounted) setState(() => isLoading = true);

    try {
      final mark = _markController.text.isEmpty
          ? 0.0
          : double.parse(_markController.text);

      final enrollment = StudentCourse(
        studentId: selectedStudentId!,
        courseId: selectedCourseId!,
        mark: mark,
      );

      await ApiService.addStudentCourse(enrollment);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Matrícula creada exitosamente')),
        );
        _clearEnrollmentForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear matrícula: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _clearStudentForm() {
    _studentIdController.clear();
    _studentNameController.clear();
    _studentLastnameController.clear();
    _studentBirthdayController.clear();
  }

  void _clearCourseForm() {
    _courseNameController.clear();
    _courseCreditsController.clear();
  }

  void _clearEnrollmentForm() {
    setState(() {
      selectedStudentId = null;
      selectedCourseId = null;
    });
    _markController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Formularios',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Procesando...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStudentForm(),
                  const SizedBox(height: 24),
                  _buildCourseForm(),
                  const SizedBox(height: 24),
                  _buildEnrollmentForm(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }

  Widget _buildStudentForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.blue[50]!],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_add_rounded, color: Colors.blue, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Crear Estudiante',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(
                labelText: 'ID del Estudiante',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _studentNameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _studentLastnameController,
              decoration: InputDecoration(
                labelText: 'Apellido',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _studentBirthdayController,
              decoration: InputDecoration(
                labelText: 'Fecha de Nacimiento',
                hintText: 'YYYY-MM-DD',
                prefixIcon: const Icon(Icons.cake_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveStudent,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearStudentForm,
                    icon: const Icon(Icons.clear_rounded),
                    label: const Text('Limpiar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.green[50]!],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school_rounded, color: Colors.green, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Crear Curso',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _courseNameController,
              decoration: InputDecoration(
                labelText: 'Nombre del Curso',
                prefixIcon: const Icon(Icons.book_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _courseCreditsController,
              decoration: InputDecoration(
                labelText: 'Créditos',
                prefixIcon: const Icon(Icons.star_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveCourse,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearCourseForm,
                    icon: const Icon(Icons.clear_rounded),
                    label: const Text('Limpiar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnrollmentForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.orange[50]!],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.assignment_rounded, color: Colors.orange, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Crear Matrícula',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: DropdownButton<String>(
                value: selectedStudentId,
                hint: const Text('Seleccionar Estudiante'),
                isExpanded: true,
                underline: const SizedBox(),
                items: students.map((student) {
                  return DropdownMenuItem<String>(
                    value: student.id,
                    child: Text('${student.name} ${student.lastname} (${student.id})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStudentId = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: DropdownButton<int>(
                value: selectedCourseId,
                hint: const Text('Seleccionar Curso'),
                isExpanded: true,
                underline: const SizedBox(),
                items: courses.map((course) {
                  return DropdownMenuItem<int>(
                    value: course.id,
                    child: Text('${course.name} (${course.credits} créditos)'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCourseId = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _markController,
              decoration: InputDecoration(
                labelText: 'Nota (Opcional)',
                prefixIcon: const Icon(Icons.grade_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveEnrollment,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearEnrollmentForm,
                    icon: const Icon(Icons.clear_rounded),
                    label: const Text('Limpiar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _studentNameController.dispose();
    _studentLastnameController.dispose();
    _studentBirthdayController.dispose();
    _courseNameController.dispose();
    _courseCreditsController.dispose();
    _markController.dispose();
    super.dispose();
  }
}
