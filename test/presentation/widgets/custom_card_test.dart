import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/presentation/widgets/custom_card.dart';

void main() {
  group('CustomCard', () {
    testWidgets('should display child and handle onTap', (
      WidgetTester tester,
    ) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomCard(
              onTap: () => tapped = true,
              child: const Text('Inside Card'),
            ),
          ),
        ),
      );

      expect(find.text('Inside Card'), findsOneWidget);
      await tester.tap(find.byType(CustomCard));
      expect(tapped, isTrue);
    });

    testWidgets('should have correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomCard(
              color: Colors.green,
              elevation: 10,
              child: SizedBox(),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, Colors.green);
      expect(card.elevation, 10);
    });
  });
}
