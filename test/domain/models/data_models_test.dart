import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/domain/models/canonical_part.dart';
import 'package:lawol/domain/models/part_variant.dart';
import 'package:lawol/domain/models/fitment.dart';

void main() {
  group('Data Models', () {
    test('CanonicalPart JSON serialization', () {
      final json = {
        'id': 'ALT-001',
        'label': 'Alternateur',
        'category': 'Électricité',
        'family': 'Moteur',
        'criticality': 'High',
      };
      final part = CanonicalPart.fromJson(json);
      expect(part.id, 'ALT-001');
      expect(part.toJson(), json);
    });

    test('PartVariant JSON serialization', () {
      final json = {
        'mpn': 'BOSCH-123',
        'cpn_id': 'ALT-001',
        'brand': 'Bosch',
        'supplier': 'AutoDoc',
        'oem_reference': 'OEM-789',
        'ean_gtin': '1234567890123',
        'interchange_type': 'Direct',
        'confidence_score': 0.98,
      };
      final variant = PartVariant.fromJson(json);
      expect(variant.mpn, 'BOSCH-123');
      expect(variant.toJson(), json);
    });

    test('Fitment JSON serialization', () {
      final json = {
        'id': 'FIT-001',
        'cpn_id': 'ALT-001',
        'vehicle_trim_id': 'TOY-YAR-2020',
        'year_from': 2019,
        'year_to': 2021,
        'confidence_score': 1.0,
      };
      final fitment = Fitment.fromJson(json);
      expect(fitment.id, 'FIT-001');
      expect(fitment.toJson(), json);
    });
  });
}
