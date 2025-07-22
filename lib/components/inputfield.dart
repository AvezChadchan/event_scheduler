import 'package:flutter/material.dart';

Widget buildInputField(
  IconData icon,
  String hint,
  TextEditingController controller, {
  String? Function(String?)? validator,
  bool isPassword = false,
      int maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    maxLines: maxLines,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.cyanAccent),
      labelText: hint,
      labelStyle: const TextStyle(
        color: Colors.white60,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: Colors.blueGrey.shade700,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 3, color: Colors.cyan),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 2, color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 2, color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width: 3, color: Colors.red),
      ),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
    ),
    validator: validator,
  );
}
