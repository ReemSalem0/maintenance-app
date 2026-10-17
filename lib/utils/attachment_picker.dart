import 'package:file_selector/file_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/attachment.dart';
import 'package:maintenance_app/services/attachment_storage.dart';
import 'package:maintenance_app/services/firestore_service.dart';

Future<bool> pickAndAttach(
  BuildContext context,
  AttachmentOwnerType ownerType,
  String ownerId,
) async {
  final String? result = await showModalBottomSheet<String>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: Text(AppLocalizations.of(context)!.takePhoto),
            onTap: () {
              Navigator.pop(context, 'camera');
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(AppLocalizations.of(context)!.chooseFromGallery),
            onTap: () {
              Navigator.pop(context, 'gallery');
            },
          ),
          ListTile(
            leading: const Icon(Icons.insert_drive_file_outlined),
            title: Text(AppLocalizations.of(context)!.chooseFile),
            onTap: () {
              Navigator.pop(context, 'file');
            },
          ),
        ],
      ),
    ),
  );
  if (result == null) {
    return false;
  } else if (result == 'camera') {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file == null) return false;
    return _saveAttachment(file, AttachmentKind.photo, ownerType, ownerId);
  } else if (result == 'gallery') {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return false;
    return _saveAttachment(file, AttachmentKind.photo, ownerType, ownerId);
  } else if (result == 'file') {
    final file = await openFile();
    if (file == null) return false;
    return _saveAttachment(file, AttachmentKind.document, ownerType, ownerId);
  }
  return false;
}

Future<bool> _saveAttachment(
  XFile file,
  AttachmentKind kind,
  AttachmentOwnerType ownerType,
  String ownerId,
) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return false;
  final crewMember = await FirestoreService().getCrewMember(currentUser.uid);
  if (crewMember == null) return false;

  await attachmentStorage.add(
    ownerType: ownerType,
    ownerId: ownerId,
    sourcePath: file.path,
    name: file.name,
    kind: kind,
    addedByUid: crewMember.uid,
    addedByName: crewMember.name,
  );
  return true;
}
