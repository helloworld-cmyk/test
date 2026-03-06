import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'redux/app_state.dart';
import 'redux/app_store.dart';

import 'screens/login/login.dart';
import 'screens/welcome/welcome.dart';

void main() {
  final store = createAppStore();
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
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
      ),
    );
  }
}
