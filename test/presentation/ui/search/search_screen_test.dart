import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/presentation/ui/search/search_screen.dart';

void main() {
  group('SearchScreen', () {
    testWidgets('should display search bar and filter chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchScreen(),
        ),
      );

      expect(find.text('Recherche de pièces'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('VIN (17 car.) ou Code OEM...'), findsOneWidget);
      expect(find.text('Freinage'), findsOneWidget);
      expect(find.text('Moteur'), findsOneWidget);
    });

    testWidgets('should show results list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchScreen(),
        ),
      );

      expect(find.text('3 résultats'), findsOneWidget);
      expect(find.text('Plaquettes de frein avant'), findsOneWidget);
      expect(find.text('Bosch • BP1234'), findsOneWidget);
    });
  });
}
