import 'package:cloud_firestore/cloud_firestore.dart';

class AffiliateClick {
  final String id;
  final String userSession;
  final String mpn;
  final String partnerId;
  final DateTime timestamp;

  AffiliateClick({
    required this.id,
    required this.userSession,
    required this.mpn,
    required this.partnerId,
    required this.timestamp,
  });

  factory AffiliateClick.fromJson(Map<String, dynamic> json) {
    return AffiliateClick(
      id: json['id'] as String,
      userSession: json['user_session'] as String,
      mpn: json['mpn'] as String,
      partnerId: json['partner_id'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_session': userSession,
      'mpn': mpn,
      'partner_id': partnerId,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
