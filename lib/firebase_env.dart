import 'package:envify/envify.dart';

part 'firebase_env.g.dart';

@Envify()
class FirebaseEnv {
  static const String apiKeyWeb = _FirebaseEnv.apiKeyWeb;
  static const String appIdWeb = _FirebaseEnv.appIdWeb;
  static const String messagingSenderId = _FirebaseEnv.messagingSenderId;
  static const String projectId = _FirebaseEnv.projectId;
  static const String authDomain = _FirebaseEnv.authDomain;
  static const String storageBucket = _FirebaseEnv.storageBucket;

  static const String apiKeyAndroid = _FirebaseEnv.apiKeyAndroid;
  static const String appIdAndroid = _FirebaseEnv.appIdAndroid;

  static const String apiKeyIos = _FirebaseEnv.apiKeyIos;
  static const String appIdIos = _FirebaseEnv.appIdIos;
}
