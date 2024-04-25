import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

abstract class IUserService {
  Future<Response> getMeInfo(Request request, String id);
  Future<Response> getAllUser(Request request);
  Future<Response> updateMe(Request request, String id);
  Router get router;
}
