import 'package:event_scheduler/models/attendance_model.dart';
import 'package:event_scheduler/models/event_model.dart';
import 'package:event_scheduler/models/participant_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static DBHelper get instance => DBHelper._();

  // Table and column names
  static const String TABLE_NAME_1 = "events";
  static const String COLUMN_ID_1 = "id";
  static const String COLUMN_TITLE_1 = "title";
  static const String COLUMN_DESCRIPTION_1 = "description";
  static const String COLUMN_DATE_1 = "date";
  static const String COLUMN_TIME_1 = "time";
  static const String COLUMN_ORGANIZER_1 = "organizer";
  static const String COLUMN_LOCATION_1 = "location";
  static const String COLUMN_IS_GROUP_BASED_1 = "is_group_based";

  static const String TABLE_NAME_2 = "participants";
  static const String COLUMN_ID_2 = "id";
  static const String COLUMN_NAME_2 = "name";
  static const String COLUMN_EVENT_ID_2 = "event_id";
  static const String COLUMN_GROUP = "group_name";
  static const String COLUMN_GROUP_MEMBERS = "group_members";
  static const String COLUMN_EMAIL_2 = "email";

  static const String TABLE_NAME_3 = "attendance";
  static const String COLUMN_ID_3 = "id";
  static const String COLUMN_EVENT_ID_3 = "event_id";
  static const String COLUMN_PARTICIPANT_ID_3 = "participant_id";
  static const String COLUMN_TIME_3 = "time";

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    try {
      var dirPath = await getApplicationDocumentsDirectory();
      var path = join(dirPath.path, "event_schedule.db");
      return await openDatabase(
        path,
        version: 2, // Incremented version for schema change
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $TABLE_NAME_1 (
              $COLUMN_ID_1 INTEGER PRIMARY KEY AUTOINCREMENT,
              $COLUMN_TITLE_1 TEXT NOT NULL,
              $COLUMN_DESCRIPTION_1 TEXT,
              $COLUMN_DATE_1 TEXT NOT NULL,
              $COLUMN_TIME_1 TEXT NOT NULL,
              $COLUMN_ORGANIZER_1 TEXT NOT NULL,
              $COLUMN_LOCATION_1 TEXT NOT NULL,
              $COLUMN_IS_GROUP_BASED_1 INTEGER NOT NULL DEFAULT 0
            )
          ''');
          await db.execute('''
            CREATE TABLE $TABLE_NAME_2 (
              $COLUMN_ID_2 INTEGER PRIMARY KEY AUTOINCREMENT,
              $COLUMN_NAME_2 TEXT NOT NULL,
              $COLUMN_EVENT_ID_2 INTEGER NOT NULL,
              $COLUMN_GROUP TEXT,
              $COLUMN_GROUP_MEMBERS TEXT,
              $COLUMN_EMAIL_2 TEXT NOT NULL,
              FOREIGN KEY ($COLUMN_EVENT_ID_2) REFERENCES $TABLE_NAME_1($COLUMN_ID_1) ON DELETE CASCADE,
              UNIQUE($COLUMN_EVENT_ID_2, $COLUMN_EMAIL_2)
            )
          ''');
          await db.execute('''
            CREATE TABLE $TABLE_NAME_3 (
              $COLUMN_ID_3 INTEGER PRIMARY KEY AUTOINCREMENT,
              $COLUMN_EVENT_ID_3 INTEGER NOT NULL,
              $COLUMN_PARTICIPANT_ID_3 INTEGER NOT NULL,
              $COLUMN_TIME_3 TEXT NOT NULL,
              FOREIGN KEY ($COLUMN_EVENT_ID_3) REFERENCES $TABLE_NAME_1($COLUMN_ID_1) ON DELETE CASCADE,
              FOREIGN KEY ($COLUMN_PARTICIPANT_ID_3) REFERENCES $TABLE_NAME_2($COLUMN_ID_2) ON DELETE CASCADE,
              UNIQUE($COLUMN_EVENT_ID_3, $COLUMN_PARTICIPANT_ID_3)
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('''
      ALTER TABLE $TABLE_NAME_1 ADD $COLUMN_IS_GROUP_BASED_1 INTEGER NOT NULL DEFAULT 0
    ''');
          }
          if (oldVersion < 3) {
            await db.execute('''
      ALTER TABLE $TABLE_NAME_2 ADD COLUMN $COLUMN_GROUP_MEMBERS TEXT
    ''');
          }
        },
      );
    } catch (e) {
      print("Error opening database: $e");
      rethrow;
    }
  }

  // CRUD for events
  Future<bool> insertEvent({
    required String title,
    required String description,
    required String date,
    required String time,
    required String organizer,
    required String location,
    required bool isGroupBased,
  }) async {
    try {
      final db = await getDB();
      final rowsAffected = await db.insert(TABLE_NAME_1, {
        COLUMN_TITLE_1: title,
        COLUMN_DESCRIPTION_1: description,
        COLUMN_DATE_1: date,
        COLUMN_TIME_1: time,
        COLUMN_ORGANIZER_1: organizer,
        COLUMN_LOCATION_1: location,
        COLUMN_IS_GROUP_BASED_1: isGroupBased ? 1 : 0,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      print("Inserted Rows: $rowsAffected");
      return rowsAffected > 0;
    } catch (e) {
      print("Error inserting event: $e");
      return false;
    }
  }

  Future<List<EventModel>> getAllEvents() async {
    try {
      final db = await getDB();
      final List<Map<String, dynamic>> maps = await db.query(
        TABLE_NAME_1,
        orderBy: '$COLUMN_DATE_1 ASC',
      );
      final events =
          maps
              .map(
                (map) => EventModel.fromMap({
                  ...map,
                  COLUMN_IS_GROUP_BASED_1: map[COLUMN_IS_GROUP_BASED_1] == 1,
                }),
              )
              .toList();
      print("All Events: $events");
      return events;
    } catch (e) {
      print("Error fetching events: $e");
      return [];
    }
  }

  Future<EventModel?> getEventById(int id) async {
    try {
      final db = await getDB();
      final maps = await db.query(
        TABLE_NAME_1,
        where: '$COLUMN_ID_1 = ?',
        whereArgs: [id],
      );
      final event =
          maps.isNotEmpty
              ? EventModel.fromMap({
                ...maps.first,
                COLUMN_IS_GROUP_BASED_1:
                    maps.first[COLUMN_IS_GROUP_BASED_1] == 1,
              })
              : null;
      print("Event by ID: $event");
      return event;
    } catch (e) {
      print("Error fetching event by ID: $e");
      return null;
    }
  }

  Future<List<EventModel>> getGroupBasedEvents() async {
    try {
      final db = await getDB();
      final maps = await db.query(
        TABLE_NAME_1,
        where: '$COLUMN_IS_GROUP_BASED_1 = ?',
        whereArgs: [1],
      );
      return maps
          .map(
            (map) => EventModel.fromMap({
              ...map,
              COLUMN_IS_GROUP_BASED_1: map[COLUMN_IS_GROUP_BASED_1] == 1,
            }),
          )
          .toList();
    } catch (e) {
      print("Error fetching group-based events: $e");
      return [];
    }
  }

  Future<bool> updateEvent({
    required int id,
    required String title,
    required String description,
    required String date,
    required String time,
    required String organizer,
    required String location,
    required bool isGroupBased,
  }) async {
    try {
      final db = await getDB();
      final rowsEffected = await db.update(
        TABLE_NAME_1,
        {
          COLUMN_TITLE_1: title,
          COLUMN_DESCRIPTION_1: description,
          COLUMN_DATE_1: date,
          COLUMN_TIME_1: time,
          COLUMN_ORGANIZER_1: organizer,
          COLUMN_LOCATION_1: location,
          COLUMN_IS_GROUP_BASED_1: isGroupBased ? 1 : 0,
        },
        where: '$COLUMN_ID_1 = ?',
        whereArgs: [id],
      );
      print("Updated event, rows affected: $rowsEffected");
      return rowsEffected > 0;
    } catch (e) {
      print("Error updating event: $e");
      return false;
    }
  }

  Future<bool> deleteEvent(int id) async {
    try {
      final db = await getDB();
      final rowsAffected = await db.delete(
        TABLE_NAME_1,
        where: '$COLUMN_ID_1 = ?',
        whereArgs: [id],
      );
      print("Deleted event, rows affected: $rowsAffected");
      return rowsAffected > 0;
    } catch (e) {
      print("Error deleting event: $e");
      return false;
    }
  }

  // CRUD for participants
  Future<bool> insertParticipant({
    required String name,
    required int eventId,
    required String email,
    required String? groupName,
    required String? groupMembers,
  }) async {
    try {
      final db = await getDB();
      final event = await getEventById(eventId);
      if (event == null) {
        print("Error: Event with ID $eventId does not exist");
        return false;
      }
      if (event.isGroupBased && (groupMembers == null || groupMembers.trim().isEmpty)) {
        print("Error: Group members required for group-based event");
        return false;
      }

      final rowsAffected = await db.insert(TABLE_NAME_2, {
        COLUMN_NAME_2: name,
        COLUMN_EVENT_ID_2: eventId,
        COLUMN_GROUP: groupName,
        COLUMN_GROUP_MEMBERS: groupMembers,
        COLUMN_EMAIL_2: email,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      print("Inserted participant, rows affected: $rowsAffected");
      return rowsAffected > 0;
    } catch (e) {
      print("Error inserting participant: $e");
      return false;
    }
  }

  Future<List<ParticipantModel>> getParticipantsByEvent(int eventId) async {
    try {
      final db = await getDB();
      final maps = await db.query(
        TABLE_NAME_2,
        where: "$COLUMN_EVENT_ID_2 = ?",
        whereArgs: [eventId],
      );
      final participants =
          maps.map((map) => ParticipantModel.fromMap(map)).toList();
      print("Participants for event $eventId: $participants");
      return participants;
    } catch (e) {
      print("Error fetching participants: $e");
      return [];
    }
  }

  Future<List<ParticipantModel>> getParticipantsByGroup(
    int eventId,
    String groupName,
  ) async {
    try {
      final db = await getDB();
      final maps = await db.query(
        TABLE_NAME_2,
        where: "$COLUMN_EVENT_ID_2 = ? AND $COLUMN_GROUP = ?",
        whereArgs: [eventId, groupName],
      );
      final participants =
          maps.map((map) => ParticipantModel.fromMap(map)).toList();
      print(
        "Participants for event $eventId in group $groupName: $participants",
      );
      return participants;
    } catch (e) {
      print("Error fetching participants by group: $e");
      return [];
    }
  }

  Future<ParticipantModel?> getParticipantById(int id) async {
    try {
      final db = await getDB();
      final map = await db.query(
        TABLE_NAME_2,
        where: '$COLUMN_ID_2 = ?',
        whereArgs: [id],
      );
      final participants =
          map.map((map) => ParticipantModel.fromMap(map)).toList();
      final participant = participants.isNotEmpty ? participants.first : null;
      print("Participant by ID: $participant");
      return participant;
    } catch (e) {
      print("Error fetching participant by ID: $e");
      return null;
    }
  }

  Future<bool> updateParticipant({
    required int id,
    required String name,
    required int eventId,
    required String email,
    required String? groupName,
    required String? groupMembers,
  }) async {
    try {
      final db = await getDB();
      final event = await getEventById(eventId);
      if (event == null) {
        print("Error: Event with ID $eventId does not exist");
        return false;
      }
      if (event.isGroupBased && (groupName == null || groupName.isEmpty)) {
        print("Error: Group name is required for group-based event");
        return false;
      }
      final rowsAffected = await db.update(
        TABLE_NAME_2,
        {
          COLUMN_NAME_2: name,
          COLUMN_EVENT_ID_2: eventId,
          COLUMN_GROUP: groupName,
          COLUMN_GROUP_MEMBERS: groupMembers,
          COLUMN_EMAIL_2: email,
        },
        where: '$COLUMN_ID_2 = ?',
        whereArgs: [id],
      );
      print("Updated participant, rows affected: $rowsAffected");
      return rowsAffected > 0;
    } catch (e) {
      print("Error updating participant: $e");
      return false;
    }
  }

  Future<bool> deleteParticipant(int id) async {
    try {
      final db = await getDB();
      final rowsAffected = await db.delete(
        TABLE_NAME_2,
        where: '$COLUMN_ID_2 = ?',
        whereArgs: [id],
      );
      print("Deleted participant, rows affected: $rowsAffected");
      return rowsAffected > 0;
    } catch (e) {
      print("Error deleting participant: $e");
      return false;
    }
  }

  Future<List<String>> getGroupsInEvent(int eventId) async {
    try {
      final db = await getDB();
      final maps = await db.rawQuery(
        '''
      SELECT DISTINCT $COLUMN_GROUP
      FROM $TABLE_NAME_2
      WHERE $COLUMN_EVENT_ID_2 = ? AND $COLUMN_GROUP IS NOT NULL AND $COLUMN_GROUP != ""
      ''',
        [eventId],
      );
      return maps.map((row) => row[COLUMN_GROUP] as String).toList();
    } catch (e) {
      print("Error fetching groups: $e");
      return [];
    }
  }

  // CRUD for attendance
  Future<bool> insertAttendance({
    required int eventId,
    required int participantId,
    required String time,
  }) async {
    try {
      final db = await getDB();
      final rowsAffected = await db.insert(TABLE_NAME_3, {
        COLUMN_EVENT_ID_3: eventId,
        COLUMN_PARTICIPANT_ID_3: participantId,
        COLUMN_TIME_3: time,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      print("Inserted attendance, rows affected: $rowsAffected");
      return rowsAffected > 0;
    } catch (e) {
      print("Error inserting attendance: $e");
      return false;
    }
  }

  Future<List<AttendanceModel>> getAttendanceByEvent(int eventId) async {
    try {
      final db = await getDB();
      final map = await db.query(
        TABLE_NAME_3,
        where: '$COLUMN_EVENT_ID_3 = ?',
        whereArgs: [eventId],
      );
      final attendance =
          map.map((map) => AttendanceModel.fromMap(map)).toList();
      print("Attendance for event $eventId: $attendance");
      return attendance;
    } catch (e) {
      print("Error fetching attendance: $e");
      return [];
    }
  }

  Future<AttendanceModel?> getAttendanceById(int id) async {
    try {
      final db = await getDB();
      final map = await db.query(
        TABLE_NAME_3,
        where: '$COLUMN_ID_3 = ?',
        whereArgs: [id],
      );
      final attendance =
          map.map((map) => AttendanceModel.fromMap(map)).toList();
      final record = attendance.isNotEmpty ? attendance.first : null;
      print("Attendance by ID: $record");
      return record;
    } catch (e) {
      print("Error fetching attendance by ID: $e");
      return null;
    }
  }

  Future<bool> updateAttendance({
    required int id,
    required int eventId,
    required int participantId,
    required String time,
  }) async {
    try {
      final db = await getDB();
      final rowsAffected = await db.update(
        TABLE_NAME_3,
        {
          COLUMN_EVENT_ID_3: eventId,
          COLUMN_PARTICIPANT_ID_3: participantId,
          COLUMN_TIME_3: time,
        },
        where: '$COLUMN_ID_3 = ?',
        whereArgs: [id],
      );
      print("Updated attendance, rows affected: $rowsAffected");
      return rowsAffected > 0;
    } catch (e) {
      print("Error updating attendance: $e");
      return false;
    }
  }

  Future<bool> deleteAttendance(int id) async {
    try {
      final db = await getDB();
      final rowsAffected = await db.delete(
        TABLE_NAME_3,
        where: '$COLUMN_ID_3 = ?',
        whereArgs: [id],
      );
      print("Deleted attendance, rows affected: $rowsAffected");
      return rowsAffected > 0;
    } catch (e) {
      print("Error deleting attendance: $e");
      return false;
    }
  }

  // Additional Utility Methods
  Future<bool> hasScheduleConflict(
    String date,
    String time,
    String location,
  ) async {
    try {
      final db = await getDB();
      final result = await db.query(
        TABLE_NAME_1,
        where:
            '$COLUMN_DATE_1 = ? AND $COLUMN_TIME_1 = ? AND $COLUMN_LOCATION_1 = ?',
        whereArgs: [date, time, location],
      );
      return result.isNotEmpty;
    } catch (e) {
      print("Error checking schedule conflict: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAttendeesForEvent(int eventId) async {
    try {
      final db = await getDB();
      final result = await db.rawQuery(
        '''
        SELECT p.*
        FROM $TABLE_NAME_2 p
        INNER JOIN $TABLE_NAME_3 a ON p.$COLUMN_ID_2 = a.$COLUMN_PARTICIPANT_ID_3
        WHERE a.$COLUMN_EVENT_ID_3 = ?
        ''',
        [eventId],
      );
      print("Attendees for event $eventId: $result");
      return result;
    } catch (e) {
      print("Error fetching attendees: $e");
      return [];
    }
  }

  Future<bool> isGroupBasedEvent(int eventId) async {
    try {
      final event = await getEventById(eventId);
      return event?.isGroupBased ?? false;
    } catch (e) {
      print("Error checking if event is group-based: $e");
      return false;
    }
  }

  Future<void> closeDB() async {
    final db = await getDB();
    await db.close();
    myDB = null;
  }
}
