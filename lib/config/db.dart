import 'package:dart_backend/config/base_db.dart';
import 'package:dart_backend/constants/collections.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase extends IBaseDb {
  late Db _db;
  Db get db => _db;
  static final MongoDatabase _instance = MongoDatabase._init();

  MongoDatabase._init() {
    _db = Db("mongodb://localhost:27017/test");
  }

  factory MongoDatabase() => _instance;

  @override
  Future<void> connectDb() async {
    await db.open();
    createCollectionOrTable();
  }

  @override
  Future<void> closeDb() async {
    await db.close();
  }

  @override
  Future<void> createCollectionOrTable() async {
    var collectionInfos = await db.getCollectionNames();
    for (var collectionInfo in collectionInfos) {
      for (var collectionNames in collectionNames) {
        if (!collectionInfo!.contains(collectionNames)) {
          await db.createCollection(collectionNames);
        }
      }
    }
  }
}
