import 'package:mongo_dart/mongo_dart.dart';

import '../../utils/extensions/hash.dart';

class ReqUser {
  ObjectId? id;
  final String? username;
  final String? email;
  final String? password;

  ReqUser(this.username, this.password, this.email, {this.id});

  factory ReqUser.fromJson(Map<String, dynamic> json) {
    return ReqUser(
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
      // ignore: deprecated_member_use
      '_id': id?.toHexString() ?? '',
    };
  }
}
