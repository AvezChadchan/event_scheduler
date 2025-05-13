import 'package:flutter/material.dart';

class AdminLogin extends StatelessWidget {
  var userName = TextEditingController();
  var passWord = TextEditingController();
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

    );
  }
}
