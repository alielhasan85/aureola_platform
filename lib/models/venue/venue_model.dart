// venue_model.dart

// venue_model.dart

import 'package:aureola_platform/models/common/address.dart';
import 'package:aureola_platform/models/common/contact.dart';
import 'package:aureola_platform/models/venue/design_display.dart';
import 'social_accounts.dart';
import 'operations.dart';
import 'qr_code.dart';
import 'price_options.dart';

// venue_model.dart

class VenueModel {
  final String venueId;
  final String venueName;
  final String userId;
  final Address address;
  final Contact contact;
  final List<String> languageOptions;
  final SocialAccounts? socialAccounts; // Made optional
  final Operations? operations; // Made optional
  final List<QrCode>? qrCodes; // Made optional
  final DesignAndDisplay? designAndDisplay; // Made optional
  final PriceOptions? priceOptions; // Made optional

  VenueModel({
    required this.venueId,
    required this.venueName,
    required this.userId,
    required this.address,
    required this.contact,
    this.languageOptions = const ['English'],
    this.socialAccounts,
    this.operations,
    this.qrCodes,
    this.designAndDisplay,
    this.priceOptions,
  });

  VenueModel copyWith({
    String? venueId,
    String? venueName,
    String? userId,
    Address? address,
    Contact? contact,
    List<String>? languageOptions,
    SocialAccounts? socialAccounts,
    Operations? operations,
    List<QrCode>? qrCodes,
    DesignAndDisplay? designAndDisplay,
    PriceOptions? priceOptions,
  }) {
    return VenueModel(
      venueId: venueId ?? this.venueId,
      venueName: venueName ?? this.venueName,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      languageOptions: languageOptions ?? this.languageOptions,
      socialAccounts: socialAccounts ?? this.socialAccounts,
      operations: operations ?? this.operations,
      qrCodes: qrCodes ?? this.qrCodes,
      designAndDisplay: designAndDisplay ?? this.designAndDisplay,
      priceOptions: priceOptions ?? this.priceOptions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'venueId': venueId,
      'venueName': venueName,
      'userId': userId,
      'address': address.toMap(),
      'contact': contact.toMap(),
      'languageOptions': languageOptions,
      if (socialAccounts != null) 'socialAccounts': socialAccounts!.toMap(),
      if (operations != null) 'operations': operations!.toMap(),
      if (qrCodes != null) 'qrCodes': qrCodes!.map((q) => q.toMap()).toList(),
      if (designAndDisplay != null)
        'designAndDisplay': designAndDisplay!.toMap(),
      if (priceOptions != null) 'priceOptions': priceOptions!.toMap(),
    };
  }

  factory VenueModel.fromMap(Map<String, dynamic> map, String venueId) {
    return VenueModel(
      venueId: venueId,
      venueName: map['venueName'] ?? '',
      userId: map['userId'] ?? '',
      address: Address.fromMap(map['address'] ?? {}),
      contact: Contact.fromMap(map['contact'] ?? {}),
      languageOptions: List<String>.from(map['languageOptions'] ?? ['English']),
      socialAccounts: map['socialAccounts'] != null
          ? SocialAccounts.fromMap(map['socialAccounts'])
          : null,
      operations: map['operations'] != null
          ? Operations.fromMap(map['operations'])
          : null,
      qrCodes: (map['qrCodes'] as List<dynamic>?)
              ?.map((q) => QrCode.fromMap(q))
              .toList() ??
          [],
      designAndDisplay: map['designAndDisplay'] != null
          ? DesignAndDisplay.fromMap(map['designAndDisplay'])
          : null,
      priceOptions: map['priceOptions'] != null
          ? PriceOptions.fromMap(map['priceOptions'])
          : null,
    );
  }
}
