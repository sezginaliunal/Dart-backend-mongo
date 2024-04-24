import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';

import 'extensions/http.extension.dart';

class CustomResponse {
  static Response ok(dynamic data) {
    return Response.ok(
        json.encode({"code": HttpStatus.ok, "success": true, "data": data}),
        headers: CustomHeader.json.getType);
  }

  static Response badRequest(String errorMsg) {
    return Response.badRequest(
        body: json.encode({
          "code": HttpStatus.badRequest,
          "success": false,
          "error": errorMsg,
        }),
        headers: CustomHeader.json.getType);
  }

  static Response unauthorized(String errorMsg) {
    return Response.unauthorized(
        json.encode({
          "code": HttpStatus.unauthorized,
          "success": false,
          "error": errorMsg,
        }),
        headers: CustomHeader.json.getType);
  }

  static Response notFound(String errorMsg) {
    return Response.notFound(
        json.encode(json.encode({
          "code": HttpStatus.notFound,
          "success": false,
          "error": errorMsg,
        })),
        headers: CustomHeader.json.getType);
  }
  // Diğer yanıt türleri de buraya eklenebilir
}
