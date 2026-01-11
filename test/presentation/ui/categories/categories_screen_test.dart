import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/presentation/ui/categories/categories_screen.dart';

void main() {
  group('CategoriesScreen', () {
    testWidgets('should display categories screen with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CategoriesScreen(),
        ),
      );

      expect(find.text('Catégories de pièces'), findsOneWidget);
    });

    testWidgets('should display major category names', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CategoriesScreen(),
        ),
      );

      expect(find.text('Freinage'), findsOneWidget);
      expect(find.text('Moteur'), findsOneWidget);
      expect(find.text('Suspension'), findsOneWidget);
      expect(find.text('Électricité'), findsOneWidget);
    });

    testWidgets('should show snackbar when category is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CategoriesScreen(),
        ),
      );

      await tester.tap(find.text('Freinage'));
      await tester.pump(); // Start animation

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Filtrer par : Freinage'), findsOneWidget);
    });
  });
}
