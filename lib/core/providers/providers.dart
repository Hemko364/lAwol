import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lawol/data/firebase/auth_service.dart';
import 'package:lawol/data/services/gemini_service.dart';
import 'package:lawol/data/repositories/parts_repository.dart';
import 'package:lawol/domain/models/canonical_part.dart';
import 'package:lawol/domain/models/part_variant.dart';
import 'package:lawol/domain/models/interchange.dart';

// Firebase Providers
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseAnalyticsProvider = Provider<FirebaseAnalytics>((ref) {
  return FirebaseAnalytics.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Storage Providers
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// Repository Providers
final partsRepositoryProvider = Provider<PartsRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return PartsRepository(firestore);
});

/// Provider pour récupérer une pièce canonique par son ID (CPN)
final canonicalPartProvider = FutureProvider.family<CanonicalPart?, String>((
  ref,
  cpnId,
) {
  return ref.watch(partsRepositoryProvider).getCanonicalPart(cpnId);
});

/// Provider pour récupérer les variantes d'une pièce canonique
final partVariantsProvider = FutureProvider.family<List<PartVariant>, String>((
  ref,
  cpnId,
) {
  return ref.watch(partsRepositoryProvider).getVariantsForCPN(cpnId);
});

/// Provider pour récupérer les équivalences d'une pièce
final interchangesProvider = FutureProvider.family<List<Interchange>, String>((
  ref,
  cpnId,
) {
  return ref.watch(partsRepositoryProvider).getInterchanges(cpnId);
});

/// Provider pour rechercher des variantes par référence OEM
final oemSearchProvider = FutureProvider.family<List<PartVariant>, String>((
  ref,
  oemRef,
) {
  return ref.watch(partsRepositoryProvider).searchByOEM(oemRef);
});

// Service Providers
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

final authServiceProvider = Provider<FirebaseAuthService>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final analytics = ref.watch(firebaseAnalyticsProvider);
  return FirebaseAuthService(auth, analytics);
});

// Auth State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
