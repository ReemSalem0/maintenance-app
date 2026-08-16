import 'package:cloud_firestore/cloud_firestore.dart';

enum RideStatus { operational, underMaintenance, outOfService }

class Ride {
  final String id;
  final String name;
  final String description;
  final String? location;
  final RideStatus status;
  final String? notes;
  final DateTime createdAt;

  Ride({
    required this.id,
    required this.name,
    required this.description,
    this.location,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'status': status.name,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Ride.fromMap(Map<String, dynamic> map) {
    return Ride(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      location: map['location'],
      status: RideStatus.values.byName(map['status']),
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
