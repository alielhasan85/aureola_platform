// lib/models/common/contact.dart

class Contact {
  final String email;
  final String phoneNumber;
  final String countryDial;
  final String countryCode;
  final String countryName;
  final String website;

  Contact({
    required this.email,
    required this.countryDial,
    required this.countryCode,
    required this.phoneNumber,
    required this.countryName,
    this.website = '',
  });

  // Initial state
  factory Contact.initial() {
    return Contact(
      email: '',
      phoneNumber: '',
      countryDial: '',
      countryCode: '',
      countryName: '',
      website: '',
    );
  }

  Contact copyWith({
    String? countryCode,
    String? email,
    String? countryDial,
    String? phoneNumber,
    String? countryName,
    String? website,
  }) {
    return Contact(
      email: email ?? this.email,
      countryDial: countryDial ?? this.countryDial,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryName: countryName ?? this.countryName,
      countryCode: countryCode ?? this.countryCode,
      website: website ?? this.website,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'countryDial': countryDial,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'countryName': countryName,
      'website': website,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      email: map['email'] ?? '',
      countryDial: map['countryDial'] ?? '',
      countryCode: map['countryCode'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      countryName: map['countryName'] ?? '',
      website: map['website'] ?? '',
    );
  }
}
