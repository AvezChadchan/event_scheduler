import 'package:flutter/material.dart';

import 'adminlogin.dart';
import 'userlogin.dart';

class MainLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("Login as Admin"),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLogin()),
                ),
          ),
          ElevatedButton(
            child: Text("Login as User"),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserLogin()),
                ),
          ),
        ],
      ),
    );
  }
}
