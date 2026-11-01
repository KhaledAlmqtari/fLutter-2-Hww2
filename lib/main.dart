import 'package:flutter/material.dart';
import 'package:hw2/reopsitories/auth_repository_impl.dart';
import 'controllers/auth_controller.dart';
import 'views/auth/login_page.dart';

void main() {
  runApp(const StudentAuthApp());
}

class StudentAuthApp extends StatelessWidget {
  const StudentAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن المستودع في وحدة التحكم
    final authController = AuthController(AuthRepositoryImpl());

    return MaterialApp(
      title: 'نظام المصادقة الطلابي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo', // يمكنك استخدام خط عربي إذا كان متوفراً لديك
      ),
      // هذا هو السطر المسؤول عن جعل اتجاه التطبيق بالكامل من اليمين لليسار (RTL)
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: LoginPage(authController: authController),
    );
  }
}