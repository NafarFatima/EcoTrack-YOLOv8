import 'package:flutter/material.dart';
import 'package:ecotrack/features/onboarding/domain/entity/onboarding_content.dart';
import 'package:ecotrack/features/onboarding/domain/usecase/get_onboarding_usecase.dart';

class OnboardingProvider extends ChangeNotifier {
  final GetOnboardingUseCase getOnboardingUseCase;

  OnboardingProvider({required this.getOnboardingUseCase});

  List<OnboardingContent> _onboardingItems = [];
  List<OnboardingContent> get onboardingItems => _onboardingItems;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadOnboardingData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _onboardingItems = await getOnboardingUseCase.execute();
    } catch (e) {
      // Handle error if necessary
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
