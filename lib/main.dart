import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlatformViewScreen(),
    );
  }
}

class PlatformViewScreen extends StatelessWidget {
  const PlatformViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const _UnsupportedPlatform(
        message: "Platform views are not supported on Web.",
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const Scaffold(
          body: SafeArea(
            child: AndroidView(
              viewType: "native-compose-view",
            ),
          ),
        );
      case TargetPlatform.iOS:
        return const Scaffold(
          body: SafeArea(
            child: UiKitView(
              viewType: "native-swift-view",
            ),
          ),
        );
      default:
        return const _UnsupportedPlatform(
          message: "Platform views are only supported on Android and iOS.",
        );
    }
  }
}

class _UnsupportedPlatform extends StatelessWidget {
  final String message;

  const _UnsupportedPlatform({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
