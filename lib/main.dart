import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/login/provider/provider.dart';
import 'screens/welcome/provider/provider.dart';
import 'screens/login/login.dart';
import 'screens/welcome/welcome.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final fullName = args?['fullName'] as String? ?? 'Người dùng';
          final email = args?['email'] as String? ?? 'Email không xác định';
          return WelcomeScreen(fullName: fullName, email: email);
        },
      },
    );
  }
}
