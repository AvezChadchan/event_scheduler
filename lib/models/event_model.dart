import 'package:event_scheduler/data/local/db_helper.dart';

class EventModel {
  final int? id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String organizer;
  final String location;
  final bool isGroupBased;

  EventModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.organizer,
    required this.location,
    required this.isGroupBased,
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
      DBHelper.COLUMN_IS_GROUP_BASED_1: isGroupBased ? 1 : 0,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map[DBHelper.COLUMN_ID_1] as int?,
      title: map[DBHelper.COLUMN_TITLE_1] as String,
      description: map[DBHelper.COLUMN_DESCRIPTION_1] as String? ?? '',
      date: map[DBHelper.COLUMN_DATE_1] as String,
      time: map[DBHelper.COLUMN_TIME_1] as String,
      organizer: map[DBHelper.COLUMN_ORGANIZER_1] as String,
      location: map[DBHelper.COLUMN_LOCATION_1] as String,
      isGroupBased: _parseIsGroupBased(map[DBHelper.COLUMN_IS_GROUP_BASED_1]),
    );
  }

  static bool _parseIsGroupBased(dynamic value) {
    if (value is int) {
      return value == 1;
    } else if (value is bool) {
      return value;
    }
    return false; // Default to false if value is null or unexpected type
  }

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, description: $description, date: $date, time: $time, organizer: $organizer, location: $location, isGroupBased: $isGroupBased)';
  }
}