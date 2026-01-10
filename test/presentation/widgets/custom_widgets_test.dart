import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/presentation/widgets/custom_appbar.dart';
import 'package:lawol/presentation/widgets/custom_search_bar.dart';

void main() {
  group('CustomAppBar', () {
    testWidgets('should display title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: CustomAppBar(title: 'Test Title')),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });
  });

  group('CustomSearchBar', () {
    testWidgets('should update controller and call onChanged', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      String changedValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomSearchBar(
              controller: controller,
              onChanged: (val) => changedValue = val,
              hintText: 'Search here',
            ),
          ),
        ),
      );

      expect(find.text('Search here'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Hello');
      expect(controller.text, 'Hello');
      expect(changedValue, 'Hello');
    });
  });
}
