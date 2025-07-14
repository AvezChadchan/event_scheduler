import 'package:event_scheduler/data/local/db_helper.dart';
import 'package:event_scheduler/models/event_model.dart';
import 'package:event_scheduler/models/participant_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetParticipants extends StatelessWidget {
  final EventModel event;
  const GetParticipants({super.key, required this.event});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Participants of - ${event.title}")),
      body: FutureBuilder<List<ParticipantModel>>(
        future: DBHelper.instance.getParticipantsByEvent(event.id!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final participants = snapshot.data!;
          return ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final participant = participants[index];
              return ListTile(
                title: Text(participant.name),
                subtitle: Text(
                  "Email: ${participant.email}\nGroup: ${participant.groupName ?? 'Individual'}",
                ),
                trailing: Text(participant.groupName ?? 'Individual'),
              );
            },
          );
        },
      ),
    );
  }
}
