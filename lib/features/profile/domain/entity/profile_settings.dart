class ProfileSettings {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool publicProfile;
  final String language;

  ProfileSettings({
    required this.emailNotifications,
    required this.pushNotifications,
    required this.publicProfile,
    required this.language,
  });

  factory ProfileSettings.defaultSettings() {
    return ProfileSettings(
      emailNotifications: true,
      pushNotifications: true,
      publicProfile: true,
      language: 'en',
    );
  }
}
