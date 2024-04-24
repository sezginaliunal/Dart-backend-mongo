import 'package:mongo_dart/mongo_dart.dart';

import '../constants/collections.dart';
import '../init/load.env.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  late final Db _db;
  Db get db => _db;
  factory DbService() {
    return _instance;
  }

  DbService._internal() {
    final String? dbUrl = ENV.getEnvValue('DB_URL');

    _db = Db(dbUrl.toString());
  }

  Future<void> openDb() async {
    await _db.open();
    print("Db açıldı $db");
    createAllColl();
  }

  DbCollection getStore(String store) {
    if (!_db.isConnected) {
      throw DatabaseNotOpenException(error: "Db not opened");
    }
    final collection = _db.collection(store);
    return collection;
  }

  Future<void> createAllColl() async {
    final collNames = await db.getCollectionNames();

    for (String collName in CollectionNames.collectionsToCreate) {
      if (!collNames.contains(collName)) {
        await db.createCollection(collName);
      }
    }
  }

  @override
  String toString() {
    return "DbService Hashcode: $hashCode";
  }
}

class DatabaseNotOpenException implements Exception {
  final String error;

  DatabaseNotOpenException({required this.error});
}
