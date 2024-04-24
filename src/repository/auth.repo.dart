import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../constants/errors.dart';
import '../models/user/user.dart';
import '../services/auth.services.dart';
import '../services/db.services.dart';
import '../utils/custom.response.dart';
import '../utils/extensions/email.regexp.dart';
import '../utils/extensions/hash.dart';
import '../utils/extensions/parse.data.dart';
import '../utils/extensions/password.regexp.dart';
import '../utils/helpers/user.information.check.dart';

class AuthRepository extends IAuthService {
  late final Router _router;
  late final DbService _dbService;
  late final DbCollection _coll;
  late final ErrorMessages _errorMessages;
  AuthRepository() {
    _router = Router();
    _dbService = DbService();
    _coll = _dbService.getStore('users');
    _errorMessages = ErrorMessages();
    // AuthRepository'a özgü rotaları tanımla
    _router.post('/login', handleLogin);
    _router.post('/register', handleRegister);
  }

  @override
  Future<Response> handleLogin(Request request) async {
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
          return CustomResponse.ok(user);
        } else {
          // Şifreler eşleşmiyorsa hata mesajını döndür
          return CustomResponse.unauthorized(_errorMessages.invalidPassword);
        }
      } else {
        // Kullanıcı bulunamadıysa hata mesajını döndür
        return CustomResponse.unauthorized(_errorMessages.userNotFound);
      }
    } else {
      // Kullanıcı nesnesi null ise hata mesajını döndür
      return CustomResponse.badRequest(_errorMessages.emptyRequest);
    }
  }

  //Kayıt olma işlemleri
  @override
  Future<Response> handleRegister(Request request) async {
    User? user = await request.parseBody(User.fromJson);
    if (user == null || isUserInformationIncomplete(user)) {
      return CustomResponse.badRequest(_errorMessages.mustBeFilled);
    }

    if (!user.email!.isValidEmail()) {
      return CustomResponse.badRequest(_errorMessages.invalidEmailFormat);
    }

    if (!user.password!.isValidPassword()) {
      return CustomResponse.badRequest(_errorMessages.passLongError);
    }

    final addedUser = await _coll.findOne(where.eq('email', user.email));
    if (addedUser != null) {
      return CustomResponse.badRequest(_errorMessages.userAlreadyExist);
    }

    await _coll.insertOne(user.toJson());
    return CustomResponse.ok(user);
  }

  @override
  Router get router => _router;
}
