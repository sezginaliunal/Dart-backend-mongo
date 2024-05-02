import 'package:mongo_dart/mongo_dart.dart';

// User modeli
class User {
  final ObjectId id;
  final String name;
  final int age;

  User(this.name, this.age, {required this.id});

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'age': age,
    };
  }

  // JSON'dan User objesine dönüştürme
  static User fromJson(Map<String, dynamic> json) {
    return User(json['name'], json['age'], id: json['_id']);
  }
}
