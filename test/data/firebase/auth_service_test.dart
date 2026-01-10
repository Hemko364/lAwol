import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:lawol/data/firebase/auth_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseAnalytics mockAnalytics;
  late FirebaseAuthService authService;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockAnalytics = MockFirebaseAnalytics();
    authService = FirebaseAuthService(mockAuth, mockAnalytics);
  });

  group('FirebaseAuthService', () {
    test('currentUser should return the user from FirebaseAuth', () {
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      expect(authService.currentUser, mockUser);
      verify(() => mockAuth.currentUser).called(1);
    });

    test('authStateChanges should return the stream from FirebaseAuth', () {
      final mockStream = Stream<User?>.fromIterable([null]);
      when(() => mockAuth.authStateChanges()).thenAnswer((_) => mockStream);

      expect(authService.authStateChanges, mockStream);
      verify(() => mockAuth.authStateChanges()).called(1);
    });

    test('signInWithEmailAndPassword should call firebase auth and analytics', () async {
      final mockUserCredential = MockUserCredential();
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockUserCredential);
      when(() => mockAnalytics.logLogin(loginMethod: 'email'))
          .thenAnswer((_) async => {});

      final result = await authService.signInWithEmailAndPassword(
        'test@example.com',
        'password123',
      );

      expect(result, mockUserCredential);
      verify(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).called(1);
      verify(() => mockAnalytics.logLogin(loginMethod: 'email')).called(1);
    });
  });
}
