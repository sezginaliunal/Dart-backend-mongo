import 'dart:convert';

import 'package:shelf/shelf.dart';

extension ParseBody on Request {
  Future<T?> parseBody<T>(T Function(Map<String, dynamic>) fromJson) async {
    try {
      // İsteğin gövdesini al
      String requestBody = await readAsString();

      // Eğer gövde boşsa null döndür
      if (requestBody.isEmpty) {
        return null;
      }

      // Gövde boş değilse işlemleri yapabiliriz
      // Gövdeyi JSON formatından bir Dart nesnesine çevir
      Map<String, dynamic> requestData = json.decode(requestBody);

      // Verileri istenen modele dönüştür
      return fromJson(requestData);
    } catch (e) {
      // Hata oluştuğunda null döndür
      return null;
    }
  }
}
