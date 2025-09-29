// * //
class Course {
  final int id;
  final String name;
  final int credits;
  Course({required this.id, required this.name, required this.credits});
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      credits: json['credits'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'credits': credits};
  }
}
