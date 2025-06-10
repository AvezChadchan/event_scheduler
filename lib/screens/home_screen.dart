import 'package:event_scheduler/data/local/db_helper.dart';
import 'package:event_scheduler/models/event_model.dart';
import 'package:event_scheduler/screens/event_detail.dart';
import 'package:event_scheduler/widgets/eventcard.dart';
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
    _getEvents();
  }

  Future<void> _getEvents() async {
    final data = await dbRef!.getAllEvents();
    setState(() {
      _events = data;
    });
  }

  void _gotoEventDetail(EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event, isUser: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HomeScreen",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _getEvents,
            tooltip: 'Refresh Events',
          ),
        ],
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Container(
        color: Colors.blueGrey.shade900,
        child: RefreshIndicator(
          onRefresh: _getEvents,
          child:
              _events.isNotEmpty
                  ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                  )
                  : Center(child: Text("No events found.")),
        ),
      ),
    );
  }
}
