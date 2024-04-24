import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class IAuthService {
  Future<Response> handleLogin(Request request);

  Future<Response> handleRegister(Request request);

  // Router nesnesini döndüren yöntem
  Router get router;
}
