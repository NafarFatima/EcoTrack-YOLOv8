import 'package:ecotrack/features/onboarding/presentation/provider/onboarding_provider.dart';
import 'package:ecotrack/features/onboarding/presentation/widgets/onboarding_buttons.dart';
import 'package:ecotrack/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:ecotrack/features/onboarding/presentation/widgets/onboarding_item_widget.dart';
import 'package:ecotrack/features/onboarding/presentation/widgets/onboarding_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/authentication/presentation/pages/login_page.dart';
import 'package:ecotrack/features/splash/presentation/provider/splash_provider.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: Consumer<OnboardingProvider>(
            builder: (context, provider, child) {
              final items = provider.onboardingItems;
              if (items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  const OnboardingHeader(),

                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) => provider.setCurrentIndex(index),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return OnboardingItemWidget(item: items[index]);
                      },
                    ),
                  ),

                  OnboardingPagination(
                    itemCount: items.length,
                    currentIndex: provider.currentIndex,
                  ),

                  const SizedBox(height: 20),

                  OnboardingButtons(
                    isLastPage: provider.currentIndex == items.length - 1,
                    onContinue: () async {
                      if (provider.currentIndex < items.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        await context.read<SplashProvider>().completeOnboarding();
                        if (context.mounted) {
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
