class LoginRequest {
  final String identifier; // المعرف الأكاديمي أو البريد
  final String password;
  final bool rememberMe;

  LoginRequest({
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
  final bool agreeToTerms;

  RegisterRequest({
    required this.fullName,
    required this.academicId,
    required this.email,
    required this.password,
    required this.agreeToTerms,
  });
}