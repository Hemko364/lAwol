import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawol/domain/models/part_search_query.dart';
import 'package:lawol/domain/models/part_variant.dart';
import 'package:lawol/presentation/ui/results/results_screen.dart';
import 'package:lawol/core/providers/providers.dart';
import 'package:lawol/data/services/price_service.dart';

import 'package:lawol/domain/models/fitment.dart';
import 'package:lawol/domain/models/canonical_part.dart';

void main() {
  group('ResultsScreen', () {
    final mockQuery = PartSearchQuery(
      partName: 'Plaquettes de frein',
      category: 'Freinage',
      manufacturer: 'Brembo',
      oemNumber: '123456',
      carMake: 'VW',
      confidence: 0.95,
    );

    final mockVariant = PartVariant(
      mpn: 'BP1234',
      cpnId: 'CPN001',
      brand: 'Brembo',
      supplier: 'Oscaro',
      oemReference: '123456',
      interchangeType: 'exact',
      confidenceScore: 0.99,
    );

    final mockPrice = PriceInfo(
      amount: 45.90,
      currency: '€',
      partnerName: 'Oscaro',
    );

    final mockFitment = Fitment(
      id: 'F1',
      cpnId: 'CPN001',
      make: 'VW',
      vehicleTrimId: 'Golf VI 2.0 TDI',
      yearFrom: 2008,
      yearTo: 2013,
      confidenceScore: 1.0,
    );

    final mockCPN = CanonicalPart(
      id: 'CPN001',
      label: 'Plaquettes de frein avant',
      category: 'Freinage',
      family: 'Plaquettes',
      criticality: 'High',
    );

    testWidgets('should display all query information and variants with price', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            oemSearchProvider('123456').overrideWith((ref) => [mockVariant]),
            bestPriceProvider('BP1234').overrideWith((ref) => mockPrice),
            canonicalPartProvider('CPN001').overrideWith((ref) => mockCPN),
            fitmentProvider('CPN001').overrideWith((ref) => [mockFitment]),
          ],
          child: MaterialApp(home: ResultsScreen(searchQuery: mockQuery)),
        ),
      );

      await tester.pump();

      expect(find.text('Plaquettes de frein'), findsOneWidget);
      expect(find.text('FREINAGE'), findsOneWidget);
      expect(find.text('Confiance : 95%'), findsOneWidget);

      // Vérifier la variante
      expect(find.text('1 Équivalents trouvés'), findsOneWidget);
      expect(find.text('45.90 €'), findsOneWidget);

      // Vérifier la section Compatibilité (Graphique)
      expect(find.text('Compatibilité Véhicules'), findsOneWidget);
      expect(find.text('1 modèles'), findsOneWidget); // Badge de comptage
      expect(find.text('Golf VI 2.0 TDI'), findsOneWidget);

      // Vérifier le sous-titre "VW" dans la section compatibilité spécifiquement
      final fitmentSectionFinder = find
          .ancestor(
            of: find.text('Golf VI 2.0 TDI'),
            matching: find.byType(Container),
          )
          .first;
      expect(
        find.descendant(of: fitmentSectionFinder, matching: find.text('VW')),
        findsOneWidget,
      );

      expect(find.text('2008 - 2013'), findsOneWidget); // Années

      // Vérifier le "Logo" (CircleAvatar avec 'V')
      final avatarFinder = find.descendant(
        of: find.byType(CircleAvatar),
        matching: find.text('V'),
      );
      expect(avatarFinder, findsOneWidget);

      // Vérifier la couleur du logo VW (Bleu nuit : 0xFF001E50)
      final CircleAvatar avatar = tester.widget(
        find.byType(CircleAvatar).first,
      );
      expect((avatar.child as Text).style?.color, const Color(0xFF001E50));

      // Vérifier le schéma technique
      expect(find.text('Schéma Technique'), findsOneWidget);
      expect(
        find.text('Schéma pour : Plaquettes de frein avant'),
        findsOneWidget,
      );
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
