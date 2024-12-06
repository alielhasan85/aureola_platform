// address.dart

class Address {
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  Address({
    this.street = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    required this.country,
  });

  Address copyWith({
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
    );
  }
}
