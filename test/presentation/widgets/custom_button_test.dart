import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/presentation/widgets/custom_button.dart';

void main() {
  group('CustomButton', () {
    testWidgets('should display text and call onPressed', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Click Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.byType(CustomButton));
      expect(pressed, isTrue);
    });

    testWidgets('should respect custom colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Colored',
              onPressed: () {},
              backgroundColor: Colors.red,
              textColor: Colors.blue,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}), Colors.red);
      expect(button.style?.foregroundColor?.resolve({}), Colors.blue);
    });
  });
}
