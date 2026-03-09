import 'package:flutter/material.dart';
import 'package:first_app/screens/login/login.dart';
import 'package:first_app/screens/login/wrapper.dart';
import 'package:first_app/screens/welcome/welcome.dart';
import 'package:first_app/screens/welcome/wrapper.dart';

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
        '/login': (context) => const LoginStore(child: LoginScreen()),
        '/welcome': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final fullName = args?['fullName'] as String? ?? 'Người dùng';
          final email = args?['email'] as String? ?? 'Email không xác định';
          return ProductStore(
            child: WelcomeScreen(fullName: fullName, email: email),
          );
        },
      },
    );
  }
}
