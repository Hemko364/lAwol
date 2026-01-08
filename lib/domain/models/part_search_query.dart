class PartSearchQuery {
  final String? oemNumber;
  final String partName;
  final String? carMake;
  final String? carModel;
  final int? year;
  final double confidence;

  PartSearchQuery({
    required this.partName,
    this.oemNumber,
    this.carMake,
    this.carModel,
    this.year,
    required this.confidence,
  });

  factory PartSearchQuery.fromJson(Map<String, dynamic> json) {
    return PartSearchQuery(
      partName: json['part_name'] as String? ?? 'Inconnu',
      oemNumber: json['oem_number'] as String?,
      carMake: json['car_make'] as String?,
      carModel: json['car_model'] as String?,
      year: json['year'] as int?,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'part_name': partName,
      'oem_number': oemNumber,
      'car_make': carMake,
      'car_model': carModel,
      'year': year,
      'confidence': confidence,
    };
  }
}
