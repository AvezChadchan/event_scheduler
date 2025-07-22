import 'package:event_scheduler/models/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.blueGrey.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin:  EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Row(
             children: [
               Text(
                 event.title,
                 style: TextStyle(
                   fontSize: 26,
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                 ),
               ),
               Spacer(),
               Padding(
                 padding: const EdgeInsets.only(top: 10),
                 child: GestureDetector(
                   onTap: onTap,
                   child: Card(
                     elevation: 4,
                     child: Container(
                       padding: EdgeInsets.all(15),
                       width: 150,
                       height: 50,
                       decoration: BoxDecoration(
                         color: Colors.blueGrey.shade700,
                         borderRadius: BorderRadius.circular(10),
                       ),
                       child: Text("View Details",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 17),),
                     ),
                   ),
                 ),
               ),
             ],
           ),
            SizedBox(height: 15),
            _buildRow(Icons.calendar_month, event.date),
            SizedBox(height: 10),
            _buildRow(Icons.timer_sharp, event.time),
            SizedBox(height: 10),
            _buildRow(Icons.person, event.organizer),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Colors.white),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
