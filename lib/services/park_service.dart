import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_app/models/park.dart';

class ParkService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addPark(Park park) async {
    final docRef = _db.collection('parks').doc();
    final parkWithId = Park(id: docRef.id, name: park.name);
    await docRef.set(parkWithId.toMap());
  }

  Stream<List<Park>> getAllParksStream() {
    return _db.collection('parks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Park.fromMap(doc.data())).toList();
    });
  }

  Stream<Park> getParkStream(String parkId) {
    return _db.collection('parks').doc(parkId).snapshots().map((doc) {
      return Park.fromMap(doc.data()!);
    });
  }
}
