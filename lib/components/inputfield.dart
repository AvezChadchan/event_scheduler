import 'package:flutter/material.dart';

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
