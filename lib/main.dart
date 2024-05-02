import 'package:dart_backend/config/db.dart';
import 'package:dart_backend/services/user.services.dart';

void main() async {
  var mongoDb = MongoDatabase();

  await mongoDb.connectDb();

  // User servisini kullanarak kullanıcıyı veritabanına ekle
  var userService = UserServices();

  // Kullanıcıyı güncelle
  await userService.updateOne("6630f3489f8ee62207000000", "name", "Sessszgin");
  await userService.deleteOne("6630f3489f8ee62207000000");
}
