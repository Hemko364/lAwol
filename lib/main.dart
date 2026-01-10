import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
// import 'presentation/ui/login_screen/login_screen.dart';
import 'presentation/ui/main_screen.dart';
import 'core/theme/app_theme.dart';
import 'package:lawol/core/providers/providers.dart';
import 'presentation/ui/login_screen/login_screen.dart';
import 'data/firebase/firestore_seeder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialisation des données de test en mode debug si nécessaire
    if (kDebugMode) {
      final seeder = FirestoreSeeder(FirebaseFirestore.instance);
      await seeder
          .seedTestData(); // À décommenter une seule fois pour peupler la DB
    }
  } catch (e) {
    // Firebase initialization failed
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'lAwôl',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: authState.when(
        data: (user) => user != null ? const MainScreen() : const LoginScreen(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) => const Scaffold(
          body: Center(child: Text('Erreur d\'authentification')),
        ),
      ),
    );
  }
}
