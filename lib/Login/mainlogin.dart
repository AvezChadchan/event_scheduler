import 'package:event_scheduler/components/inputfield.dart';
import 'package:event_scheduler/components/neonbutton.dart';
import 'package:event_scheduler/screens/admin_dashboard.dart';
import 'package:event_scheduler/screens/home_screen.dart';
import 'package:flutter/material.dart';

class MainLogin extends StatefulWidget {
  @override
  State<MainLogin> createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey.shade900),
      body: Container(
        color: Colors.blueGrey.shade900,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, color: Colors.cyanAccent, size: 40),
                SizedBox(height: 10),
                isAdmin
                    ? Text(
                      "Welcome Back Admin!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                    : Text(
                      "Welcome Back User!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                SizedBox(height: 20),
                buildInputField(Icons.email, 'Email', emailController),
                SizedBox(height: 15),
                buildInputField(
                  Icons.lock,
                  'Password',
                  passwordController,
                  isPassword: true,
                ),
                SizedBox(height: 20),
                isAdmin
                    ? neonButton("Login", () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminDashboard(),
                        ),
                      );
                    })
                    : neonButton("Login", () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }),
                SizedBox(height: 10),
                TextButton(onPressed: () {}, child: Text("Forgot Password?")),
                SizedBox(height: 10),
                Row(
                  children: [
                    toggleButton('User', false),
                    SizedBox(width: 10),
                    toggleButton('Admin', true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget toggleButton(String title, bool value) {
    bool selected = isAdmin == value;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isAdmin = value;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.cyanAccent : Colors.grey.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
