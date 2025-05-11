import 'package:event_scheduler/data/local/db_helper.dart';

class EventModel {
  final int? id;
  final String title;
  final String? description;
  final String date;
  final String time;
  final String organizer;
  final String location;

  EventModel({
    this.id,
    required this.title,
    this.description,
    required this.date,
    required this.time,
    required this.organizer,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      DBHelper.COLUMN_ID_1: id,
      DBHelper.COLUMN_TITLE_1: title,
      DBHelper.COLUMN_DESCRIPTION_1: description,
      DBHelper.COLUMN_DATE_1: date,
      DBHelper.COLUMN_TIME_1: time,
      DBHelper.COLUMN_ORGANIZER_1: organizer,
      DBHelper.COLUMN_LOCATION_1: location,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map[DBHelper.COLUMN_ID_1],
      title: map[DBHelper.COLUMN_TITLE_1],
      description: map[DBHelper.COLUMN_DESCRIPTION_1],
      date: map[DBHelper.COLUMN_DATE_1],
      time: map[DBHelper.COLUMN_TIME_1],
      organizer: map[DBHelper.COLUMN_ORGANIZER_1],
      location: map[DBHelper.COLUMN_LOCATION_1],
    );
  }
}