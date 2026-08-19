import 'package:cloud_firestore/cloud_firestore.dart';

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
  final MaintenanceType type;
  final String description;
  final String? notes;
  final DateTime dateTime;

  MaintenanceRecord({
    required this.id,
    required this.rideId,
    required this.crewMemberUid,
    required this.crewMemberName,
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
      type: MaintenanceType.values.byName(map['type']),
      description: map['description'],
      notes: map['notes'],
      dateTime: (map['dateTime'] as Timestamp).toDate(),
    );
  }
}
