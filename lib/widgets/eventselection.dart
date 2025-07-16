import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../screens/get_participants.dart';

Future<void> showSelectEventDialog({
  required BuildContext context,
  required List<EventModel> events,
  required final isUser,
}) async {
  EventModel? selectedEvent;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.blueGrey.shade800,
        title: Text(
          "Select Event",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButton<EventModel>(
              value: selectedEvent,
              hint: Text("Choose Event"),
              isExpanded: true,
              items: events.map((event) {
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedEvent != null) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Get_Participants(
                      event: selectedEvent!,
                      isUser: isUser,
                    ),
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
