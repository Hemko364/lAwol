class CanonicalPart {
  final String id; // CPN
  final String label;
  final String category;
  final String family;
  final String criticality;

  CanonicalPart({
    required this.id,
    required this.label,
    required this.category,
    required this.family,
    required this.criticality,
  });

  factory CanonicalPart.fromJson(Map<String, dynamic> json) {
    return CanonicalPart(
      id: json['id'] as String,
      label: json['label'] as String,
      category: json['category'] as String,
      family: json['family'] as String,
      criticality: json['criticality'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'category': category,
      'family': family,
      'criticality': criticality,
    };
  }
}
