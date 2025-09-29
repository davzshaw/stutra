import 'package:flutter/material.dart';

class StudentForm extends StatelessWidget {
  final TextEditingController idController;
  final TextEditingController nameController;
  final TextEditingController lastnameController;
  final TextEditingController birthdayController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const StudentForm({
    super.key,
    required this.idController,
    required this.nameController,
    required this.lastnameController,
    required this.birthdayController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person_add_rounded, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Crear Estudiante',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID del Estudiante',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lastnameController,
              decoration: InputDecoration(
                labelText: 'Apellido',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: birthdayController,
              decoration: InputDecoration(
                labelText: 'Fecha de Nacimiento',
                hintText: 'YYYY-MM-DD',
                prefixIcon: const Icon(Icons.cake_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSave,
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
                    onPressed: onCancel,
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
}
