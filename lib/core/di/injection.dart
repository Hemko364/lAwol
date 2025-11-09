import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../../data/firebase/auth_service.dart';

final getIt = GetIt.instance;

void setupInjection() {
  // Firebase Auth
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Firebase Analytics
  getIt.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);

  // Secure Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  // Auth Service
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService(
        getIt<FirebaseAuth>(),
        getIt<FirebaseAnalytics>(),
      ));
}
