import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/login_requests.dart';
import '../../utils/form_validators.dart';

class RegisterPage extends StatefulWidget {
  final AuthController authController;
  const RegisterPage({super.key, required this.authController});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _academicIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب طالب جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                validator: FormValidators.validateFullName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _academicIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'الرقم الأكاديمي'),
                validator: FormValidators.validateAcademicId,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'البريد الجامعي'),
                validator: FormValidators.validateEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'كلمة المرور (سياسة قوية)'),
                validator: FormValidators.validateStrongPassword,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'تأكيد كلمة المرور'),
                validator: (val) {
                  if (val != _passwordController.text) {
                    return 'كلمتا المرور غير متطابقتين';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: const Text('الموافقة على اللوائح والشروط الأكاديمية'),
                value: _agreeToTerms,
                onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: widget.authController,
                builder: (context, _) {
                  return widget.authController.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (!_agreeToTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('يجب الموافقة على اللوائح والشروط أولاً')),
                              );
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              final request = RegisterRequest(
                                fullName: _nameController.text,
                                academicId: _academicIdController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                agreeToTerms: _agreeToTerms,
                              );
                              bool success = await widget.authController.register(request);
                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('تم إنشاء الحساب بنجاح، يرجى تسجيل الدخول')),
                                );
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: const Text('إنشاء الحساب'),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}