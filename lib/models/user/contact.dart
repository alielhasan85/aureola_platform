class Contact {
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String countryDial;

  Contact({
    required this.email,
    required this.phoneNumber,
    required this.countryCode,
    required this.countryDial,
  });

  // The copyWith method
  Contact copyWith({
    String? email,
    String? phoneNumber,
    String? countryCode,
    String? countryDial,
  }) {
    return Contact(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      countryDial: countryDial ?? this.countryDial,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'countryDial': countryDial,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      countryCode: map['countryCode'] ?? '',
      countryDial: map['countryDial'] ?? '',
    );
  }
}
