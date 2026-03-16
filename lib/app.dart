import 'package:flutter/material.dart';
import 'screens/assignment_list_page.dart';

class HomeworkApp extends StatelessWidget {
  const HomeworkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nộp bài tập',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F6A6A)),
        useMaterial3: true,
      ),
      home: const AssignmentListPage(),
    );
  }
}
