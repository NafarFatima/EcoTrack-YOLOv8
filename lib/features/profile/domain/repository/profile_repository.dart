import 'dart:io';
import 'package:ecotrack/core/domain/entity/user_profile.dart';

abstract class ProfileRepository {
  Stream<UserProfile> getProfile(String uid);
  Future<void> updateProfile(String uid, {required String name, required String title});
  Future<void> updateProfilePhoto(String uid, File imageFile);
}
