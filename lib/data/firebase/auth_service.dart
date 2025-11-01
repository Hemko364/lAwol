import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Configuration Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '613558748519-8igm3bh1noru7f4mgdpien4e359g1jh4.apps.googleusercontent.com'
        : null,
    scopes: ['email', 'profile'],
  );

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email and password
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      print('🔍 Début de Google Sign-In...');

      if (kIsWeb) {
        // Sur le web, utilise Firebase Auth directement avec Google Provider
        print('🔍 Web: Utilisation de Firebase Auth avec Google Provider...');
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        return await _auth.signInWithPopup(googleProvider);
      } else {
        // Sur mobile, utilise Google Sign-In normalement
        print('🔍 Mobile: Connexion Google normale...');
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          print('❌ Utilisateur a annulé la connexion Google');
          throw FirebaseAuthException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
        }

        print('✅ Utilisateur Google obtenu: ${googleUser.email}');
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        print(
          '🔍 Tokens obtenus - AccessToken: ${googleAuth.accessToken != null}, IdToken: ${googleAuth.idToken != null}',
        );

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        print('🔍 Credential créé, connexion à Firebase...');
        final result = await _auth.signInWithCredential(credential);
        print('✅ Connexion Firebase réussie: ${result.user?.email}');

        return result;
      }
    } catch (e) {
      print('❌ Erreur Google Sign-In: $e');
      rethrow;
    }
  }

  // Sign in with Apple
  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return await _auth.signInWithCredential(oauthCredential);
  }

  // Sign out
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }
}
