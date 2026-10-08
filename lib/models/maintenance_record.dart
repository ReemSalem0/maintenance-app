import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_app/models/crew_member.dart';

enum MaintenanceType {
  inspection,
  repair,
  routineMaintenance,
  partReplacement,
  other,
}

class MaintenanceRecord {
  final String id;
  final String rideId;
  final String crewMemberUid;
  final String crewMemberName;
  final CrewRole crewMemberRole;
  final MaintenanceType type;
  final String description;
  final String? notes;
  final DateTime dateTime;

  MaintenanceRecord({
    required this.id,
    required this.rideId,
    required this.crewMemberUid,
    required this.crewMemberName,
    required this.crewMemberRole,
    required this.type,
    required this.description,
    this.notes,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rideId': rideId,
      'crewMemberUid': crewMemberUid,
      'crewMemberName': crewMemberName,
      'crewMemberRole': crewMemberRole.name,
      'type': type.name,
      'description': description,
      'notes': notes,
      'dateTime': Timestamp.fromDate(dateTime),
    };
  }

  factory MaintenanceRecord.fromMap(Map<String, dynamic> map) {
    return MaintenanceRecord(
      id: map['id'],
      rideId: map['rideId'],
      crewMemberUid: map['crewMemberUid'],
      crewMemberName: map['crewMemberName'],
      crewMemberRole: CrewRole.values.byName(map['crewMemberRole']),
      type: MaintenanceType.values.byName(map['type']),
      description: map['description'],
      notes: map['notes'],
      dateTime: (map['dateTime'] as Timestamp).toDate(),
    );
  }

  //For local storage
  Map<String, dynamic> toLocalMap() {
    return {
      'id': id,
      'rideId': rideId,
      'crewMemberUid': crewMemberUid,
      'crewMemberName': crewMemberName,
      'crewMemberRole': crewMemberRole.name,
      'type': type.name,
      'description': description,
      'notes': notes,
      'dateTime': dateTime.toIso8601String(), //JSON safe string
    };
  }

  factory MaintenanceRecord.fromLocalMap(Map<String, dynamic> map) {
    return MaintenanceRecord(
      id: map['id'],
      rideId: map['rideId'],
      crewMemberUid: map['crewMemberUid'],
      crewMemberName: map['crewMemberName'],
      crewMemberRole: CrewRole.values.byName(map['crewMemberRole']),
      type: MaintenanceType.values.byName(map['type']),
      description: map['description'],
      notes: map['notes'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
