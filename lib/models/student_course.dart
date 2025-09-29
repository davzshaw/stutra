// * //
class StudentCourse {
  final int? id;
  final String studentId;
  final int courseId;
  final double mark;
  final String? studentName;
  final String? courseName;
  
  StudentCourse({
    this.id,
    required this.studentId,
    required this.courseId,
    required this.mark,
    this.studentName,
    this.courseName,
  });
  
  factory StudentCourse.fromJson(Map<String, dynamic> json) {
    return StudentCourse(
      id: json['id'],
      studentId: json['student_id'] ?? '',
      courseId: json['course_id'] ?? 0,
      mark: (json['mark'] != null) ? (json['mark'] as num).toDouble() : 0.0,
      studentName: json['student_name'],
      courseName: json['course_name'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'course_id': courseId,
      'mark': mark,
    };
  }
}
