import 'package:shelf/shelf.dart';

import '../utils/custom.response.dart';

Middleware handleNotFound() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);
      if (response.statusCode == 404) {
        return CustomResponse.notFound("Route not found");
      }

      return response;
    };
  };
}
