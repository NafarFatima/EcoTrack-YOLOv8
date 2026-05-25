class UserSessionModel {
  final String? lastUserId;
  final DateTime? lastActive;
  final bool isSessionValid;

  UserSessionModel({
    this.lastUserId,
    this.lastActive,
    this.isSessionValid = false,
  });

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      lastUserId: json['lastUserId'],
      lastActive: json['lastActive'] != null 
          ? DateTime.parse(json['lastActive']) 
          : null,
      isSessionValid: json['isSessionValid'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lastUserId': lastUserId,
      'lastActive': lastActive?.toIso8601String(),
      'isSessionValid': isSessionValid,
    };
  }
}
