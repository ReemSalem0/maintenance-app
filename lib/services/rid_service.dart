import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_app/models/ride.dart';

class RideService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addRide(Ride ride) async {
    final docRef = _db
        .collection('rides')
        .doc(); // generates a new empty doc reference with an ID, but doesn't save yet
    final rideWithId = Ride(
      id: docRef.id,
      name: ride.name,
      description: ride.description,
      location: ride.location,
      status: ride.status,
      notes: ride.notes,
      createdAt: ride.createdAt,
    );
    await docRef.set(rideWithId.toMap());
  }

  Stream<List<Ride>> getAllRidesStream() {
    return _db.collection('rides').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Ride.fromMap(doc.data())).toList();
    });
  }
}
