import 'package:ecotrack/features/onboarding/domain/entity/onboarding_content.dart';

abstract class OnboardingRepository {
  Future<List<OnboardingContent>> getOnboardingData();
}
