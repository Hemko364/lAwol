class Fitment {
  final String id;
  final String cpnId;
  final String make;
  final String vehicleTrimId;
  final int? yearFrom;
  final int? yearTo;
  final double confidenceScore;

  Fitment({
    required this.id,
    required this.cpnId,
    required this.make,
    required this.vehicleTrimId,
    this.yearFrom,
    this.yearTo,
    required this.confidenceScore,
  });

  factory Fitment.fromJson(Map<String, dynamic> json) {
    return Fitment(
      id: json['id'] as String,
      cpnId: json['cpn_id'] as String,
      make: json['make'] as String? ?? '',
      vehicleTrimId: json['vehicle_trim_id'] as String,
      yearFrom: json['year_from'] as int?,
      yearTo: json['year_to'] as int?,
      confidenceScore: (json['confidence_score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cpn_id': cpnId,
      'make': make,
      'vehicle_trim_id': vehicleTrimId,
      'year_from': yearFrom,
      'year_to': yearTo,
      'confidence_score': confidenceScore,
    };
  }
}
