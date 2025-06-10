import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventRegistration extends StatefulWidget{

  @override
  State<EventRegistration> createState() => _EventRegistrationState();
}

class _EventRegistrationState extends State<EventRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Registration"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body:
        Column(
          children: [
            Text("Event RegFistration"),
          ],
        )
    );
  }
}