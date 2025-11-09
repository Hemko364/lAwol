import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB_g3IUod_fTYtWeOnu_lSE-V81cn8GV5w',
    appId: '1:613558748519:web:fe915e85b5a3d228dc9bc2',
    messagingSenderId: '613558748519',
    projectId: 'lawol-e2e60',
    authDomain: 'lawol-e2e60.firebaseapp.com',
    storageBucket: 'lawol-e2e60.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqETRguwdAo1HAOW9NCdm9YXX0wrrOC9g',
    appId: '1:613558748519:android:fe915e85b5a3d228dc9bc2',
    messagingSenderId: '613558748519',
    projectId: 'lawol-e2e60',
    storageBucket: 'lawol-e2e60.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_g3IUod_fTYtWeOnu_lSE-V81cn8GV5w',
    appId: '1:613558748519:ios:fe915e85b5a3d228dc9bc2',
    messagingSenderId: '613558748519',
    projectId: 'lawol-e2e60',
    storageBucket: 'lawol-e2e60.firebasestorage.app',
  );
}
