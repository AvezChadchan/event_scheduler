import 'package:event_scheduler/models/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget{
  final EventModel event;
  final VoidCallback onTap;

  EventCard({required this.event,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shadowColor: Colors.white,
        color: Colors.blueGrey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 10),
              Text(event.description,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(event.date),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.access_time, size: 20, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(event.time),
            ],
          ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.person, size: 20, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(event.organizer),
                ],
              ),
          ],
          ),
        ),
      ),
    );
  }

}