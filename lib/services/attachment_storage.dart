import 'package:maintenance_app/models/attachment.dart';
import 'package:maintenance_app/services/local_attachment_storage.dart';

abstract class AttachmentStorage {
  Future<Attachment> add({
    required AttachmentOwnerType ownerType,
    required String ownerId,
    required String sourcePath,
    required String name,
    required AttachmentKind kind,
    required String addedByUid,
    required String addedByName,
  });

  Future<List<Attachment>> list(AttachmentOwnerType ownerType, String ownerId);

  Future<void> delete(Attachment attachment);
}

//The following line will be changed when the google drive or firebase storage debate is settled 
final AttachmentStorage attachmentStorage = LocalAttachmentStorage();