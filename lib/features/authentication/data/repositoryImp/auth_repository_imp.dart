import '../../domain/entity/login_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../model/login_model.dart';
import '../services/auth_services.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthServices authServices;

  AuthRepositoryImp(this.authServices);

  @override
  Future<LoginEntity?> signIn(String email, String password) async {
    final userCredential = await authServices.signIn(email, password);
    if (userCredential.user != null) {
      return LoginModel.fromFirebaseUser(userCredential.user!);
    }
    return null;
  }

  @override
  Future<LoginEntity?> signUp(String email, String password, String name) async {
    final userCredential = await authServices.signUp(email, password, name);
    if (userCredential.user != null) {
      return LoginModel.fromFirebaseUser(userCredential.user!);
    }
    return null;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await authServices.sendPasswordReset(email);
  }

  @override
  Future<void> signOut() async {
    await authServices.signOut();
  }

  @override
  Stream<LoginEntity?> get user {
    return authServices.user.map((firebaseUser) {
      if (firebaseUser != null) {
        return LoginModel.fromFirebaseUser(firebaseUser);
      }
      return null;
    });
  }
}
