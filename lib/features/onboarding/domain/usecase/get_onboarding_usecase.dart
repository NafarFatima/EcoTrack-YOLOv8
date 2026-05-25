import 'package:ecotrack/features/onboarding/domain/entity/onboarding_content.dart';
import 'package:ecotrack/features/onboarding/domain/repository/onboarding_repository.dart';

class GetOnboardingUseCase {
  final OnboardingRepository repository;

  GetOnboardingUseCase(this.repository);

  Future<List<OnboardingContent>> execute() async {
    return await repository.getOnboardingData();
  }
}
