import 'package:cloud_firestore/cloud_firestore.dart';

enum AttachmentOwnerType { ride, record }

enum AttachmentKind { photo, document }

class Attachment {
  final String id;
  final AttachmentOwnerType ownerType;
  final String ownerId;
  final String name;
  final String path;
  final AttachmentKind kind;
  final String addedByUid;
  final String addedByName;
  final DateTime addedAt;

  Attachment({
    required this.id,
    required this.ownerType,
    required this.ownerId,
    required this.name,
    required this.path,
    required this.kind,
    required this.addedByUid,
    required this.addedByName,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerType': ownerType.name,
      'ownerId': ownerId,
      'name': name,
      'path': path,
      'kind': kind.name,
      'addedByUid': addedByUid,
      'addedByName': addedByName,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  factory Attachment.fromMap(Map<String, dynamic> map) {
    return Attachment(
      id: map['id'],
      ownerType: AttachmentOwnerType.values.byName(map['ownerType']),
      ownerId: map['ownerId'],
      name: map['name'],
      path: map['path'],
      kind: AttachmentKind.values.byName(map['kind']),
      addedByUid: map['addedByUid'],
      addedByName: map['addedByName'],
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }

  //For local storage (for demo version)
  Map<String, dynamic> toLocalMap() {
    return {
      'id': id,
      'ownerType': ownerType.name,
      'ownerId': ownerId,
      'name': name,
      'path': path,
      'kind': kind.name,
      'addedByUid': addedByUid,
      'addedByName': addedByName,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory Attachment.fromLocalMap(Map<String, dynamic> map) {
    return Attachment(
      id: map['id'],
      ownerType: AttachmentOwnerType.values.byName(map['ownerType']),
      ownerId: map['ownerId'],
      name: map['name'],
      path: map['path'],
      kind: AttachmentKind.values.byName(map['kind']),
      addedByUid: map['addedByUid'],
      addedByName: map['addedByName'],
      addedAt: DateTime.parse(map['addedAt']),
    );
  }
}
