import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entity/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({
    required super.uid,
    required super.email,
    super.displayName,
  });

  factory LoginModel.fromFirebaseUser(User user) {
    return LoginModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }
}
