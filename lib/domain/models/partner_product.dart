class PartnerProduct {
  final String mpn;
  final String partnerId;
  final String productUrl;

  PartnerProduct({
    required this.mpn,
    required this.partnerId,
    required this.productUrl,
  });

  factory PartnerProduct.fromJson(Map<String, dynamic> json) {
    return PartnerProduct(
      mpn: json['mpn'] as String,
      partnerId: json['partner_id'] as String,
      productUrl: json['product_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'mpn': mpn, 'partner_id': partnerId, 'product_url': productUrl};
  }
}
