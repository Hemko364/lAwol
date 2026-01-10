import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/presentation/ui/profile/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawol/core/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

void main() {
  group('ProfileScreen', () {
    testWidgets('should display user info and menu items', (
      WidgetTester tester,
    ) async {
      final mockUser = MockUser();
      when(() => mockUser.email).thenReturn('test@example.com');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(mockUser)),
          ],
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );

      // Wait for the stream to emit
      await tester.pumpAndSettle();

      expect(find.text('Compte'), findsOneWidget);
      expect(find.text('Informations personnelles'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text('Déconnexion'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });
  });
}
