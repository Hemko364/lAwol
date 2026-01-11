import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lawol/presentation/ui/main_screen.dart';
import 'package:lawol/presentation/ui/home/home_screen.dart';
import 'package:lawol/presentation/ui/search/search_screen.dart';
import 'package:lawol/data/firebase/auth_service.dart';
import 'package:lawol/data/services/gemini_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawol/core/providers/providers.dart';

class MockGeminiService extends Mock implements GeminiService {}

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockUser extends Mock implements User {}

void main() {
  late MockGeminiService mockGeminiService;
  late MockFirebaseAuthService mockAuthService;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseAnalytics mockAnalytics;
  late MockFlutterSecureStorage mockStorage;

  setUpAll(() {
    registerFallbackValue(const Offset(0, 0));
  });

  setUp(() {
    mockGeminiService = MockGeminiService();
    mockAuthService = MockFirebaseAuthService();
    mockAuth = MockFirebaseAuth();
    mockAnalytics = MockFirebaseAnalytics();
    mockStorage = MockFlutterSecureStorage();

    // Setup default mock behaviors
    when(
      () => mockAuthService.authStateChanges,
    ).thenAnswer((_) => Stream.value(null));
  });

  Widget createMainScreen() {
    return ProviderScope(
      overrides: [
        geminiServiceProvider.overrideWithValue(mockGeminiService),
        authServiceProvider.overrideWithValue(mockAuthService),
        firebaseAuthProvider.overrideWithValue(mockAuth),
        firebaseAnalyticsProvider.overrideWithValue(mockAnalytics),
        secureStorageProvider.overrideWithValue(mockStorage),
      ],
      child: const MaterialApp(home: MainScreen()),
    );
  }

  group('MainScreen', () {
    testWidgets('should show HomeScreen by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createMainScreen());

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(SearchScreen, skipOffstage: false), findsOneWidget);
    });

    testWidgets('should navigate to SearchScreen when tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createMainScreen());

      // Use a more specific finder for the bottom navigation bar item
      final searchTab = find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(Icons.search),
      );

      await tester.tap(searchTab);
      await tester.pump();

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 1);
    });

    testWidgets('should navigate to ScannerScreen when center button tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createMainScreen());

      final scannerTab = find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(Icons.camera_alt_outlined),
      );

      await tester.tap(scannerTab);
      await tester.pump();

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 2);
    });

    testWidgets('should navigate to GarageScreen when tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createMainScreen());

      final garageTab = find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(Icons.directions_car_outlined),
      );

      await tester.tap(garageTab);
      await tester.pump();

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 3);
    });

    testWidgets('should navigate to ProfileScreen when tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createMainScreen());

      final profileTab = find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(Icons.person_outline),
      );

      await tester.tap(profileTab);
      await tester.pump();

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 4);
    });
  });
}
