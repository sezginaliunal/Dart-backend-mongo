import 'package:dart_backend/config/db.dart';
import 'package:dart_backend/services/user.db.query.services.dart';
import 'package:mongo_dart/mongo_dart.dart';

// User servisleri
class UserServices implements IUserQueryServices {
  late final Db _db;
  late final DbCollection coll;

  UserServices() {
    _db = MongoDatabase().db;
    coll = _db.collection('users');
  }
  @override
  Future<void> deleteOne(String id) async {
    await coll.deleteOne({"_id": ObjectId.parse(id)});
  }

  @override
  Future<void> updateOne(String id, String field, dynamic data) async {
    coll.update(where.eq('_id', ObjectId.parse(id)), modify.set(field, data),
        multiUpdate: true);
  }
}
