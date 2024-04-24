import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/user/user.dart';
import '../utils/custom.response.dart';
import '../utils/extensions/email.regexp.dart';
import '../utils/extensions/hash.dart';
import '../utils/extensions/parseData.dart';
import '../utils/extensions/password.regexp.dart';
import '../utils/helpers/user.information.check.dart';
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
    User? user = await request.parseBody(User.fromJson);

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
    User? user = await request.parseBody(User.fromJson);
    if (user == null || isUserInformationIncomplete(user)) {
      return CustomResponse.badRequest(
          {"error": "Email, username, or password must be filled"});
    }

    if (!user.email!.isValidEmail()) {
      return CustomResponse.badRequest({"error": "Invalid email format"});
    }

    if (!user.password!.isValidPassword()) {
      return CustomResponse.badRequest({
        "error":
            "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one digit, and one special character"
      });
    }

    final addedUser = await _coll.findOne(where.eq('email', user.email));
    if (addedUser != null) {
      return CustomResponse.badRequest({"error": "User already exists"});
    }

    await _coll.insertOne(user.toJson());
    return CustomResponse.ok({"message": "Registration successful"});
  }

  Router get router => _router;
}
