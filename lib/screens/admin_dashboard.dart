import 'package:event_scheduler/data/local/db_helper.dart';
import 'package:event_scheduler/models/event_model.dart';
import 'package:event_scheduler/screens/event_create.dart';
import 'package:event_scheduler/screens/event_detail.dart';
import 'package:event_scheduler/widgets/eventcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  DBHelper? dbRef;

  List<EventModel> _events = [];
  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.instance;
    getevents();
  }

  Future<void> getevents() async {
    final data = await dbRef!.getAllEvents();
    print("Fetched Events: $_events");
    setState(() {
      _events = data;
    });
  }

  void gotoEventDetail(EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailScreen(event: event)),
    );
    print("Clicked on Event: ${event.title}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"), centerTitle: true),
      body:
          _events.isNotEmpty
              ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  return EventCard(
                    event: event,
                    onTap: () => gotoEventDetail(event),
                  );
                },
              )
              : Center(
                child: Text(
                  "No Events Created!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventCreate()),
          );
        },
        child: Icon(Icons.add, size: 35, color: Colors.black),
      ),
    );
  }
}
