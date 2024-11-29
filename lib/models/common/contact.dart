// contact.dart

class Contact {
  final String email;
  final String phoneNumber;
  final String countryCode;

  Contact({
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      countryCode: map['countryCode'] ?? '',
    );
  }
}
