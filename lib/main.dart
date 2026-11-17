import 'package:flutter/material.dart';
import 'views/auth/login_page.dart';

void main() {
  runApp(const StudentAuthApp());
}

class StudentAuthApp extends StatelessWidget {
  const StudentAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2457C5)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFFF7F8FC),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
