import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/login/login.dart';
import 'screens/welcome/welcome.dart';
import 'screens/welcome/logic/binding.dart';
import 'screens/login/logic/binding.dart';
void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          binding: LoginBinding(),
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/welcome',
          binding: ProductBinding(),
          page: () {
            final args = Get.arguments as Map<String, dynamic>?;
            final fullName = args?['fullName'] as String? ?? 'Người dùng';
            final email = args?['email'] as String? ?? 'Email không xác định';
            return WelcomeScreen(fullName: fullName, email: email);
          },
        ),
      ],
    );
  }

}

