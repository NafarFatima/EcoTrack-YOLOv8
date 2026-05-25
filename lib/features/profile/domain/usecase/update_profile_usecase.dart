import '../repository/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call(String uid, {required String name, required String title}) async {
    return await repository.updateProfile(uid, name: name, title: title);
  }
}
