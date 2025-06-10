import 'package:event_scheduler/models/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 30,
        color: Colors.blueGrey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  event.title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
              SizedBox(height: 15),
              _buildRow(Icons.calendar_month, event.date),
              SizedBox(height: 15),
              _buildRow(Icons.timer_sharp, event.time),
              SizedBox(height: 15),
              _buildRow(Icons.person, event.organizer),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildRow(IconData icon,String value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon,size: 20,color: Colors.white,),
        Text(value,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white),)
      ],
    );
  }
}
