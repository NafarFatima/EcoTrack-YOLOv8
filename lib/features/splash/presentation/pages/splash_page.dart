import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecotrack/core/extention/size_extention.dart';
import 'package:ecotrack/features/home/presentation/pages/main_shell.dart';
import 'package:ecotrack/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:ecotrack/features/authentication/presentation/pages/login_page.dart';
import 'package:ecotrack/features/splash/domain/entity/splash_state.dart';
import 'package:ecotrack/features/splash/presentation/provider/splash_provider.dart';
import 'package:ecotrack/features/splash/presentation/widgets/splash_logo.dart';
import 'package:ecotrack/features/splash/presentation/widgets/splash_brand_identity.dart';
import 'package:ecotrack/features/splash/presentation/widgets/splash_bottom_branding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashProvider>().checkStatus();
    });
  }

  void _navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFBFBE2),
          body: Container(
            width: 390.w,
            height: 844.h,
            decoration: const BoxDecoration(
              color: Color(0xFFFBFBE2),
            ),
            child: Column(
              children: [
                const Spacer(flex: 3),
                // Central Branding Cluster
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App Logo with Glassmorphism
                      const SplashLogo(),
                      SizedBox(height: 32.h),
                      // Brand Identity
                      const SplashBrandIdentity(),
                    ],
                  ),
                ),
                const Spacer(flex: 3),
                // Bottom Contextual Branding
                const SplashBottomBranding(),
              ],
            ),
          ),
        );
      },
    ).listener<SplashProvider>((context, provider) {
      if (provider.state == SplashState.authenticated) {
        _navigateTo(const MainShell());
      } else if (provider.state == SplashState.onboarding) {
        _navigateTo(const OnboardingScreen());
      } else if (provider.state == SplashState.unauthenticated) {
        _navigateTo(const LoginPage());
      }
    });
  }
}

// Extension to add listener to Consumer
extension ConsumerListenerExtension on Widget {
  Widget listener<T>(void Function(BuildContext, T) onUpdate) {
    return _ConsumerListener<T>(
      onUpdate: onUpdate,
      child: this,
    );
  }
}

class _ConsumerListener<T> extends StatelessWidget {
  final void Function(BuildContext, T) onUpdate;
  final Widget child;

  const _ConsumerListener({
    required this.onUpdate,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<T>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onUpdate(context, provider);
    });
    return child;
  }
}
