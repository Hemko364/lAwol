import 'package:flutter_test/flutter_test.dart';
import 'package:lawol/domain/models/normalization_layer.dart';
import 'package:lawol/domain/models/part_search_query.dart';

void main() {
  group('NormalizationLayer', () {
    test('normalize should clean strings and capitalize make/model', () {
      final raw = PartSearchQuery(
        partName: '  Alternateur   auto  ',
        oemNumber: ' 123-456 ABC ',
        carMake: 'toyota',
        carModel: 'YARIS',
        confidence: 0.9,
      );

      final result = NormalizationLayer.normalize(raw);

      expect(result.partName, 'Alternateur auto');
      expect(result.oemNumber, '123456ABC');
      expect(result.carMake, 'Toyota');
      expect(result.carModel, 'Yaris');
    });

    test('normalize should handle null values correctly', () {
      final raw = PartSearchQuery(partName: 'Batterie', confidence: 0.5);

      final result = NormalizationLayer.normalize(raw);

      expect(result.oemNumber, isNull);
      expect(result.carMake, isNull);
      expect(result.carModel, isNull);
    });

    test('_cleanOemNumber should return null if empty after cleaning', () {
      final raw = PartSearchQuery(
        partName: 'Test',
        oemNumber: '  -  ',
        confidence: 1.0,
      );

      final result = NormalizationLayer.normalize(raw);
      expect(result.oemNumber, isNull);
    });
  });
}
