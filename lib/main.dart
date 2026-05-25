import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:ecotrack/core/constant/app_colors.dart';
import 'package:ecotrack/features/authentication/data/repositoryImp/auth_repository_imp.dart';
import 'package:ecotrack/features/authentication/data/services/auth_services.dart';
import 'package:ecotrack/features/authentication/domain/usecase/logout_usecase.dart';
import 'package:ecotrack/features/authentication/domain/usecase/send_password_reset_usecase.dart';
import 'package:ecotrack/features/authentication/domain/usecase/signin_usecase.dart';
import 'package:ecotrack/features/authentication/domain/usecase/signup_usecase.dart';
import 'package:ecotrack/features/authentication/presentation/provider/auth_provider.dart';
import 'package:ecotrack/features/add/data/repositoryImp/add_repository_imp.dart';
import 'package:ecotrack/features/add/data/services/add_services.dart';
import 'package:ecotrack/features/add/domain/usecase/add_log_waste_usecase.dart';
import 'package:ecotrack/features/add/domain/usecase/get_add_categories_usecase.dart';
import 'package:ecotrack/features/add/presentation/provider/add_provider.dart';
import 'package:ecotrack/features/home/presentation/provider/waste_provider.dart';
import 'package:ecotrack/features/home/presentation/provider/mission_provider.dart';
import 'package:ecotrack/features/home/data/repositoryImp/waste_repository_imp.dart';
import 'package:ecotrack/features/home/data/repositoryImp/mission_repository_imp.dart';
import 'package:ecotrack/features/home/data/services/waste_services.dart';
import 'package:ecotrack/features/home/domain/usecase/get_categories_usecase.dart';
import 'package:ecotrack/features/home/domain/usecase/get_waste_logs_usecase.dart';
import 'package:ecotrack/features/home/domain/usecase/log_waste_usecase.dart';
import 'package:ecotrack/features/home/domain/usecase/get_daily_missions_usecase.dart';
import 'package:ecotrack/features/home/domain/usecase/complete_mission_usecase.dart';
import 'package:ecotrack/core/utils/firestore_seed.dart';
import 'package:ecotrack/features/profile/data/repositoryImp/profile_repository_imp.dart';
import 'package:ecotrack/features/profile/data/services/profile_service.dart';
import 'package:ecotrack/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:ecotrack/features/profile/domain/usecase/update_profile_usecase.dart';
import 'package:ecotrack/features/profile/domain/usecase/update_profile_photo_usecase.dart';
import 'package:ecotrack/features/profile/presentation/provider/profile_provider.dart';
import 'package:ecotrack/features/history/data/repositoryImp/history_repository_imp.dart';
import 'package:ecotrack/features/history/data/services/history_service.dart';
import 'package:ecotrack/features/history/domain/usecase/get_history_usecase.dart';
import 'package:ecotrack/features/history/presentation/provider/history_provider.dart';
import 'package:ecotrack/features/onboarding/data/repositoryImp/onboarding_repository_imp.dart';
import 'package:ecotrack/features/onboarding/data/services/onboarding_service.dart';
import 'package:ecotrack/features/onboarding/domain/usecase/get_onboarding_usecase.dart';
import 'package:ecotrack/features/onboarding/presentation/provider/onboarding_provider.dart';
import 'package:ecotrack/features/push_notification/data/repositoryImp/push_notification_repository_imp.dart';
import 'package:ecotrack/features/push_notification/data/services/notification_service.dart';
import 'package:ecotrack/features/push_notification/domain/usecase/get_notifications_usecase.dart';
import 'package:ecotrack/features/push_notification/domain/usecase/mark_notification_as_read_usecase.dart';
import 'package:ecotrack/features/push_notification/presentation/provider/notification_provider.dart';
import 'package:ecotrack/features/rewards/data/repositoryImp/rewards_repository_imp.dart';
import 'package:ecotrack/features/rewards/data/services/rewards_service.dart';
import 'package:ecotrack/features/rewards/domain/usecase/get_achievements_usecase.dart';
import 'package:ecotrack/features/rewards/domain/usecase/get_leaderboard_usecase.dart';
import 'package:ecotrack/features/rewards/presentation/provider/rewards_provider.dart';
import 'package:ecotrack/features/splash/data/repositoryImp/splash_repository_imp.dart';
import 'package:ecotrack/features/splash/data/services/splash_service.dart';
import 'package:ecotrack/features/splash/domain/usecase/check_first_time_usecase.dart';
import 'package:ecotrack/features/splash/domain/usecase/set_first_time_completed_usecase.dart';
import 'package:ecotrack/features/splash/presentation/provider/splash_provider.dart';
import 'features/splash/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Seed Firestore data asynchronously so it doesn't block the UI startup
  FirestoreSeed.seedCategories().catchError((e) => debugPrint("Error seeding categories: $e"));
  FirestoreSeed.seedMissions().catchError((e) => debugPrint("Error seeding missions: $e"));

  final authServices = AuthServices();
  final authRepository = AuthRepositoryImp(authServices);
  final wasteServices = WasteServices();
  final wasteRepository = WasteRepositoryImp(wasteServices);
  final missionRepository = MissionRepositoryImp();
  final profileService = ProfileService();
  final profileRepository = ProfileRepositoryImp(profileService);
  final addServices = AddServices();
  final addRepository = AddRepositoryImp(addServices);
  final historyService = HistoryService();
  final historyRepository = HistoryRepositoryImp(historyService);
  final onboardingService = OnboardingService();
  final onboardingRepository = OnboardingRepositoryImp(onboardingService);
  final notificationService = NotificationService();
  final notificationRepository = PushNotificationRepositoryImp(notificationService);
  final rewardsService = RewardsService();
  final rewardsRepository = RewardsRepositoryImp(rewardsService);
  final splashService = SplashService();
  final splashRepository = SplashRepositoryImp(splashService);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WasteProvider(
            getCategoriesUseCase: GetCategoriesUseCase(wasteRepository),
            getWasteLogsUseCase: GetWasteLogsUseCase(wasteRepository),
            logWasteUseCase: LogWasteUseCase(wasteRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AddProvider(
            getCategoriesUseCase: GetAddCategoriesUseCase(addRepository),
            logWasteUseCase: AddLogWasteUseCase(addRepository),
            completeMissionUseCase: CompleteMissionUseCase(missionRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MissionProvider(
            getDailyMissionsUseCase: GetDailyMissionsUseCase(missionRepository),
            completeMissionUseCase: CompleteMissionUseCase(missionRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            getProfileUseCase: GetProfileUseCase(profileRepository),
            updateProfileUseCase: UpdateProfileUseCase(profileRepository),
            updateProfilePhotoUseCase: UpdateProfilePhotoUseCase(profileRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(
            getHistoryUseCase: GetHistoryUseCase(historyRepository),
            getCategoriesUseCase: GetCategoriesUseCase(wasteRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider(
            getOnboardingUseCase: GetOnboardingUseCase(onboardingRepository),
          )..loadOnboardingData(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(
            getNotificationsUseCase: GetNotificationsUseCase(notificationRepository),
            markNotificationAsReadUseCase: MarkNotificationAsReadUseCase(notificationRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RewardsProvider(
            getAchievementsUseCase: GetAchievementsUseCase(rewardsRepository),
            getLeaderboardUseCase: GetLeaderboardUseCase(rewardsRepository),
          )..loadRewardsData(),
        ),
        ChangeNotifierProvider(
          create: (_) => SplashProvider(
            checkFirstTimeUseCase: CheckFirstTimeUseCase(splashRepository),
            setFirstTimeCompletedUseCase: SetFirstTimeCompletedUseCase(splashRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(
            signInUseCase: SignInUseCase(authRepository),
            signUpUseCase: SignUpUseCase(authRepository),
            sendPasswordResetUseCase: SendPasswordResetUseCase(authRepository),
            logoutUseCase: LogoutUseCase(authRepository),
          ),
        ),
      ],
      child: const EcoTrackApp(),
    ),
  );
}

class EcoTrackApp extends StatelessWidget {
  const EcoTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoTrack',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'PlusJakartaSans',
      ),
      home: const SplashScreen(),
    );
  }
}
