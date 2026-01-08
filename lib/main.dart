import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
// import 'presentation/ui/login_screen/login_screen.dart';
import 'presentation/ui/main_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection.dart';
// import 'core/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Activation d'App Check pour sécuriser les appels API (notamment Vertex AI)
    await FirebaseAppCheck.instance.activate(
      // ignore: deprecated_member_use
      androidProvider: AndroidProvider.debug,
      // ignore: deprecated_member_use
      appleProvider: AppleProvider.debug,
    );
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  setupInjection();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'lAwôl',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
      /* home: authState.when(
        data: (user) => user != null ? const MainScreen() : const LoginScreen(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => const Scaffold(
          body: Center(child: Text('Erreur d\'authentification')),
        ),
      ), */
    );
  }
}
