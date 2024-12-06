// contact.dart

class Contact {
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String website; // New field
  final String whatsappNumber; // New field

  Contact({
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.website,
    required this.whatsappNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'website': website,
      'whatsappNumber': whatsappNumber,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      countryCode: map['countryCode'] ?? '',
      website: map['website'] ?? '',
      whatsappNumber: map['whatsappNumber'] ?? '',
    );
  }
}
