import 'package:flutter/material.dart';

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