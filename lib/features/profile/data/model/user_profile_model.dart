import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecotrack/core/domain/entity/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.id,
    required super.displayName,
    required super.email,
    required super.title,
    super.profilePhoto,
    required super.impactPoints,
    required super.level,
  });

  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final impactPoints = data['impactPoints'] ?? 0;
    return UserProfileModel(
      id: doc.id,
      displayName: data['displayName'] ?? "User",
      email: data['email'] ?? "",
      title: data['title'] ?? "Eco Warrior",
      profilePhoto: data['profilePhoto'],
      impactPoints: impactPoints,
      level: (impactPoints / 200).floor() + 1,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'title': title,
      'profilePhoto': profilePhoto,
      'impactPoints': impactPoints,
    };
  }
}
