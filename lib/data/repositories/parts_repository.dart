import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/canonical_part.dart';
import '../../domain/models/part_variant.dart';
import '../../domain/models/fitment.dart';
import '../../domain/models/interchange.dart';

class PartsRepository {
  final FirebaseFirestore _firestore;

  PartsRepository(this._firestore);

  // Canonical Parts
  Future<CanonicalPart?> getCanonicalPart(String cpn) async {
    final doc = await _firestore.collection('parts_canonical').doc(cpn).get();
    if (!doc.exists) return null;
    return CanonicalPart.fromJson(doc.data()!);
  }

  // Part Variants
  Future<List<PartVariant>> getVariantsForCPN(String cpnId) async {
    final snapshot = await _firestore
        .collection('parts_variant')
        .where('cpn_id', isEqualTo: cpnId)
        .get();
    return snapshot.docs
        .map((doc) => PartVariant.fromJson(doc.data()))
        .toList();
  }

  Future<PartVariant?> getVariantByMPN(String mpn) async {
    final doc = await _firestore.collection('parts_variant').doc(mpn).get();
    if (!doc.exists) return null;
    return PartVariant.fromJson(doc.data()!);
  }

  // Fitment
  Future<List<Fitment>> getFitmentForCPN(String cpnId) async {
    final snapshot = await _firestore
        .collection('fitment')
        .where('cpn_id', isEqualTo: cpnId)
        .get();
    return snapshot.docs.map((doc) => Fitment.fromJson(doc.data())).toList();
  }

  // Interchange
  Future<List<Interchange>> getInterchanges(String cpnId) async {
    final snapshot = await _firestore
        .collection('interchange')
        .where('cpn_id', isEqualTo: cpnId)
        .get();
    return snapshot.docs
        .map((doc) => Interchange.fromJson(doc.data()))
        .toList();
  }

  // Search by OEM Reference
  Future<List<PartVariant>> searchByOEM(String oemRef) async {
    final snapshot = await _firestore
        .collection('parts_variant')
        .where('oem_reference', isEqualTo: oemRef)
        .get();
    return snapshot.docs
        .map((doc) => PartVariant.fromJson(doc.data()))
        .toList();
  }
}
