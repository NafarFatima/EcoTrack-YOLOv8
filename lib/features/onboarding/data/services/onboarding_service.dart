import 'package:ecotrack/core/constant/app_assets.dart';
import 'package:ecotrack/features/onboarding/data/model/onboarding_model.dart';

class OnboardingService {
  Future<List<OnboardingModel>> getOnboardingData() async {
    // In a real app, this might fetch from a remote API or local JSON file
    // For now, we return the hardcoded data to simulate a service call
    return [
      OnboardingModel(
        title: 'Master the Art of',
        titleHighlighted: 'Sorting',
        description: 'Reduce your footprint by identifying what can truly be recycled. We\'ll guide you through local guidelines with ease.',
        image: AppAssets.photo2b,
      ),
      OnboardingModel(
        title: 'Track Your',
        titleHighlighted: 'Impact',
        description: 'See how much CO2 you\'ve saved and earn eco-points for every item you recycle correctly.',
        image: AppAssets.photo6a,
      ),
      OnboardingModel(
        title: 'Earn Great',
        titleHighlighted: 'Rewards',
        description: 'Redeem your eco-points for exclusive discounts and sustainable products from our partners.',
        image: AppAssets.photo4b,
      ),
    ];
  }
}
