import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotrack/features/splash/domain/entity/splash_state.dart';
import 'package:ecotrack/features/splash/domain/usecase/check_first_time_usecase.dart';
import 'package:ecotrack/features/splash/domain/usecase/set_first_time_completed_usecase.dart';

class SplashProvider extends ChangeNotifier {
  final CheckFirstTimeUseCase checkFirstTimeUseCase;
  final SetFirstTimeCompletedUseCase setFirstTimeCompletedUseCase;

  SplashState _state = SplashState.initial;
  SplashState get state => _state;

  SplashProvider({
    required this.checkFirstTimeUseCase,
    required this.setFirstTimeCompletedUseCase,
  });

  Future<void> checkStatus() async {
    _state = SplashState.loading;
    notifyListeners();

    try {
      // Add a timeout to ensure we don't get stuck forever
      final config = await checkFirstTimeUseCase.execute().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception("Timeout fetching config"),
      );
      
      if (config.isFirstTime) {
        _state = SplashState.onboarding;
      } else {
        final user = FirebaseAuth.instance.currentUser;
        _state = user != null ? SplashState.authenticated : SplashState.unauthenticated;
      }
    } catch (e) {
      debugPrint("Splash Status Error: $e");
      // Fallback to login if something goes wrong so the user isn't stuck
      _state = SplashState.unauthenticated;
    }
    
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await setFirstTimeCompletedUseCase.execute();
  }
}
