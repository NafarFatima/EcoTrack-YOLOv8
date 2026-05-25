import '../entity/login_entity.dart';

abstract class AuthRepository {
  Future<LoginEntity?> signIn(String email, String password);
  Future<LoginEntity?> signUp(String email, String password, String name);
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
  Stream<LoginEntity?> get user;
}
