import 'package:event_scheduler/data/local/db_helper.dart';
import 'package:event_scheduler/models/event_model.dart';
import 'package:event_scheduler/screens/event_create.dart';
import 'package:event_scheduler/screens/event_detail.dart';
import 'package:event_scheduler/widgets/eventcard.dart';
import 'package:event_scheduler/widgets/eventselection.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<EventModel> _events = [];
  bool _isLoading = true;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await DBHelper.instance.getAllEvents();
      setState(() {
        _events = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load events. Please try again.';
      });
    }
  }

  void _gotoEventDetail(EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event, isUser: false),
      ),
    );
  }

  Future<void> _navigateToCreateEvent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EventCreate()),
    );
    if (result == true) {
      _fetchEvents();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchEvents,
            tooltip: 'Refresh Events',
          ),
          IconButton(
            icon: const Icon(Icons.group, color: Colors.white),
            tooltip: "View Participants",
            onPressed: () async{
              await showSelectEventDialog(context: context, events: _events,isUser: false);
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.blueGrey),
              )
              : _errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _fetchEvents,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade700,
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
              : _events.isNotEmpty
              ? RefreshIndicator(
                onRefresh: _fetchEvents,
                child: Container(
                  color: Colors.blueGrey.shade900,
                  child:
                 ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return EventCard(
                        event: event,
                        onTap: () => _gotoEventDetail(event),
                      );
                    },
                  ),
                ),
              )
              : Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.blueGrey.shade900,
                child: Center(
                  child: Text(
                    "No Events Created!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateEvent,
        backgroundColor: Colors.blueGrey.shade300,
        child: const Icon(Icons.add, size: 35, color: Colors.white),
      ),
    );
  }
}
