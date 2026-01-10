import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lawol/domain/models/canonical_part.dart';
import 'package:lawol/domain/models/part_variant.dart';
import 'package:lawol/domain/models/partner_product.dart';

class FirestoreSeeder {
  final FirebaseFirestore _firestore;

  FirestoreSeeder(this._firestore);

  Future<void> seedTestData() async {
    print('Starting Firestore seeding...');

    // 1. Seed Canonical Parts (CPN)
    final cpn1 = CanonicalPart(
      id: 'CPN_BRAKE_PADS_VW_001',
      label: 'Plaquettes de frein avant',
      category: 'Freinage',
      family: 'Plaquettes',
      criticality: 'High',
    );

    final cpn2 = CanonicalPart(
      id: 'CPN_OIL_FILTER_TOY_001',
      label: 'Filtre à huile',
      category: 'Entretien',
      family: 'Filtres',
      criticality: 'Medium',
    );

    await _firestore
        .collection('parts_canonical')
        .doc(cpn1.id)
        .set(cpn1.toJson());
    await _firestore
        .collection('parts_canonical')
        .doc(cpn2.id)
        .set(cpn2.toJson());

    // 2. Seed Part Variants
    final variants = [
      PartVariant(
        mpn: 'BP1234',
        cpnId: 'CPN_BRAKE_PADS_VW_001',
        brand: 'Brembo',
        supplier: 'Oscaro',
        oemReference: '123456',
        interchangeType: 'exact',
        confidenceScore: 0.99,
      ),
      PartVariant(
        mpn: '0986494019',
        cpnId: 'CPN_BRAKE_PADS_VW_001',
        brand: 'Bosch',
        supplier: 'MisterAuto',
        oemReference: '123456',
        interchangeType: 'equivalent',
        confidenceScore: 0.95,
      ),
      PartVariant(
        mpn: 'P85020',
        cpnId: 'CPN_BRAKE_PADS_VW_001',
        brand: 'Brembo',
        supplier: 'AutoParts',
        oemReference: '123456',
        interchangeType: 'exact',
        confidenceScore: 0.98,
      ),
      PartVariant(
        mpn: 'HU711/51X',
        cpnId: 'CPN_OIL_FILTER_TOY_001',
        brand: 'Mann-Filter',
        supplier: 'Oscaro',
        oemReference: '90915-YZZD4',
        interchangeType: 'exact',
        confidenceScore: 0.99,
      ),
    ];

    for (var variant in variants) {
      await _firestore
          .collection('parts_variant')
          .doc(variant.mpn)
          .set(variant.toJson());
    }

    // 3. Seed Partner Products (for Prices)
    final partnerProducts = [
      PartnerProduct(
        mpn: 'BP1234',
        partnerId: 'PARTNER_OSCARO',
        productUrl: 'https://www.oscaro.com/p/BP1234',
      ),
      PartnerProduct(
        mpn: '0986494019',
        partnerId: 'PARTNER_MISTER_AUTO',
        productUrl: 'https://www.mister-auto.com/p/0986494019',
      ),
    ];

    for (var product in partnerProducts) {
      await _firestore
          .collection('partner_products')
          .doc('${product.partnerId}_${product.mpn}')
          .set(product.toJson());
    }

    print('Firestore seeding completed successfully.');
  }
}
