import '../services/db.services.dart';
import '../services/server.services.dart';
import 'load.env.dart';

class InitApp {
  Future<void> initializeApp() async {
    //Load Env
    ENV.loadEnv();
    //Open Db
    await DbService().openDb();
    //Open Server
    await ServerService().openServer();
  }
}
