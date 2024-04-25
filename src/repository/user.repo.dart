import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../constants/errors.dart';

import '../models/user/user.dart';
import '../services/db.services.dart';
import '../services/user.services.dart';
import '../utils/custom.response.dart';
import '../utils/extensions/parse.data.dart';

class UserRepository extends IUserService {
  late final Router _router;
  late final DbService _dbService;
  late final DbCollection _coll;
  late final ErrorMessages _errorMessages;
  UserRepository() {
    _router = Router();
    _dbService = DbService();
    _coll = _dbService.getStore('users');
    _errorMessages = ErrorMessages();
    // UserRepository'aa özgü rotaları tanımla
    _router.get('/getAllUser', getAllUser);
    _router.get('/<id>', getMeInfo);
    _router.post('/updateMe/<id>', updateMe);
  }

  @override
  Router get router => _router;

  @override
  Future<Response> getAllUser(Request request) async {
    final users = await _coll.find().toList();
    return CustomResponse.ok(users);
  }

  @override
  Future<Response> getMeInfo(Request request, String id) async {
    try {
      final objectId = ObjectId.tryParse(id);
      if (objectId == null || !ObjectId.isValidHexId(id)) {
        return CustomResponse.badRequest(_errorMessages.invalidObjectId);
      }

      final user = await _coll.findOne(where.eq('_id', objectId));
      if (user != null) {
        return CustomResponse.ok(user);
      } else {
        return CustomResponse.notFound(_errorMessages.invalidObjectId);
      }
    } catch (e) {
      return CustomResponse.internalServerError(
          _errorMessages.internalServerError);
    }
  }

  @override
  Future<Response> updateMe(Request request, String id) async {
    // İsteği gelen JSON verisini kullanıcı nesnesine dönüştür
    User? user = await request.parseBody(User.fromJson);
    print(user?.email);
    print(user?.password);
    print(user?.username);
    final objectId = ObjectId.tryParse(id);
    if (objectId == null || !ObjectId.isValidHexId(id)) {
      return CustomResponse.badRequest(_errorMessages.invalidObjectId);
    }

    var rs = await _coll.findOne(where.id(objectId));
    print(rs);

    if (rs != null) {
      // Request body'den gelen parametreleri güncelle
      // Örneğin, güncelleme işlemi için bir update fonksiyonu kullanılabilir:
      await _coll.update(where.id(objectId), {
        '\$set': {
          'email': request.params['email'],
          'username': request.params['username'],
          // ... diğer güncellenecek alanlar
        }
      });

      // Güncellenmiş kaydı tekrar al
      var updatedUser = await _coll.findOne(where.id(objectId));

      return CustomResponse.ok(updatedUser);
    } else {
      return CustomResponse.badRequest(_errorMessages.userNotFound);
    }
  }
}
