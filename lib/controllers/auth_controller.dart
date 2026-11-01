import 'package:flutter/material.dart';
import 'package:hw2/reopsitories/auth_repository.dart';
import '../models/login_requests.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> login(LoginRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authRepository.login(request);
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(RegisterRequest request) async {
    _isLoading = true;
    notifyListeners();
    try {
      bool success = await _authRepository.register(request);
      return success;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendPasswordResetCode(String identifier) async {
    _isLoading = true;
    notifyListeners();
    try {
      bool success = await _authRepository.sendPasswordResetCode(identifier);
      return success;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword({required String otp, required String newPassword}) async {
    _isLoading = true;
    notifyListeners();
    try {
      bool success = await _authRepository.resetPassword(otp: otp, newPassword: newPassword);
      return success;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}