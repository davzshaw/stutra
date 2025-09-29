import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/api_service.dart';

// * //
// Validator
// IsLoading
// * //

class EditStudentScreen extends StatefulWidget {
  final Student student;

  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _birthdayController;
  
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _lastnameController = TextEditingController(text: widget.student.lastname);
    _birthdayController = TextEditingController(text: widget.student.birthday);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final updatedStudent = Student(
        id: widget.student.id,
        name: _nameController.text.trim(),
        lastname: _lastnameController.text.trim(),
        birthday: _birthdayController.text.trim(),
      );

      await ApiService.updateStudent(widget.student.id, updatedStudent);

      if (mounted) {
        Navigator.of(context).pop(updatedStudent);
      }
    } catch (e) {
      debugPrint("❌ Error al actualizar estudiante: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Estudiante')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                  ),
                  TextFormField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                  ),
                  TextFormField(
                    controller: _birthdayController,
                    decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requerido';
                      final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                      if (!regex.hasMatch(v)) return 'Formato inválido (YYYY-MM-DD)';
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveStudent,
                    child: const Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ),
    );
  }
}
