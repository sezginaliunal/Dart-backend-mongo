import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/user/user.req.dart';
import '../utils/custom.response.dart';
import '../utils/extensions/hash.dart';
import '../utils/extensions/parseData.dart';
import 'db.services.dart';

class AuthService {
  late final Router _router;
  late final DbService _dbService;
  late final DbCollection _coll;
  AuthService() {
    _router = Router();
    _dbService = DbService();
    _coll = _dbService.getStore('users');

    // AuthService'a özgü rotaları tanımla
    _router.post('/login', _handleLogin);
    _router.post('/register', _handleRegister);
  }

  Future<Response> _handleLogin(Request request) async {
    // İsteği gelen JSON verisini kullanıcı nesnesine dönüştür
    ReqUser? user = await request.parseBody(ReqUser.fromJson);

    if (user != null) {
      // Kullanıcının email'ine göre veritabanında kullanıcı ara
      final foundUser = await _coll.findOne({
        'email': user.email,
      });

      if (foundUser != null) {
        // Kullanıcı bulunduysa, veritabanındaki şifre ile kullanıcının şifresini karşılaştır
        bool isPasswordValid = user.password!.verifyHash(foundUser['password']);

        if (isPasswordValid) {
          // Şifreler eşleşiyorsa başarılı giriş mesajını döndür
          return CustomResponse.ok({"message": "Login success"});
        } else {
          // Şifreler eşleşmiyorsa hata mesajını döndür
          return CustomResponse.unauthorized({"error": "Invalid password"});
        }
      } else {
        // Kullanıcı bulunamadıysa hata mesajını döndür
        return CustomResponse.unauthorized({"error": "Invalid email"});
      }
    } else {
      // Kullanıcı nesnesi null ise hata mesajını döndür
      return CustomResponse.badRequest(
          {"error": "Request body is empty or invalid"});
    }
  }

  //Kayıt olma işlemleri
  Future<Response> _handleRegister(Request request) async {
    ReqUser? user = await request.parseBody(ReqUser.fromJson);
    if (user != null) {
      final addedUser = await _coll.findOne(where.eq('email', user.email));
      if (addedUser != null) {
        print(addedUser);
        return CustomResponse.badRequest({"error": "User already exist"});
      }
      await _coll.insertOne(user.toJson());
      return CustomResponse.ok({"message": "register success"});
    } else {
      return CustomResponse.badRequest(
          {"error": "Request body is empty or invalid"});
    }
  }

  Router get router => _router;
}
