import 'package:event_scheduler/models/event_model.dart';
import 'package:event_scheduler/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  final bool isUser;

  EventDetailScreen({
    required this.event,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    const iconSize = 30.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.title,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: iconSize),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blueGrey.shade900,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              _buildCard(context),
              SizedBox(height: 30),
              _buildDetailsCard(),
              SizedBox(height: 90),
              if (isUser)
                Container(
                  height: 70,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EventRegistration()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade700,
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: Card(
        color: Colors.blueGrey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 30,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event,size: 30,color: Colors.white,),
                  SizedBox(width: 10),
                  Text(
                    event.title,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(event.description,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)
            ],
          ),
        ),
      )
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 30,
        color: Colors.blueGrey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
          child: Column(
            children: [
              _buildDetailRow(Icons.calendar_today, event.date),
              SizedBox(height: 10),
              _buildDetailRow(Icons.access_time, event.time),
              SizedBox(height: 10),
              _buildDetailRow(Icons.location_city, event.location),
              SizedBox(height: 10),
              _buildDetailRow(Icons.person, event.organizer),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, size: 30, color: Colors.white),
        SizedBox(width: 15),
        Flexible(
          child: Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
