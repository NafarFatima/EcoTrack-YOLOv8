import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/usecase/get_daily_missions_usecase.dart';
import '../../domain/usecase/complete_mission_usecase.dart';
import '../../domain/entity/eco_mission.dart';

class MissionProvider extends ChangeNotifier {
  final GetDailyMissionsUseCase getDailyMissionsUseCase;
  final CompleteMissionUseCase completeMissionUseCase;

  List<EcoMission> _missions = [];
  List<EcoMission> get missions => _missions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StreamSubscription? _authSubscription;
  StreamSubscription? _missionsSubscription;

  MissionProvider({
    required this.getDailyMissionsUseCase,
    required this.completeMissionUseCase,
  }) {
    _init();
  }

  void _init() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _startListeningToMissions(user.uid);
      } else {
        _stopListening();
        _missions = [];
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void _startListeningToMissions(String uid) {
    _isLoading = true;
    notifyListeners();

    _missionsSubscription?.cancel();
    _missionsSubscription = getDailyMissionsUseCase.execute(uid).listen((missions) {
      _missions = missions;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    }, onError: (e) {
      debugPrint("MissionProvider error: $e");
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  void _stopListening() {
    _missionsSubscription?.cancel();
  }

  Future<void> completeMission(String missionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await completeMissionUseCase.execute(user.uid, missionId);
      _errorMessage = null;
    } catch (e) {
      debugPrint("Error completing mission: $e");
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _stopListening();
    super.dispose();
  }
}
