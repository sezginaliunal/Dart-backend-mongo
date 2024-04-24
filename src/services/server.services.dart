import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import '../middleware/router.middleware.dart';
import '../repository/auth.repo.dart';

class ServerService {
  late final Router _router;

  ServerService() {
    _router = Router();

    // Servislerinizi burada ekleyin
    final authRepository = AuthRepository();

    // Her servisin rotasını ana rotaya ekle
    _router.mount('/auth/', authRepository.router.call);
  }

  // Sunucuya bağlan
  Future<void> openServer() async {
    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(handleNotFound())
        .addHandler(_router.call);

    try {
      await serve(handler, InternetAddress.anyIPv4, 8080);
      print('Server listening on port 8080');
    } catch (e) {
      print('Error starting server: $e');
    }
  }
}
