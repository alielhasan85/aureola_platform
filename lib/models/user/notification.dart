class Notifications {
  final bool emailNotification;
  final bool smsNotification;

  const Notifications({
    this.emailNotification = true,
    this.smsNotification = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'emailNotification': emailNotification,
      'smsNotification': smsNotification,
    };
  }

  factory Notifications.fromMap(Map<String, dynamic> map) {
    return Notifications(
      emailNotification: map['emailNotification'] ?? true,
      smsNotification: map['smsNotification'] ?? true,
    );
  }
}
