class Partner {
  final String id;
  final String name;
  final String country;
  final String affiliateType;

  Partner({
    required this.id,
    required this.name,
    required this.country,
    required this.affiliateType,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      affiliateType: json['affiliate_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'affiliate_type': affiliateType,
    };
  }
}
