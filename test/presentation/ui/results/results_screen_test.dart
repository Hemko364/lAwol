import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/domain/models/part_search_query.dart';
import 'package:lawol/presentation/ui/results/results_screen.dart';

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

    testWidgets('should display all query information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResultsScreen(searchQuery: mockQuery),
        ),
      );

      expect(find.text('Alternateur'), findsOneWidget);
      expect(find.text('Moteur'), findsOneWidget);
      expect(find.text('Bosch'), findsOneWidget);
      expect(find.text('123456'), findsOneWidget);
      expect(find.text('Toyota'), findsOneWidget);
      expect(find.text('Yaris'), findsOneWidget);
      expect(find.text('95.0% de confiance'), findsOneWidget);
    });

    testWidgets('should display orange color for low confidence', (WidgetTester tester) async {
      final lowConfidenceQuery = PartSearchQuery(
        partName: 'Test',
        confidence: 0.5,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ResultsScreen(searchQuery: lowConfidenceQuery),
        ),
      );

      final text = tester.widget<Text>(find.text('50.0% de confiance'));
      expect(text.style?.color, Colors.orange);
    });
  });
}
