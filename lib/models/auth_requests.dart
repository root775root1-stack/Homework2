class LoginRequest {
  final String identifier;
  final String password;
  final bool rememberMe;

  const LoginRequest({
    required this.identifier,
    required this.password,
    required this.rememberMe,
  });
}

class RegisterRequest {
  final String fullName;
  final String academicId;
  final String email;
  final String password;

  const RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
  });
}

class PasswordResetRequest {
  final String identifier;
  const PasswordResetRequest({required this.identifier});
}

class ResetPasswordRequest {
  final String otp;
  final String newPassword;

  const ResetPasswordRequest({
    required this.otp,
    required this.newPassword,
  });
}
