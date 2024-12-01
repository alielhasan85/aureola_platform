class UserSettings {
  final bool darkMode;
  final String language;

  const UserSettings({
    this.darkMode = false,
    this.language = 'English',
  });

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'language': language,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      darkMode: map['darkMode'] ?? false,
      language: map['language'] ?? 'English',
    );
  }
}
