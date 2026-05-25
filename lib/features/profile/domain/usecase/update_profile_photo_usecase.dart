import 'dart:io';
import '../repository/profile_repository.dart';

class UpdateProfilePhotoUseCase {
  final ProfileRepository repository;

  UpdateProfilePhotoUseCase(this.repository);

  Future<void> call(String uid, File imageFile) async {
    return await repository.updateProfilePhoto(uid, imageFile);
  }
}
