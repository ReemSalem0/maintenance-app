import 'dart:convert';
import 'dart:io';
import 'package:maintenance_app/models/attachment.dart';
import 'package:maintenance_app/services/attachment_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAttachmentStorage implements AttachmentStorage {
  static const String _key = 'localAttachments';

  Future<List<Attachment>> _readAll() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored == null) {
      return [];
    }
    final decoded = jsonDecode(stored) as List;
    return decoded
        .map((item) => Attachment.fromLocalMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeAll(List<Attachment> all) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(all.map((a) => a.toLocalMap()).toList());
    await prefs.setString(_key, encoded);
  }

  @override
  Future<void> deleteAllFor(
    AttachmentOwnerType ownerType,
    String ownerId,
  ) async {
    final items = await list(ownerType, ownerId);
    for (final a in items) {
      await delete(a);
    }
  }

  @override
  Future<List<Attachment>> list(
    AttachmentOwnerType ownerType,
    String ownerId,
  ) async {
    final all = await _readAll();
    final result = all
        .where((a) => a.ownerType == ownerType && a.ownerId == ownerId)
        .toList();
    result.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return result;
  }

  @override
  Future<void> delete(Attachment attachment) async {
    final File file = File(attachment.path);
    if (await file.exists()) {
      await file.delete();
    }
    final all = await _readAll();
    all.removeWhere((a) => a.id == attachment.id);
    await _writeAll(all);
  }

  @override
  Future<Attachment> add({
    required String addedByName,
    required String addedByUid,
    required AttachmentKind kind,
    required String name,
    required String ownerId,
    required AttachmentOwnerType ownerType,
    required String sourcePath,
  }) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    String extension = '';
    if (name.contains('.')) {
      extension = name.substring(name.lastIndexOf('.'));

      if (extension.contains('/') || extension.contains('\\')) {
        extension = '';
      }
    }

    final docDir = await getApplicationDocumentsDirectory();
    final attachmentsDir = Directory('${docDir.path}/attachments');
    if (!await attachmentsDir.exists()) {
      await attachmentsDir.create(recursive: true);
    }

    final storedPath = '${attachmentsDir.path}/$id$extension';
    await File(sourcePath).copy(storedPath);

    final attachment = Attachment(
      id: id,
      ownerType: ownerType,
      ownerId: ownerId,
      name: name,
      path: storedPath,
      kind: kind,
      addedByUid: addedByUid,
      addedByName: addedByName,
      addedAt: DateTime.now(),
    );

    final all = await _readAll();
    all.add(attachment);
    await _writeAll(all);
    return attachment;
  }
}
