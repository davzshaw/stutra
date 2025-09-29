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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Editar Estudiante',
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
                    'Guardando cambios...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
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
                              Colors.white,
                              Colors.grey[50]!,
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.edit_rounded,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Información del Estudiante',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Nombre',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _lastnameController,
                              decoration: InputDecoration(
                                labelText: 'Apellido',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _birthdayController,
                              decoration: InputDecoration(
                                labelText: 'Fecha de Nacimiento',
                                hintText: 'YYYY-MM-DD',
                                prefixIcon: const Icon(Icons.cake_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Requerido';
                                final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                                if (!regex.hasMatch(v)) return 'Formato inválido (YYYY-MM-DD)';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isLoading ? null : _saveStudent,
                            icon: const Icon(Icons.save_rounded),
                            label: const Text(
                              'Guardar',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text(
                              'Cancelar',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey[400]!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
