import 'package:shelf/shelf.dart';

import '../utils/custom.response.dart';

Middleware handleNotFound() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);

      // Eğer response null döndürdüyse ve 404 kodunu içermiyorsa, 404 dön
      if (response.statusCode == 404) {
        return CustomResponse.notFound({"error": "Route not found"});
      }

      return response;
    };
  };
}
