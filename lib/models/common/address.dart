// address.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  final LatLng location;
  final String country;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String displayAddress;

  Address({
    this.location =
        const LatLng(25.286106, 51.534817), // Require LatLng for location
    this.street = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    required this.country,
    this.displayAddress = '',
  });

  Address copyWith({
    LatLng? location,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? displayAddress,
  }) {
    return Address(
      location: location ?? this.location,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      displayAddress: displayAddress ?? this.displayAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': {
        'lat': location.latitude,
        'lng': location.longitude,
      },
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'displayAddress': displayAddress,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    final locationMap = map['location'] as Map<String, dynamic>?;

    return Address(
      location: locationMap != null
          ? LatLng(
              locationMap['lat']?.toDouble() ?? 25.286106,
              locationMap['lng']?.toDouble() ?? 51.534817,
            )
          : const LatLng(25.286106, 51.534817),
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
      displayAddress: map['displayAddress'] ?? '',
    );
  }
}
