import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';
import '../models/course.dart';
import '../models/student_course.dart';

// * //
class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // ==================== ESTUDIANTES ====================

  static Future<List<Student>> getStudents() async {
    try {
      print("Debugging realizado con ChatGPT");
      print('GET $baseUrl/students');
      final response = await http.get(Uri.parse('$baseUrl/students'));
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Estudiantes: ${jsonList.length}');
        return jsonList.map((json) => Student.fromJson(json)).toList();
      } else {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al obtener estudiantes: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en getStudents: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Student> getStudent(String id) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('GET $baseUrl/students/$id');
      final response = await http.get(Uri.parse('$baseUrl/students/$id'));
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return Student.fromJson(json.decode(response.body));
      } else {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al obtener estudiante: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en getStudent: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Student> addStudent(Student student) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('POST $baseUrl/students');
      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: headers,
        body: json.encode(student.toJson()),
      );
      print('Status: ${response.statusCode}');

      if (response.statusCode == 201) {
        return Student.fromJson(json.decode(response.body));
      } else {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al crear estudiante: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en addStudent: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Student> updateStudent(String id, Student student) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('PUT $baseUrl/students/$id');
      final response = await http.put(
        Uri.parse('$baseUrl/students/$id'),
        headers: headers,
        body: json.encode(student.toJson()),
      );
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return Student.fromJson(json.decode(response.body));
      } else {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al actualizar estudiante: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en updateStudent: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<void> deleteStudent(String id) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('DELETE $baseUrl/students/$id');
      final response = await http.delete(Uri.parse('$baseUrl/students/$id'));
      print('Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al eliminar estudiante: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en deleteStudent: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // ==================== CURSOS ====================

  static Future<List<Course>> getCourses() async {
    try {
      print("Debugging realizado con ChatGPT");
      print('GET $baseUrl/courses');
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Cursos: ${jsonList.length}');
        return jsonList.map((json) => Course.fromJson(json)).toList();
      } else {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al obtener cursos: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en getCourses: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Course> addCourse(Course course) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('POST $baseUrl/courses');
      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: headers,
        body: json.encode(course.toJson()),
      );
      print('Status: ${response.statusCode}');

      if (response.statusCode == 201) {
        return Course.fromJson(json.decode(response.body));
      } else {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al crear curso: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en addCourse: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Course> updateCourse(int id, Course course) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('PUT $baseUrl/courses/$id');
      final response = await http.put(
        Uri.parse('$baseUrl/courses/$id'),
        headers: headers,
        body: json.encode(course.toJson()),
      );
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return Course.fromJson(json.decode(response.body));
      } else {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al actualizar curso: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en updateCourse: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<void> deleteCourse(int id) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('DELETE $baseUrl/courses/$id');
      final response = await http.delete(Uri.parse('$baseUrl/courses/$id'));
      print('Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al eliminar curso: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en deleteCourse: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // ==================== MATRÍCULAS ====================

  static Future<List<StudentCourse>> getStudentCourses() async {
    try {
      print("Debugging realizado con ChatGPT");
      print('GET $baseUrl/student_courses');
      final response = await http.get(Uri.parse('$baseUrl/student_courses'));
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Matrículas: ${jsonList.length}');
        return jsonList.map((json) => StudentCourse.fromJson(json)).toList();
      } else {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al obtener matrículas: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en getStudentCourses: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<List<StudentCourse>> getStudentCoursesByStudent(
    String studentId,
  ) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('Filtrando matrículas por estudiante $studentId');
      final allEnrollments = await getStudentCourses();
      return allEnrollments.where((sc) => sc.studentId == studentId).toList();
    } catch (e) {
      print('Excepción en getStudentCoursesByStudent: $e');
      throw Exception('Error al obtener matrículas del estudiante: $e');
    }
  }

  static Future<StudentCourse> addStudentCourse(
    StudentCourse studentCourse,
  ) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('POST $baseUrl/student_courses');
      final response = await http.post(
        Uri.parse('$baseUrl/student_courses'),
        headers: headers,
        body: json.encode(studentCourse.toJson()),
      );
      print('Status: ${response.statusCode}');

      if (response.statusCode == 201) {
        return StudentCourse.fromJson(json.decode(response.body));
      } else {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al crear matrícula: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en addStudentCourse: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<StudentCourse> updateStudentCourse(
    int id,
    StudentCourse studentCourse,
  ) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('PUT $baseUrl/student_courses/$id');
      final response = await http.put(
        Uri.parse('$baseUrl/student_courses/$id'),
        headers: headers,
        body: json.encode(studentCourse.toJson()),
      );
      print('Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return StudentCourse.fromJson(json.decode(response.body));
      } else {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al actualizar matrícula: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en updateStudentCourse: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<void> deleteStudentCourse(int id) async {
    try {
      print("Debugging realizado con ChatGPT");
      print('DELETE $baseUrl/student_courses/$id');
      final response = await http.delete(
        Uri.parse('$baseUrl/student_courses/$id'),
      );
      print('Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        print('Error HTTP: ${response.statusCode}');
        throw Exception('Error al eliminar matrícula: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción en deleteStudentCourse: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}
