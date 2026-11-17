import '../models/auth_requests.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(LoginRequest request);
  Future<void> register(RegisterRequest request);
  Future<void> sendPasswordResetCode(PasswordResetRequest request);
  Future<void> resetPassword(ResetPasswordRequest request);
}
