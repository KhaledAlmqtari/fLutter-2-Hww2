import '../models/user_model.dart';
import '../models/login_requests.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  // متغيرات لحفظ بيانات آخر حساب تم إنشاؤه للتأكد من مطابقتها عند تسجيل الدخول
  static String _registeredFullName = 'طالب جامعي';
  static String _registeredAcademicId = '202310001';
  static String _registeredEmail = 'student@university.edu';
  static String _currentPassword = 'Password123'; // كلمة المرور الافتراضية

  @override
  Future<UserModel> login(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 2));

    // 1. التحقق من تطابق المعرف الأكاديمي أو البريد الإلكتروني مع ما تم تسجيله
    bool isIdentifierValid = (request.identifier.trim() == _registeredAcademicId) ||
        (request.identifier.trim().toLowerCase() == _registeredEmail.toLowerCase());

    if (!isIdentifierValid) {
      throw Exception('الرقم الأكاديمي أو البريد الإلكتروني غير صحيح أو غير مسجل');
    }

    // 2. التحقق من صحة كلمة المرور
    if (request.password != _currentPassword) {
      throw Exception('كلمة المرور غير صحيحة');
    }

    // إذا كانت البيانات مطابقة تماماً، يتم تسجيل الدخول بنجاح
    return UserModel(
      fullName: _registeredFullName,
      academicId: _registeredAcademicId,
      email: _registeredEmail,
    );
  }

  @override
  Future<bool> register(RegisterRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // حفظ بيانات الحساب الجديد الذي أدخله المستخدم في الشاشة
    _registeredFullName = request.fullName;
    _registeredAcademicId = request.academicId;
    _registeredEmail = request.email;
    _currentPassword = request.password;
    
    return true; 
  }

  @override
  Future<bool> sendPasswordResetCode(String identifier) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // التحقق مما إذا كان المعرف الأكاديمي أو البريد مطاباقاً لما تم تسجيله
    bool isIdentifierValid = (identifier.trim() == _registeredAcademicId) ||
        (identifier.trim().toLowerCase() == _registeredEmail.toLowerCase());

    if (!isIdentifierValid) {
      throw Exception('الرقم الأكاديمي أو البريد الإلكتروني غير مسجل لدينا');
    }

    return true; 
  }

  @override
  Future<bool> resetPassword({required String otp, required String newPassword}) async {
    await Future.delayed(const Duration(seconds: 2));
    _currentPassword = newPassword; // تحديث كلمة المرور الجديدة
    return true; 
  }
}