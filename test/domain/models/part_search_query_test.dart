import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/domain/models/part_search_query.dart';

void main() {
  group('PartSearchQuery', () {
    test('fromJson should create a valid object with all fields', () {
      final json = {
        'part_name': 'Alternateur',
        'category': 'Électricité',
        'manufacturer': 'Bosch',
        'oem_number': '123456',
        'car_make': 'Toyota',
        'car_model': 'Yaris',
        'year': 2020,
        'confidence': 0.95,
      };

      final query = PartSearchQuery.fromJson(json);

      expect(query.partName, 'Alternateur');
      expect(query.category, 'Électricité');
      expect(query.manufacturer, 'Bosch');
      expect(query.oemNumber, '123456');
      expect(query.carMake, 'Toyota');
      expect(query.carModel, 'Yaris');
      expect(query.year, 2020);
      expect(query.confidence, 0.95);
    });

    test('fromJson should use default values for missing fields', () {
      final json = <String, dynamic>{};

      final query = PartSearchQuery.fromJson(json);

      expect(query.partName, 'Pièce non identifiée');
      expect(query.confidence, 0.0);
      expect(query.category, isNull);
    });

    test('toJson should return a valid map', () {
      final query = PartSearchQuery(
        partName: 'Batterie',
        category: 'Énergie',
        confidence: 0.8,
      );

      final json = query.toJson();

      expect(json['part_name'], 'Batterie');
      expect(json['category'], 'Énergie');
      expect(json['confidence'], 0.8);
      expect(json['oem_number'], isNull);
    });
  });
}
