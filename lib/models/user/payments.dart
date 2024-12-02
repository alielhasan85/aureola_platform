import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String paymentId;
  final DateTime date;
  final double amount;
  // Add other necessary fields

  Payment({
    required this.paymentId,
    required this.date,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'date': Timestamp.fromDate(date),
      'amount': amount,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentId: map['paymentId'] ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
