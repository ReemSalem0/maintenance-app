import 'package:cloud_firestore/cloud_firestore.dart';

enum RideStatus { operational, underMaintenance, outOfService, retired }

class Ride {
  final String id;
  final String name;
  final String description;
  final RideStatus status;
  final String? notes;
  final DateTime createdAt;
  final String parkId;

  Ride({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.parkId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.name,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'parkId': parkId,
    };
  }

  factory Ride.fromMap(Map<String, dynamic> map) {
    return Ride(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      status: RideStatus.values.byName(map['status']),
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      parkId: map['parkId'],
    );
  }
}
