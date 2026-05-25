import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecotrack/core/domain/entity/logged_waste.dart';
import 'package:ecotrack/core/domain/entity/waste_item.dart';
import 'package:ecotrack/features/home/domain/usecase/get_categories_usecase.dart';
import '../../domain/usecase/get_history_usecase.dart';
import 'package:intl/intl.dart';

enum HistoryTab { history, categories }

class HistoryProvider extends ChangeNotifier {
  final GetHistoryUseCase getHistoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  List<LoggedWaste> _history = [];
  List<LoggedWaste> get history => _getFilteredHistory();

  List<WasteItem> _categories = [];
  List<WasteItem> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  HistoryTab _selectedTab = HistoryTab.history;
  HistoryTab get selectedTab => _selectedTab;

  String? _selectedCategoryId;
  String? get selectedCategoryId => _selectedCategoryId;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  StreamSubscription? _authSubscription;
  StreamSubscription? _historySubscription;

  HistoryProvider({
    required this.getHistoryUseCase,
    required this.getCategoriesUseCase,
  }) {
    _init();
  }

  void _init() {
    loadCategories();
    
    // Set initial loading state if we have a user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _isLoading = true;
      notifyListeners();
      _startListeningToHistory(currentUser.uid);
    }

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _isLoading = true;
        notifyListeners();
        _startListeningToHistory(user.uid);
      } else {
        _stopListeningToHistory();
        _history = [];
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> loadCategories() async {
    try {
      _categories = await getCategoriesUseCase.execute();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading categories: $e");
    }
  }

  void setTab(HistoryTab tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void filterByCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    _selectedTab = HistoryTab.history;
    notifyListeners();
  }

  void clearCategoryFilter() {
    _selectedCategoryId = null;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<LoggedWaste> _getFilteredHistory() {
    Iterable<LoggedWaste> filtered = _history;
    
    if (_selectedCategoryId != null) {
      filtered = filtered.where((item) => item.category.id == _selectedCategoryId);
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        final name = item.itemName ?? item.category.title;
        return name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.location.toLowerCase().contains(_searchQuery.toLowerCase());
      });
    }
    
    return filtered.toList();
  }

  Map<String, List<LoggedWaste>> getGroupedHistory() {
    final Map<String, List<LoggedWaste>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var log in history) {
      final logDate = DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day);
      String key;
      if (logDate == today) {
        key = "TODAY, ${DateFormat('MMM d').format(log.timestamp).toUpperCase()}";
      } else if (logDate == yesterday) {
        key = "YESTERDAY";
      } else {
        key = DateFormat('EEEE, MMM d').format(log.timestamp).toUpperCase();
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(log);
    }
    return grouped;
  }

  void _startListeningToHistory(String userId) {
    _stopListeningToHistory();
    
    debugPrint("HistoryProvider: Starting listener for $userId");
    
    if (_history.isEmpty) {
      _isLoading = true;
      notifyListeners();
    }

    _historySubscription = getHistoryUseCase.call(userId).listen(
      (data) {
        debugPrint("HistoryProvider: Received ${data.length} logs from repository");
        _history = data;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (e) {
        debugPrint("HistoryProvider: Error in history stream: $e");
        _errorMessage = "Failed to load history: $e";
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void _stopListeningToHistory() {
    _historySubscription?.cancel();
    _historySubscription = null;
  }

  Future<void> fetchHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      debugPrint("HistoryProvider: Manual fetch requested");
      _isLoading = true;
      notifyListeners();
      _startListeningToHistory(user.uid);
    }
  }

  int getPointsForCategory(String categoryId) {
    return _history
        .where((log) => log.category.id == categoryId)
        .fold(0, (sum, log) => sum + log.pointsEarned);
  }

  int getTotalPoints() {
    return _history.fold(0, (sum, log) => sum + log.pointsEarned);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _stopListeningToHistory();
    super.dispose();
  }
}
