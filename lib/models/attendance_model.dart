import 'package:event_scheduler/data/local/db_helper.dart';

class AttendanceModel {
  final int? id;
  final int eventId;
  final int participantId;
  final String time;

  AttendanceModel({
    this.id,
    required this.eventId,
    required this.participantId,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      DBHelper.COLUMN_ID_3: id,
      DBHelper.COLUMN_EVENT_ID_3: eventId,
      DBHelper.COLUMN_PARTICIPANT_ID_3: participantId,
      DBHelper.COLUMN_TIME_3: time,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map[DBHelper.COLUMN_ID_3],
      eventId: map[DBHelper.COLUMN_EVENT_ID_3],
      participantId: map[DBHelper.COLUMN_PARTICIPANT_ID_3],
      time: map[DBHelper.COLUMN_TIME_3],
    );
  }
}