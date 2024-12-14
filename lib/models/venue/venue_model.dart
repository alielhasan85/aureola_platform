// lib/models/venue/venue_model.dart

import 'package:aureola_platform/models/common/address.dart';
import 'package:aureola_platform/models/common/contact.dart';
import 'package:aureola_platform/models/common/subscription.dart';
import 'package:aureola_platform/models/venue/design_display.dart';
import 'social_accounts.dart';
import 'operations.dart';
import 'qr_code.dart';
import 'price_options.dart';

class VenueModel {
  final String venueId;
  final String venueName;
  final String userId;
  final Address address;
  final Contact contact;
  final List<String> languageOptions;
  final SocialAccounts? socialAccounts;
  final Operations? operations;
  final List<QrCode> qrCodes;
  final DesignAndDisplay designAndDisplay;
  final PriceOptions? priceOptions;
  final Subscription? subscription;
  final List<String> staff;
  final Map<String, dynamic> additionalInfo;

  VenueModel({
    required this.venueId,
    required this.venueName,
    required this.userId,
    required this.address,
    required this.contact,
    this.languageOptions = const ['English'],
    this.socialAccounts,
    this.operations,
    this.qrCodes = const [],
    required this.designAndDisplay,
    this.priceOptions,
    this.subscription,
    this.staff = const [],
    this.additionalInfo = const {},
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
    Subscription? subscription,
    List<String>? staff,
    Map<String, dynamic>? additionalInfo,
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
      subscription: subscription ?? this.subscription,
      staff: staff ?? this.staff,
      additionalInfo: additionalInfo ?? this.additionalInfo,
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
      'staff': staff,
      if (socialAccounts != null) 'socialAccounts': socialAccounts!.toMap(),
      if (operations != null) 'operations': operations!.toMap(),
      if (qrCodes.isNotEmpty) 'qrCodes': qrCodes.map((q) => q.toMap()).toList(),
      'designAndDisplay': designAndDisplay.toMap(),
      if (priceOptions != null) 'priceOptions': priceOptions!.toMap(),
      if (subscription != null) 'subscription': subscription!.toMap(),
      if (additionalInfo.isNotEmpty) 'additionalInfo': additionalInfo,
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
      staff: List<String>.from(map['staff'] ?? []),
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
          : DesignAndDisplay(),
      priceOptions: map['priceOptions'] != null
          ? PriceOptions.fromMap(map['priceOptions'])
          : null,
      subscription: map['subscription'] != null
          ? Subscription.fromMap(map['subscription'])
          : null,
      additionalInfo: map['additionalInfo'] != null
          ? Map<String, dynamic>.from(map['additionalInfo'])
          : {},
    );
  }

  @override
  String toString() {
    return 'VenueModel(venueId: $venueId, venueName: $venueName, userId: $userId, address: $address, contact: $contact, languageOptions: $languageOptions, socialAccounts: $socialAccounts, operations: $operations, qrCodes: $qrCodes, designAndDisplay: $designAndDisplay, priceOptions: $priceOptions, subscription: $subscription, staff: $staff, additionalInfo: $additionalInfo)';
  }
}
