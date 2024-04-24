import 'package:mongo_dart/mongo_dart.dart';

import '../../utils/extensions/hash.dart';

class User {
  ObjectId? id;
  final String? username;
  final String? email;
  final String? password;

  User(this.username, this.password, this.email, {this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['username'] ?? '',
      json['password'] ?? '',
      json['email'] ?? '',
      id: json['_id'] != null
          ? ObjectId.fromHexString(json['_id'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username ?? '',
      'email': email ?? '',
      'password': password?.hashString() ?? '',
      '_id': ObjectId(),
    };
  }
}
