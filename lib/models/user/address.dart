class Address {
  final String country;
  final String state;
  final String city;
  final String addressLine;

  Address({
    required this.country,
    this.state = '',
    this.city = '',
    this.addressLine = '',
  });

  // The copyWith method
  Address copyWith({
    String? country,
    String? state,
    String? city,
    String? addressLine,
  }) {
    return Address(
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      addressLine: addressLine ?? this.addressLine,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'state': state,
      'city': city,
      'addressLine': addressLine,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      country: map['country'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      addressLine: map['addressLine'] ?? '',
    );
  }
}
