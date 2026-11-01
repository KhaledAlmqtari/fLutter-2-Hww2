import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/form_validators.dart';
import 'reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  final AuthController authController;
  const ForgotPasswordPage({super.key, required this.authController});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Card(
                  elevation: 2,
                  color: Colors.blue.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'تعليمات الاستعادة:\nأدخل البريد الإلكتروني أو الرقم الأكاديمي المسجل، وسنقوم بإرسال رمز تحقق مكون من 6 أرقام لإعادة تعيين كلمة المرور الخاصة بك.',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _identifierController,
                  decoration: const InputDecoration(
                    labelText: 'البريد أو الرقم الأكاديمي',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: FormValidators.validateIdentifier,
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: widget.authController,
                  builder: (context, _) {
                    return widget.authController.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool success = false;
                                String errorMessage = '';

                                try {
                                  success = await widget.authController
                                      .sendPasswordResetCode(_identifierController.text.trim());
                                } catch (e) {
                                  success = false;
                                  errorMessage = e.toString().replaceAll('Exception: ', '');
                                }

                                if (!mounted) return;

                                if (success) {
                                  // إظهار SnackBar أخضر والانتقال لشاشة التعيين
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم إرسال رمز التحقق بنجاح'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ResetPasswordPage(
                                        authController: widget.authController,
                                      ),
                                    ),
                                  );
                                } else {
                                  // إظهار SnackBar أحمر في حال كان الرقم غير مسجل
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage.isNotEmpty
                                          ? errorMessage
                                          : 'الرقم الأكاديمي أو البريد غير صحيح'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text(
                              'إرسال رمز التحقق',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('العودة لتسجيل الدخول'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}