import 'dart:convert';
import 'package:maintenance_app/models/maintenance_record.dart';
import 'package:maintenance_app/services/maintenance_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingRecordsService {
  static const String _key = 'pendingMaintenanceRecords';

  Future<void> addPendingRecord(MaintenanceRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getPendingRecords();
    existing.add(record);
    final encoded = jsonEncode(existing.map((r) => r.toLocalMap()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<List<MaintenanceRecord>> getPendingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored == null) {
      return [];
    }
    final decoded = jsonDecode(stored) as List;
    return decoded
        .map(
          (item) =>
              MaintenanceRecord.fromLocalMap(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> removePendingRecord(MaintenanceRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getPendingRecords();
    existing.removeWhere((r) => r.id == record.id);
    final encoded = jsonEncode(existing.map((r) => r.toLocalMap()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<void> syncAllPending() async {
    final pending = await getPendingRecords();
    final maintenanceService = MaintenanceService();

    final results = await Future.wait(
      pending.map((record) async {
        try {
          await maintenanceService.addMaintenanceRecord(record);
          return record;
        } catch (e) {
          // still offline or failed - leave it and try again next time
          return null;
        }
      }),
    );

    final successfullySynced = results.whereType<MaintenanceRecord>().toSet();

    if (successfullySynced.isEmpty) {
      return;
    }

    final stillPending = pending
        .where((record) => !successfullySynced.contains(record))
        .toList();

    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      stillPending.map((r) => r.toLocalMap()).toList(),
    );
    await prefs.setString(_key, encoded);
  }
}
