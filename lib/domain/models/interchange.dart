class Interchange {
  final String id;
  final String cpnId;
  final String mpnSource;
  final String mpnEquivalent;
  final String status;
  final double confidenceScore;

  Interchange({
    required this.id,
    required this.cpnId,
    required this.mpnSource,
    required this.mpnEquivalent,
    required this.status,
    required this.confidenceScore,
  });

  factory Interchange.fromJson(Map<String, dynamic> json) {
    return Interchange(
      id: json['id'] as String,
      cpnId: json['cpn_id'] as String,
      mpnSource: json['mpn_source'] as String,
      mpnEquivalent: json['mpn_equivalent'] as String,
      status: json['status'] as String,
      confidenceScore: (json['confidence_score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cpn_id': cpnId,
      'mpn_source': mpnSource,
      'mpn_equivalent': mpnEquivalent,
      'status': status,
      'confidence_score': confidenceScore,
    };
  }
}
