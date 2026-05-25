import 'package:ecotrack/features/onboarding/data/services/onboarding_service.dart';
import 'package:ecotrack/features/onboarding/domain/entity/onboarding_content.dart';
import 'package:ecotrack/features/onboarding/domain/repository/onboarding_repository.dart';

class OnboardingRepositoryImp implements OnboardingRepository {
  final OnboardingService service;

  OnboardingRepositoryImp(this.service);

  @override
  Future<List<OnboardingContent>> getOnboardingData() async {
    return await service.getOnboardingData();
  }
}
