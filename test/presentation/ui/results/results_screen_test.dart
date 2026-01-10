import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawol/domain/models/part_search_query.dart';
import 'package:lawol/domain/models/part_variant.dart';
import 'package:lawol/presentation/ui/results/results_screen.dart';
import 'package:lawol/core/providers/providers.dart';

void main() {
  group('ResultsScreen', () {
    final mockQuery = PartSearchQuery(
      partName: 'Alternateur',
      category: 'Moteur',
      manufacturer: 'Bosch',
      oemNumber: '123456',
      carMake: 'Toyota',
      carModel: 'Yaris',
      year: 2020,
      confidence: 0.95,
    );

    final mockVariant = PartVariant(
      mpn: 'BP1234',
      cpnId: 'CPN001',
      brand: 'Brembo',
      supplier: 'AutoParts',
      oemReference: '123456',
      interchangeType: 'exact',
      confidenceScore: 0.99,
    );

    testWidgets('should display all query information and variants', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            oemSearchProvider('123456').overrideWith((ref) => [mockVariant]),
          ],
          child: MaterialApp(home: ResultsScreen(searchQuery: mockQuery)),
        ),
      );

      await tester.pump(); // Déclencher le chargement du FutureProvider

      expect(find.text('Alternateur'), findsOneWidget);
      expect(find.text('MOTEUR'), findsOneWidget);
      expect(find.text('Bosch'), findsOneWidget);
      expect(find.text('123456'), findsOneWidget);
      expect(find.text('Confiance : 95%'), findsOneWidget);

      // Vérifier la variante
      expect(find.text('1 Équivalents trouvés'), findsOneWidget);
      expect(find.text('Brembo'), findsOneWidget);
      expect(find.text('AutoParts • BP1234'), findsOneWidget);
    });

    testWidgets('should display low confidence', (WidgetTester tester) async {
      final lowConfidenceQuery = PartSearchQuery(
        partName: 'Test',
        confidence: 0.5,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ResultsScreen(searchQuery: lowConfidenceQuery),
          ),
        ),
      );

      expect(find.text('Confiance : 50%'), findsOneWidget);
    });
  });
}
