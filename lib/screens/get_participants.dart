import 'package:event_scheduler/data/local/db_helper.dart';
import 'package:event_scheduler/models/event_model.dart';
import 'package:event_scheduler/models/participant_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Get_Participants extends StatelessWidget {
  final EventModel event;
  bool isUser;
  Get_Participants({super.key, required this.event, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 27),
        ),
        title:
            isUser
                ? Text(
                  "My Registrations",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                )
                : Text(
                  "Participants of - ${event.title}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Container(
        color: Colors.blueGrey.shade900,
        child: FutureBuilder<List<ParticipantModel>>(
          future: DBHelper.instance.getParticipantsByEvent(event.id!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            final participants = snapshot.data!;
            return ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final participant = participants[index];
                return ListTile(
                  title:
                      isUser
                          ? Text(
                            "Event: ${event.title}\nParticipant: ${participant.name}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                          : Text(
                            participant.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                  subtitle: Text(
                    "Email: ${participant.email}\nGroup: ${participant.groupName ?? 'Individual'}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: Text(
                    participant.groupName ?? 'Individual',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 15.5,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
