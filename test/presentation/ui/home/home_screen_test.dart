import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/presentation/ui/home/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawol/core/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lawol/presentation/ui/categories/categories_screen.dart';

class MockUser extends Mock implements User {}

void main() {
  group('HomeScreen', () {
    testWidgets('should display header and quick actions', (
      WidgetTester tester,
    ) async {
      final mockUser = MockUser();
      when(() => mockUser.email).thenReturn('test@example.com');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(mockUser)),
          ],
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Bonjour,'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Actions rapides'), findsOneWidget);
      expect(find.text('Pièces populaires'), findsOneWidget);
    });

    testWidgets('should show popular parts list', (WidgetTester tester) async {
      final mockUser = MockUser();
      when(() => mockUser.email).thenReturn('test@example.com');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(mockUser)),
          ],
          child: const MaterialApp(home: HomeScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Plaquettes de frein'), findsOneWidget);
      expect(find.text('Filtre à huile'), findsOneWidget);
      expect(find.text('Batterie 12V 70Ah'), findsOneWidget);
    });

    testWidgets('should navigate to CategoriesScreen when "Par catégorie" is tapped', (
      WidgetTester tester,
    ) async {
      final mockUser = MockUser();
      when(() => mockUser.email).thenReturn('test@example.com');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authStateProvider.overrideWith((ref) => Stream.value(mockUser)),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on "Par catégorie"
      await tester.tap(find.text('Par\ncatégorie'));
      await tester.pumpAndSettle();

      // Verify that CategoriesScreen is displayed
      expect(find.byType(CategoriesScreen), findsOneWidget);
      expect(find.text('Catégories de pièces'), findsOneWidget);
    });
  });
}
