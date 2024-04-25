import 'dart:convert';

import 'package:shelf/shelf.dart';

extension ParseBody on Request {
  Future<T?> parseBody<T>(T Function(Map<String, dynamic>) fromJson) async {
    try {
      String requestBody = await readAsString();

      if (requestBody.isEmpty) {
        return null;
      }

      Map<String, dynamic> requestData = json.decode(requestBody);

      return fromJson(requestData);
    } catch (e) {
      // Hata oluştuğunda null döndür
      return null;
    }
  }
}
