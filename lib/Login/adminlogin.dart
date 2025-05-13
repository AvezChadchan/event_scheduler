import 'package:flutter/material.dart';
// import 'package:event_scheduler/screens/admin_dashboard.dart';

class AdminLogin extends StatefulWidget {
  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void login() {
    // if (emailController.text == "admin@college.com" &&
    //     passwordController.text == "admin123") {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => AdminDashboard()),
    //   );
    // }
    // else if(emailController.text != "admin@college.com" && passwordController.text != "admin123"){
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text("Invaldid credentials")));
    // }
    // else {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text("Fill all the fields")));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Login",
          style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(controller: emailController),
            TextField(controller: passwordController),
            ElevatedButton(onPressed: () => login(), child: Text("Login")),
          ],
        ),
      ),
    );
  }
}
