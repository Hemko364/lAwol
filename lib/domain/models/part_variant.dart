class PartVariant {
  final String mpn;
  final String cpnId;
  final String brand;
  final String supplier;
  final String? oemReference;
  final String? eanGtin;
  final String interchangeType;
  final double confidenceScore;

  PartVariant({
    required this.mpn,
    required this.cpnId,
    required this.brand,
    required this.supplier,
    this.oemReference,
    this.eanGtin,
    required this.interchangeType,
    required this.confidenceScore,
  });

  factory PartVariant.fromJson(Map<String, dynamic> json) {
    return PartVariant(
      mpn: json['mpn'] as String,
      cpnId: json['cpn_id'] as String,
      brand: json['brand'] as String,
      supplier: json['supplier'] as String,
      oemReference: json['oem_reference'] as String?,
      eanGtin: json['ean_gtin'] as String?,
      interchangeType: json['interchange_type'] as String,
      confidenceScore: (json['confidence_score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mpn': mpn,
      'cpn_id': cpnId,
      'brand': brand,
      'supplier': supplier,
      'oem_reference': oemReference,
      'ean_gtin': eanGtin,
      'interchange_type': interchangeType,
      'confidence_score': confidenceScore,
    };
  }
}
