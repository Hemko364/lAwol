import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lawol/presentation/ui/login_screen/login_screen.dart';
import 'package:lawol/data/firebase/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawol/core/providers/providers.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

void main() {
  late MockFirebaseAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockFirebaseAuthService();
  });

  group('LoginScreen', () {
    testWidgets('should display login fields and buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authServiceProvider.overrideWithValue(mockAuthService)],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Apple'), findsOneWidget);
    });
  });
}
