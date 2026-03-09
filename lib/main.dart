import 'package:flutter/material.dart';
import 'screens/login/login.dart';
import 'screens/welcome/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/welcome': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final fullName = args?['fullName'] as String? ?? 'Người dùng';
          final email = args?['email'] as String? ?? 'Email không xác định';
          return WelcomeScreen(fullName: fullName, email: email);
        },
      },
    );
  }
}
