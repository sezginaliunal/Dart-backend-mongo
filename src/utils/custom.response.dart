import 'dart:convert';
import 'package:shelf/shelf.dart';

import 'extensions/http.extension.dart';

class CustomResponse {
  static Response ok(dynamic body) {
    return Response.ok(json.encode(body), headers: CustomHeader.json.getType);
  }

  static Response badRequest(dynamic body) {
    return Response.badRequest(
        body: json.encode(body), headers: CustomHeader.json.getType);
  }

  static Response unauthorized(dynamic body) {
    return Response.unauthorized(json.encode(body),
        headers: CustomHeader.json.getType);
  }

  static Response notFound(dynamic body) {
    return Response.notFound(json.encode(body),
        headers: CustomHeader.json.getType);
  }
  // Diğer yanıt türleri de buraya eklenebilir
}
