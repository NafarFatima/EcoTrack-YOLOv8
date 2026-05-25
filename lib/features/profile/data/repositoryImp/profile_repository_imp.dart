import 'dart:io';
import 'package:ecotrack/core/domain/entity/user_profile.dart';
import '../../domain/repository/profile_repository.dart';
import '../model/user_profile_model.dart';
import '../services/profile_service.dart';

class ProfileRepositoryImp implements ProfileRepository {
  final ProfileService profileService;

  ProfileRepositoryImp(this.profileService);

  @override
  Stream<UserProfile> getProfile(String uid) {
    return profileService.getProfileStream(uid).map((doc) {
      return UserProfileModel.fromFirestore(doc);
    });
  }

  @override
  Future<void> updateProfile(String uid, {required String name, required String title}) async {
    await profileService.updateProfileData(uid, {
      'displayName': name,
      'title': title,
    });
  }

  @override
  Future<void> updateProfilePhoto(String uid, File imageFile) async {
    final base64Image = await profileService.uploadProfileImage(uid, imageFile);
    await profileService.updateProfileData(uid, {
      'profilePhoto': base64Image,
    });
  }
}
