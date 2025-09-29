import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/course.dart';

class EnrollmentForm extends StatelessWidget {
  final List<Student> students;
  final List<Course> courses;
  final String? selectedStudentId;
  final int? selectedCourseId;
  final TextEditingController markController;
  final ValueChanged<String?> onStudentChanged;
  final ValueChanged<int?> onCourseChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EnrollmentForm({
    super.key,
    required this.students,
    required this.courses,
    required this.selectedStudentId,
    required this.selectedCourseId,
    required this.markController,
    required this.onStudentChanged,
    required this.onCourseChanged,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.assignment_rounded, color: Colors.orange, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Crear Matrícula',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: DropdownButton<String>(
                value: selectedStudentId,
                hint: const Text('Seleccionar estudiante'),
                isExpanded: true,
                underline: const SizedBox(),
                items: students.map((student) {
                  return DropdownMenuItem<String>(
                    value: student.id,
                    child: Text('${student.name} ${student.lastname} (${student.id})'),
                  );
                }).toList(),
                onChanged: onStudentChanged,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: DropdownButton<int>(
                value: selectedCourseId,
                hint: const Text('Seleccionar curso'),
                isExpanded: true,
                underline: const SizedBox(),
                items: courses.map((course) {
                  return DropdownMenuItem<int>(
                    value: course.id,
                    child: Text('${course.name} (${course.credits} créditos)'),
                  );
                }).toList(),
                onChanged: onCourseChanged,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: markController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nota (Opcional)',
                prefixIcon: const Icon(Icons.grade_outlined),
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
                    label: const Text('Crear'),
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
