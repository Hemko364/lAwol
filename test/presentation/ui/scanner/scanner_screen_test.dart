import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lawol/presentation/ui/scanner/scanner_screen.dart';
import 'package:lawol/data/services/gemini_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawol/core/providers/providers.dart';

class MockGeminiService extends Mock implements GeminiService {}

void main() {
  late MockGeminiService mockGeminiService;

  setUp(() {
    mockGeminiService = MockGeminiService();
  });

  group('ScannerScreen', () {
    testWidgets('should display scan buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            geminiServiceProvider.overrideWithValue(mockGeminiService),
          ],
          child: const MaterialApp(home: ScannerScreen()),
        ),
      );

      expect(find.text('Scanner une pièce'), findsOneWidget);
      expect(find.text('Prendre une photo'), findsOneWidget);
      expect(find.text('Importer une photo'), findsOneWidget);
    });

    testWidgets('should show loading indicator when analyzing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            geminiServiceProvider.overrideWithValue(mockGeminiService),
          ],
          child: const MaterialApp(home: ScannerScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
