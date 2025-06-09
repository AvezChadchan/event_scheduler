import 'package:event_scheduler/data/local/db_helper.dart';
import 'package:event_scheduler/models/event_model.dart';
import 'package:event_scheduler/screens/event_detail.dart';
import 'package:event_scheduler/widgets/eventcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  DBHelper? dbRef;
  List<EventModel> _events = [];
  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.instance;
    getEvents();
  }

  Future<void> getEvents() async {
    final data = await dbRef!.getAllEvents();
    print("Fetched Events: $_events");
    setState(() {
      _events = data;
    });
  }

  void _gotoEventDetail(EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailScreen(event: event)),
    );
    print("Clicked on Event: ${event.title}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HomeScreen"), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: getEvents,
        child:
            _events.isNotEmpty
                ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return EventCard(
                  event: event,
                  onTap: () => _gotoEventDetail(event),
                );
              },
            ) : Center(child: Text("No events found.")),
      ),
    );
  }
}
