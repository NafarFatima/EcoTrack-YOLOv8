class UserSession {
  final String? lastUserId;
  final DateTime? lastActive;
  final bool isSessionValid;

  UserSession({
    this.lastUserId,
    this.lastActive,
    this.isSessionValid = false,
  });
}
