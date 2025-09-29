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
      appBar: AppBar(title: const Text('Formularios')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildStudentForm(),
                  _buildCourseForm(),
                  _buildEnrollmentForm(),
                ],
              ),
            ),
    );
  }

  Widget _buildStudentForm() {
    return Column(
      children: [
        const Text('Crear Estudiante'),
        TextField(controller: _studentIdController, decoration: const InputDecoration(labelText: 'ID')),
        TextField(controller: _studentNameController, decoration: const InputDecoration(labelText: 'Nombre')),
        TextField(controller: _studentLastnameController, decoration: const InputDecoration(labelText: 'Apellido')),
        TextField(controller: _studentBirthdayController, decoration: const InputDecoration(labelText: 'Fecha de Nacimiento')),
        Row(
          children: [
            ElevatedButton(onPressed: _saveStudent, child: const Text('Guardar')),
            ElevatedButton(onPressed: _clearStudentForm, child: const Text('Limpiar')),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseForm() {
    return Column(
      children: [
        const Text('Crear Curso'),
        TextField(controller: _courseNameController, decoration: const InputDecoration(labelText: 'Nombre')),
        TextField(controller: _courseCreditsController, decoration: const InputDecoration(labelText: 'Créditos'), keyboardType: TextInputType.number),
        Row(
          children: [
            ElevatedButton(onPressed: _saveCourse, child: const Text('Guardar')),
            ElevatedButton(onPressed: _clearCourseForm, child: const Text('Limpiar')),
          ],
        ),
      ],
    );
  }

  Widget _buildEnrollmentForm() {
    return Column(
      children: [
        const Text('Crear Matrícula'),
        DropdownButton<String>(
          value: selectedStudentId,
          hint: const Text('Seleccionar Estudiante'),
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
        DropdownButton<int>(
          value: selectedCourseId,
          hint: const Text('Seleccionar Curso'),
          items: courses.map((course) {
            return DropdownMenuItem<int>(
              value: course.id,
              child: Text('${course.name} (${course.credits})'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCourseId = value;
            });
          },
        ),
        TextField(controller: _markController, decoration: const InputDecoration(labelText: 'Nota'), keyboardType: TextInputType.number),
        Row(
          children: [
            ElevatedButton(onPressed: _saveEnrollment, child: const Text('Guardar')),
            ElevatedButton(onPressed: _clearEnrollmentForm, child: const Text('Limpiar')),
          ],
        ),
      ],
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
