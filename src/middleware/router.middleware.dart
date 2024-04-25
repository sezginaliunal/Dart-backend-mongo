import 'dart:io';

import 'package:shelf/shelf.dart';

import '../utils/custom.response.dart';

Middleware handleNotFound() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);
      if (response.statusCode == HttpStatus.notFound) {
        return CustomResponse.notFound("Route not found");
      }

      return response;
    };
  };
}
