import 'package:event_scheduler/data/local/db_helper.dart';
import 'package:event_scheduler/models/event_model.dart';
import 'package:event_scheduler/screens/event_create.dart';
import 'package:event_scheduler/screens/event_detail.dart';
import 'package:event_scheduler/screens/get_participants.dart';
import 'package:event_scheduler/widgets/eventcard.dart';
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

  void _showEventSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        EventModel? selectedEvent;
        return AlertDialog(
          titleTextStyle: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),
          backgroundColor: Colors.blueGrey.shade800,
          title: Text("Select Event"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<EventModel>(
                value: selectedEvent,
                hint: Text("Choose Event"),
                isExpanded: true,
                items:
                    _events.map((event) {
                      return DropdownMenuItem(
                        value: event,
                        child: Text(event.title),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEvent = value;
                  });
                },
                borderRadius: BorderRadius.circular(15),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                dropdownColor: Colors.blueGrey,
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedEvent != null) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => GetParticipants(event: selectedEvent!),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
        ),
              child: Text("View Participants"),

            ),
          ],
        );
      },
    );
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
            onPressed: () {
              _showEventSelectionDialog();
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
                  child: GridView.builder(
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
                  ),
                ),
              )
              : const Center(
                child: Text(
                  "No Events Created!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueGrey,
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
