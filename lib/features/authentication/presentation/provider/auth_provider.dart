import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../domain/usecase/signin_usecase.dart';
import '../../domain/usecase/signup_usecase.dart';
import '../../domain/usecase/send_password_reset_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';

class AuthNotifier extends ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SendPasswordResetUseCase sendPasswordResetUseCase;
  final LogoutUseCase logoutUseCase;

  AuthNotifier({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.sendPasswordResetUseCase,
    required this.logoutUseCase,
  }) {
    _auth.authStateChanges().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  User? get user => _currentUser;

  bool _isLoading = false;
  String? _errorMessage;
  String? _infoMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get infoMessage => _infoMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _errorMessage = value;
    _infoMessage = null;
    notifyListeners();
  }

  void _setInfo(String? value) {
    _infoMessage = value;
    _errorMessage = null;
    notifyListeners();
  }

  String _mapFirebaseError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-credential':
          return 'Invalid email or password. Please try again.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'email-already-in-use':
          return 'This email is already registered. Use another email.';
        case 'weak-password':
          return 'Password should be at least 6 characters long.';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'configuration-not-found':
          return 'Firebase configuration error. Please contact support.';
        default:
          return 'An unexpected error occurred (${e.code}). Please try again.';
      }
    }
    return e.toString();
  }

  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _setError('Please fill all fields');
      return;
    }
    _setLoading(true);
    try {
      await signInUseCase.execute(email, password);
      _setError(null);
    } catch (e) {
      _setError(_mapFirebaseError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      _setError('Please fill all fields');
      return;
    }
    if (password.length < 6) {
      _setError('Password should be at least 6 characters long.');
      return;
    }
    _setLoading(true);
    try {
      await signUpUseCase.execute(email, password, name);
      _setError(null);
    } catch (e) {
      _setError(_mapFirebaseError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    if (email.isEmpty) {
      _setError('Please enter your email');
      return;
    }
    _setLoading(true);
    try {
      await sendPasswordResetUseCase.execute(email);
      _setInfo('Password reset link sent to your email');
    } catch (e) {
      _setError(_mapFirebaseError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await logoutUseCase.execute();
    } catch (e) {
      _setError(e.toString());
    }
  }
}
