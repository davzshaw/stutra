// * //
class Student {
  final String id;
  final String name;
  final String lastname;
  final String birthday;
  Student({
    required this.id,
    required this.name,
    required this.lastname,
    required this.birthday,
  });
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      birthday: json['birthday'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'lastname': lastname, 'birthday': birthday};
  }
}
