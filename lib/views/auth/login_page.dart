import 'package:flutter/material.dart';

// مسارات الاستيراد بناءً على هيكل المشروع الإجباري
import '../../controllers/auth_controller.dart';
import '../../models/login_requests.dart';
import '../../utils/form_validators.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final AuthController authController;
  const LoginPage({super.key, required this.authController});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الدخول الطلابي'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _identifierController,
                  decoration: const InputDecoration(
                    labelText: 'المعرف الأكاديمي أو البريد',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: FormValidators.validateIdentifier,
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: widget.authController,
                  builder: (context, _) {
                    return TextFormField(
                      controller: _passwordController,
                      obscureText: widget.authController.obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            widget.authController.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: widget.authController.togglePasswordVisibility,
                        ),
                      ),
                      validator: FormValidators.validatePassword,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (val) => setState(() => _rememberMe = val ?? false),
                        ),
                        const Text('تذكرني'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForgotPasswordPage(authController: widget.authController),
                          ),
                        );
                      },
                      child: const Text('نسيت كلمة المرور؟'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                                final request = LoginRequest(
                                  identifier: _identifierController.text.trim(),
                                  password: _passwordController.text,
                                  rememberMe: _rememberMe,
                                );

                                // نقوم باستدعاء تسجيل الدخول
                                bool success = false;
                                String errorMessage = '';

                                try {
                                  success = await widget.authController.login(request);
                                } catch (e) {
                                  success = false;
                                  errorMessage = e.toString().replaceAll('Exception: ', '');
                                }

                                if (!mounted) return;

                                if (success) {
                                  // إظهار سناك بار النجاح الأخضر
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم تسجيل الدخول بنجاح'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  // إظهار سناك بار الخطأ الأحمر مع الرسالة الواضحة
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage.isNotEmpty
                                          ? errorMessage
                                          : 'فشل تسجيل الدخول، تأكد من الرقم الأكاديمي أو كلمة المرور'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text(
                              'تسجيل الدخول',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ليس لديك حساب؟'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterPage(authController: widget.authController),
                          ),
                        );
                      },
                      child: const Text('إنشاء حساب جديد'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}