import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotrack/core/domain/entity/user_profile.dart';
import '../../domain/usecase/get_profile_usecase.dart';
import '../../domain/usecase/update_profile_usecase.dart';
import '../../domain/usecase/update_profile_photo_usecase.dart';

class ProfileProvider with ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdateProfilePhotoUseCase updateProfilePhotoUseCase;

  StreamSubscription? _authSubscription;
  StreamSubscription? _profileSubscription;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.updateProfilePhotoUseCase,
  }) {
    _init();
  }

  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _init() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _isLoading = true;
        _errorMessage = null;
        notifyListeners();
        _startListeningToProfile(user.uid);
      } else {
        _stopListeningToProfile();
        _userProfile = null;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void _startListeningToProfile(String uid) {
    _profileSubscription?.cancel();
    _profileSubscription = getProfileUseCase(uid).listen((profile) {
      _userProfile = profile;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    }, onError: (error) {
      debugPrint("ProfileProvider: Error listening to profile: $error");
      _errorMessage = "Failed to load profile.";
      _isLoading = false;
      notifyListeners();
    });
  }

  void _stopListeningToProfile() {
    _profileSubscription?.cancel();
    _profileSubscription = null;
  }

  Future<void> updateProfile({required String uid, required String name, required String title}) async {
    _isLoading = true;
    notifyListeners();
    try {
      await updateProfileUseCase(uid, name: name, title: title);
      // No need to manually update _userProfile as the Firestore stream will push the change
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfilePhoto(String uid, File imageFile) async {
    _isLoading = true;
    notifyListeners();
    try {
      await updateProfilePhotoUseCase(uid, imageFile);
      // Firestore stream will push the update automatically
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _stopListeningToProfile();
    super.dispose();
  }
}
