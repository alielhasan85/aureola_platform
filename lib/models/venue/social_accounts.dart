// social_accounts.dart

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

  Map<String, dynamic> toMap() {
    return {
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'linkedIn': linkedIn,
    };
  }

  factory SocialAccounts.fromMap(Map<String, dynamic> map) {
    return SocialAccounts(
      facebook: map['facebook'] ?? '',
      twitter: map['twitter'] ?? '',
      instagram: map['instagram'] ?? '',
      linkedIn: map['linkedIn'] ?? '',
    );
  }
}
