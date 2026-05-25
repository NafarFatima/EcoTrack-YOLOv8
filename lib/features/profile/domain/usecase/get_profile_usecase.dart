import 'package:ecotrack/core/domain/entity/user_profile.dart';
import '../repository/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Stream<UserProfile> call(String uid) {
    return repository.getProfile(uid);
  }
}
