import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/presentation/widgets/custom_bottom_nav.dart';

void main() {
  group('CustomBottomNavBar', () {
    testWidgets('should call onTap with correct index', (WidgetTester tester) async {
      int tappedIndex = -1;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Recherche'));
      expect(tappedIndex, 1);
      
      await tester.tap(find.text('Profil'));
      expect(tappedIndex, 2);
    });
  });
}
