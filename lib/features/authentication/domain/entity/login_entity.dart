class LoginEntity {
  final String uid;
  final String email;
  final String? displayName;

  LoginEntity({
    required this.uid,
    required this.email,
    this.displayName,
  });
}
