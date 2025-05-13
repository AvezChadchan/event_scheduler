import 'package:flutter/material.dart';
import 'package:event_scheduler/Login/mainlogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College Event Scheduler',
      // theme: AppTheme.lightTheme,
      home:  MainLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}