class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final String title;
  final String? profilePhoto;
  final int impactPoints;
  final int level;

  UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    required this.title,
    this.profilePhoto,
    required this.impactPoints,
    required this.level,
  });
}
