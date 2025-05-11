import 'package:event_scheduler/models/event_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper get instance => DBHelper._();

  // Table and column names for events
  static const String TABLE_NAME_1 = "events";
  static const String COLUMN_ID_1 = "id";
  static const String COLUMN_TITLE_1 = "title";
  static const String COLUMN_DESCRIPTION_1 = "description";
  static const String COLUMN_DATE_1 = "date";
  static const String COLUMN_TIME_1 = "time";
  static const String COLUMN_ORGANIZER_1 = "organizer";
  static const String COLUMN_LOCATION_1 = "location";

  // Table and column names for participants
  static const String TABLE_NAME_2 = "participants";
  static const String COLUMN_ID_2 = "id";
  static const String COLUMN_NAME_2 = "name";
  static const String COLUMN_EVENT_ID_2 = "event_id";
  static const String COLUMN_EMAIL_2 = "email";

  // Table and column names for attendance
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
        onCreate: (db, version) async {
          // Create events table
          await db.execute('''
            CREATE TABLE $TABLE_NAME_1 (
              $COLUMN_ID_1 INTEGER PRIMARY KEY AUTOINCREMENT,
              $COLUMN_TITLE_1 TEXT NOT NULL,
              $COLUMN_DESCRIPTION_1 TEXT,
              $COLUMN_DATE_1 TEXT NOT NULL,
              $COLUMN_TIME_1 TEXT NOT NULL,
              $COLUMN_ORGANIZER_1 TEXT NOT NULL,
              $COLUMN_LOCATION_1 TEXT NOT NULL
            )
          ''');

          // Create participants table
          await db.execute('''
            CREATE TABLE $TABLE_NAME_2 (
              $COLUMN_ID_2 INTEGER PRIMARY KEY AUTOINCREMENT,
              $COLUMN_NAME_2 TEXT NOT NULL,
              $COLUMN_EVENT_ID_2 INTEGER NOT NULL,
              $COLUMN_EMAIL_2 TEXT NOT NULL,
              FOREIGN KEY ($COLUMN_EVENT_ID_2) REFERENCES $TABLE_NAME_1($COLUMN_ID_1) ON DELETE CASCADE,
              UNIQUE($COLUMN_EVENT_ID_2, $COLUMN_EMAIL_2)
            )
          ''');

          // Create attendance table
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
        onUpgrade: (db, oldVersion, newVersion) {
          // Handle schema migrations if needed
        },
        version: 1,
      );
    } catch (e) {
      print("Error opening database: $e");
      rethrow;
    }
  }

  //CRUD for events
  Future<bool> insertEvent({
    required String title,
    required String description,
    required String date,
    required String time,
    required String organizer,
    required String location,
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
      final List<Map<String,dynamic>> maps = await db.query(
        TABLE_NAME_1,
        orderBy: '$COLUMN_DATE_1 ASC',
      );
      final events=maps.map((map)=>EventModel.fromMap(map)).toList();
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
      final event = maps.isNotEmpty ? EventModel.fromMap(maps.first) : null;
      print("Event by ID: $event");
      return event;
    } catch (e) {
      print("Error fetching event by ID: $e");
      return null;
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

  //CRUD for participants
  Future<bool> insertParticipant({
    required String name,
    required int eventId,
    required String email,
  }) async {
    try {
      final db = await getDB();
      final rowsAffected = await db.insert(TABLE_NAME_2, {
        COLUMN_NAME_2: name,
        COLUMN_EVENT_ID_2: eventId,
        COLUMN_EMAIL_2: email,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      print("Inserted participant, rows affected: $rowsAffected");
      return rowsAffected > 0;
    } catch (e) {
      print("Error inserting participant: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getParticipantsByEvent(int eventID) async {
    try {
      final db = await getDB();
      final participants = db.query(
        TABLE_NAME_2,
        where: "$COLUMN_EVENT_ID_2=?",
        whereArgs: [eventID],
      );
      print("Participants for event $eventID: $participants");
      return participants;
    } catch (e) {
      print("Error fetching participants: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getParticipantById(int id) async {
    try {
      final db = await getDB();
      final participants = await db.query(
        TABLE_NAME_2,
        where: '$COLUMN_ID_2 = ?',
        whereArgs: [id],
      );
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
  }) async {
    try {
      final db = await getDB();
      final rowsAffected = await db.update(
        TABLE_NAME_2,
        {
          COLUMN_NAME_2: name,
          COLUMN_EVENT_ID_2: eventId,
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

  //CRUD for attendance
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

  Future<List<Map<String, dynamic>>> getAttendanceByEvent(int eventId) async {
    try {
      final db = await getDB();
      final attendance = await db.query(
        TABLE_NAME_3,
        where: '$COLUMN_EVENT_ID_3 = ?',
        whereArgs: [eventId],
      );
      print("Attendance for event $eventId: $attendance");
      return attendance;
    } catch (e) {
      print("Error fetching attendance: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getAttendanceById(int id) async {
    try {
      final db = await getDB();
      final attendance = await db.query(
        TABLE_NAME_3,
        where: '$COLUMN_ID_3 = ?',
        whereArgs: [id],
      );
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
}
