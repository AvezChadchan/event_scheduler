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
      body:
          isAdmin
              ? Container(
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
                        Text(
                          "Welcome Back Admin!",
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
                        neonButton("Login", () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminDashboard(),
                            ),
                          );
                        }),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: Text("Forgot Password?"),
                        ),
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
              )
              : Container(
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
                        Text(
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
                        neonButton("Login", () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {},
                          child: Text("Forgot Password?"),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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

  Widget buildInputField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.cyanAccent),
        labelText: hint,
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Colors.blueGrey.shade700,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(width: 3, color: Colors.cyan),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(width: 2, color: Colors.grey),
        ),
      ),
    );
  }

  Widget neonButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyanAccent, Colors.blueAccent],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.cyanAccent.withOpacity(0.5), blurRadius: 10),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
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
        child: Text(title, style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold)),
      ),
    );
  }
}
