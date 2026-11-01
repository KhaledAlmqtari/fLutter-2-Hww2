import '../models/user_model.dart';
import '../models/login_requests.dart';

abstract class AuthRepository {
  Future<UserModel> login(LoginRequest request);
  Future<bool> register(RegisterRequest request);
  Future<bool> sendPasswordResetCode(String identifier);
  Future<bool> resetPassword({required String otp, required String newPassword});
}