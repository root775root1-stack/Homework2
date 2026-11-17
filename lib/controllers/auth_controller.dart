import 'package:flutter/foundation.dart';
import '../models/auth_requests.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository repository;
  AuthController(this.repository);

  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;

  Future<bool> _run(Future<void> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(LoginRequest request) => _run(() async {
    currentUser = await repository.login(request);
  });

  Future<bool> register(RegisterRequest request) =>
      _run(() => repository.register(request));

  Future<bool> sendPasswordResetCode(PasswordResetRequest request) =>
      _run(() => repository.sendPasswordResetCode(request));

  Future<bool> resetPassword(ResetPasswordRequest request) =>
      _run(() => repository.resetPassword(request));
}
