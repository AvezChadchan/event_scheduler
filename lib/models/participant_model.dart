import 'package:event_scheduler/data/local/db_helper.dart';

class ParticipantModel {
final int? id;
final String name;
final int eventId;
final String? groupName;
final String email;

ParticipantModel({
this.id,
required this.name,
required this.eventId,
this.groupName,
required this.email,
});

factory ParticipantModel.fromMap(Map<String, dynamic> map) {
return ParticipantModel(
id: map[DBHelper.COLUMN_ID_2] as int?,
name: map[DBHelper.COLUMN_NAME_2] as String,
eventId: map[DBHelper.COLUMN_EVENT_ID_2] as int,
groupName: map[DBHelper.COLUMN_GROUP] as String?,
email: map[DBHelper.COLUMN_EMAIL_2] as String,
);
}

Map<String, dynamic> toMap() {
return {
DBHelper.COLUMN_ID_2: id,
DBHelper.COLUMN_NAME_2: name,
DBHelper.COLUMN_EVENT_ID_2: eventId,
DBHelper.COLUMN_GROUP: groupName,
DBHelper.COLUMN_EMAIL_2: email,
};
}

@override
String toString() {
return 'ParticipantModel(id: $id, name: $name, eventId: $eventId, groupName: $groupName, email: $email)';
}
}