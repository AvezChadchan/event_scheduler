import 'package:event_scheduler/data/local/db_helper.dart';
import 'package:event_scheduler/models/event_model.dart';
import 'package:event_scheduler/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  final bool isUser;

  EventDetailScreen({required this.event, required this.isUser});

  @override
  Widget build(BuildContext context) {
    const iconSize = 30.0;

    Future<void> deleteEvent() async {
      final deleted = await DBHelper.instance.deleteEvent(event.id!);
      if (deleted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Event deleted successfully")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to delete event")));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
              if (isUser) ...[
                SizedBox(height: 10),
              ] else ...[
                SizedBox(
                  height: 70,
                  width: 400,
                  child: ElevatedButton(
                      onPressed: () async {
                        final confirm = showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text("Delete Event"),
                                content: Text(
                                  "Are you sure you want to delete this event?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => deleteEvent(),
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                      child: Text(
                        "Delete Event",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ),

              ],
              if (isUser)
                SizedBox(
                  height: 70,
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventRegistration(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Card(
        color:  Color(0xFF34444C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    event.title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Card(
        elevation: 5,
        color: Color(0xFF34444C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Divider(color: Colors.grey, thickness: 1.5),
              _buildDetailRow(Icons.calendar_today, 'Date', event.date),
              SizedBox(height: 10),
              Divider(color: Colors.grey, thickness: 1.5),
              _buildDetailRow(Icons.access_time, 'Time', event.time),
              SizedBox(height: 10),
              Divider(color: Colors.grey, thickness: 1.5),
              _buildDetailRow(Icons.location_city, 'Location', event.location),
              SizedBox(height: 10),
              Divider(color: Colors.grey, thickness: 1.5),
              _buildDetailRow(Icons.person, 'Organizer', event.organizer),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(width: 15),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
