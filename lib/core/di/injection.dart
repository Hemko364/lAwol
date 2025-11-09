import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../data/firebase/auth_service.dart';

final getIt = GetIt.instance;

void setupInjection() {
  // Firebase Auth
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Secure Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());

  // Auth Service
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService(
        getIt<FirebaseAuth>(),
      ));
}
