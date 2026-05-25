import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotrack/features/push_notification/domain/entity/push_notification.dart';
import 'package:ecotrack/features/push_notification/domain/usecase/get_notifications_usecase.dart';
import 'package:ecotrack/features/push_notification/domain/usecase/mark_notification_as_read_usecase.dart';

class NotificationProvider extends ChangeNotifier {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;

  List<PushNotification> _notifications = [];
  List<PushNotification> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StreamSubscription? _notificationsSubscription;
  StreamSubscription? _authSubscription;

  NotificationProvider({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
  }) {
    _init();
  }

  void _init() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _listenToNotifications(user.uid);
      } else {
        _notificationsSubscription?.cancel();
        _notifications = [];
        notifyListeners();
      }
    });
  }

  void _listenToNotifications(String userId) {
    _isLoading = true;
    notifyListeners();

    _notificationsSubscription?.cancel();
    _notificationsSubscription = getNotificationsUseCase.execute(userId).listen((notifications) {
      _notifications = notifications;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> markAsRead(String notificationId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await markNotificationAsReadUseCase.execute(user.uid, notificationId);
      } catch (e) {
        // Handle error
      }
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _notificationsSubscription?.cancel();
    super.dispose();
  }
}
