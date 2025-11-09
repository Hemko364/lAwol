import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'firebase_env.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: FirebaseEnv.apiKeyWeb,
        appId: FirebaseEnv.appIdWeb,
        messagingSenderId: FirebaseEnv.messagingSenderId,
        projectId: FirebaseEnv.projectId,
        authDomain: FirebaseEnv.authDomain,
        storageBucket: FirebaseEnv.storageBucket,
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: FirebaseEnv.apiKeyAndroid,
        appId: FirebaseEnv.appIdAndroid,
        messagingSenderId: FirebaseEnv.messagingSenderId,
        projectId: FirebaseEnv.projectId,
        storageBucket: FirebaseEnv.storageBucket,
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: FirebaseEnv.apiKeyIos,
        appId: FirebaseEnv.appIdIos,
        messagingSenderId: FirebaseEnv.messagingSenderId,
        projectId: FirebaseEnv.projectId,
        storageBucket: FirebaseEnv.storageBucket,
      );
}
