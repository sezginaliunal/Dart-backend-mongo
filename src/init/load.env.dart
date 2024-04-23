import 'package:dotenv/dotenv.dart';

class ENV {
  static late DotEnv _env;

  static void loadEnv() {
    _env = DotEnv()..load();
  }

  static String? getEnvValue(String key) {
    return _env[key];
  }
}
