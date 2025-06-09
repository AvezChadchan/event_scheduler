import 'package:flutter/material.dart';
import 'package:event_scheduler/Login/mainlogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // bool isDark = false;
    return MaterialApp(
      title: 'College Event Scheduler',
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   primarySwatch: Colors.indigo,
      //   scaffoldBackgroundColor: Colors.white,
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: Colors.indigo,
      //     titleTextStyle: TextStyle(fontSize: 33,fontWeight: FontWeight.bold,color: Colors.white),
      //   ),
      //   textTheme: TextTheme(
      //     bodyMedium: TextStyle(color: Colors.black),
      //   ),
      // ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   scaffoldBackgroundColor: Colors.grey[900],
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: Colors.black,
      //     titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 33,color: Colors.white),
      //   ),
      // ),
      // themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home:  MainLogin(
        // isDarkMode:isDark,
        // onThemeToggle: () {
        //   setState(() {
        //     isDark = !isDark;
        //   });
        // },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}