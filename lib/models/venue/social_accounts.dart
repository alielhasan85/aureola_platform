// social_accounts.dart

import 'dart:convert';

class SocialAccounts {
  final String facebook;
  final String twitter;
  final String instagram;
  final String linkedIn;

  SocialAccounts({
    this.facebook = '',
    this.twitter = '',
    this.instagram = '',
    this.linkedIn = '',
  });

  /// Creates a copy of this [SocialAccounts] with the given fields replaced.
  SocialAccounts copyWith({
    String? facebook,
    String? twitter,
    String? instagram,
    String? linkedIn,
  }) {
    return SocialAccounts(
      facebook: facebook ?? this.facebook,
      twitter: twitter ?? this.twitter,
      instagram: instagram ?? this.instagram,
      linkedIn: linkedIn ?? this.linkedIn,
    );
  }

  /// Converts this [SocialAccounts] instance into a map.
  Map<String, dynamic> toMap() {
    return {
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'linkedIn': linkedIn,
    };
  }

  /// Creates a [SocialAccounts] instance from a map.
  factory SocialAccounts.fromMap(Map<String, dynamic> map) {
    return SocialAccounts(
      facebook: map['facebook'] ?? '',
      twitter: map['twitter'] ?? '',
      instagram: map['instagram'] ?? '',
      linkedIn: map['linkedIn'] ?? '',
    );
  }

  /// Returns a JSON string representation of this [SocialAccounts].
  String toJson() => json.encode(toMap());

  /// Creates a [SocialAccounts] instance from a JSON string.
  factory SocialAccounts.fromJson(String source) =>
      SocialAccounts.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SocialAccounts(facebook: $facebook, twitter: $twitter, instagram: $instagram, linkedIn: $linkedIn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocialAccounts &&
        other.facebook == facebook &&
        other.twitter == twitter &&
        other.instagram == instagram &&
        other.linkedIn == linkedIn;
  }

  @override
  int get hashCode {
    return facebook.hashCode ^
        twitter.hashCode ^
        instagram.hashCode ^
        linkedIn.hashCode;
  }
}
