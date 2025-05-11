import 'package:event_scheduler/data/local/db_helper.dart';

class ParticipantModel {
  final int? id;
  final String name;
  final int eventId;
  final String email;

  ParticipantModel({
    this.id,
    required this.name,
    required this.eventId,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      DBHelper.COLUMN_ID_2: id,
      DBHelper.COLUMN_NAME_2: name,
      DBHelper.COLUMN_EVENT_ID_2: eventId,
      DBHelper.COLUMN_EMAIL_2: email,
    };
  }

  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      id: map[DBHelper.COLUMN_ID_2],
      name: map[DBHelper.COLUMN_NAME_2],
      eventId: map[DBHelper.COLUMN_EVENT_ID_2],
      email: map[DBHelper.COLUMN_EMAIL_2],
    );
  }
}