import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_app/models/maintenance_record.dart';

class MaintenanceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addMaintenanceRecord(MaintenanceRecord maintenanceRecord) async {
    final docRef = _db.collection('maintenanceRecords').doc();
    final recordWithId = MaintenanceRecord(
      id: docRef.id,
      rideId: maintenanceRecord.rideId,
      crewMemberUid: maintenanceRecord.crewMemberUid,
      crewMemberName: maintenanceRecord.crewMemberName,
      type: maintenanceRecord.type,
      description: maintenanceRecord.description,
      notes: maintenanceRecord.notes,
      dateTime: maintenanceRecord.dateTime,
    );
    await docRef.set(recordWithId.toMap());
  }

  Stream<List<MaintenanceRecord>> getMaintenanceRecordsForRide(String rideId) {
    return _db
        .collection('maintenanceRecords')
        .where('rideId', isEqualTo: rideId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MaintenanceRecord.fromMap(doc.data()))
              .toList();
        });
  }
}
