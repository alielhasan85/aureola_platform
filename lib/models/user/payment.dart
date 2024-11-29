// payment.dart

class Payment {
  final DateTime date;
  final double amount;
  final String method;
  final String transactionId;

  Payment({
    required this.date,
    required this.amount,
    required this.method,
    required this.transactionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
      'method': method,
      'transactionId': transactionId,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      date: DateTime.parse(map['date']),
      amount: map['amount']?.toDouble() ?? 0.0,
      method: map['method'] ?? '',
      transactionId: map['transactionId'] ?? '',
    );
  }
}
