import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  final String type; // e.g., 'free', 'basic', 'premium'
  final List<String> featuresEnabled;
  final DateTime startDate;
  final DateTime endDate;

  Subscription({
    required this.type,
    this.featuresEnabled = const [],
    required this.startDate,
    required this.endDate,
  });

  // The copyWith method
  Subscription copyWith({
    String? type,
    List<String>? featuresEnabled,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Subscription(
      type: type ?? this.type,
      featuresEnabled: featuresEnabled ?? this.featuresEnabled,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'featuresEnabled': featuresEnabled,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      type: map['type'] ?? 'free',
      featuresEnabled: List<String>.from(map['featuresEnabled'] ?? []),
      startDate: (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (map['endDate'] as Timestamp?)?.toDate() ??
          DateTime.now().add(Duration(days: 30)),
    );
  }
}
