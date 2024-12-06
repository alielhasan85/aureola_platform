// contact.dart

class Contact {
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String website;
  final String whatsappNumber;

  Contact({
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    this.website = '',
    this.whatsappNumber = '',
  });

  Contact copyWith({
    String? email,
    String? phoneNumber,
    String? countryCode,
    String? website,
    String? whatsappNumber,
  }) {
    return Contact(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      website: website ?? this.website,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
    );
  }

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
