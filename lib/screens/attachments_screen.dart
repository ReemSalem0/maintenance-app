import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/attachment.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/services/attachment_storage.dart';
import 'package:maintenance_app/services/firestore_service.dart';
import 'package:maintenance_app/utils/attachment_picker.dart';

class AttachmentsScreen extends StatefulWidget {
  final AttachmentOwnerType ownerType;
  final String ownerId;

  const AttachmentsScreen({
    super.key,
    required this.ownerType,
    required this.ownerId,
  });

  @override
  State<AttachmentsScreen> createState() => _AttachmentsScreenState();
}

class _AttachmentsScreenState extends State<AttachmentsScreen> {
  List<Attachment> _attachments = [];
  CrewMember? _crewMember;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.attachments),
        actions: [
          IconButton(
            onPressed: () async {
              final added = await pickAndAttach(
                context,
                widget.ownerType,
                widget.ownerId,
              );
              if (added) await _load();
            },
            icon: const Icon(Icons.attach_file),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Text(
            AppLocalizations.of(context)!.attachmentsDemoNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (_attachments.isEmpty)
            Text(AppLocalizations.of(context)!.noAttachments),
          for (final a in _attachments) _attachmentTile(a),
        ],
      ),
    );
  }

  Widget _attachmentTile(Attachment a) {
    final isPhoto = a.kind == AttachmentKind.photo;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: isPhoto
          ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(
                File(a.path),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                cacheWidth: 96,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image_outlined, size: 40),
              ),
            )
          : const Icon(Icons.insert_drive_file_outlined, size: 40),
      title: Text(a.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${a.addedByName} ${DateFormat('dd/MM/yyyy HH:mm').format(a.addedAt)}',
      ),
      trailing: _canDelete(a)
          ? IconButton(
              onPressed: () => _confirmDelete(a),
              icon: const Icon(Icons.delete_outline),
            )
          : null,
      onTap: () {
        if (isPhoto) {
          _showPhoto(a);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.documentOpenUnavailable,
              ),
            ),
          );
        }
      },
    );
  }

  void _showPhoto(Attachment a) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          child: Image.file(
            File(a.path),
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image_outlined, size: 40),
          ),
        ),
      ),
    );
  }

  Future<void> _load() async {
    final items = await attachmentStorage.list(
      widget.ownerType,
      widget.ownerId,
    );
    if (!mounted) return;
    setState(() => _attachments = items);
  }

  Future<void> _loadCrewMember() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    final crewMember = await FirestoreService().getCrewMember(currentUser.uid);
    if (crewMember == null) return;
    if (!mounted) return;
    setState(() => _crewMember = crewMember);
  }

  bool _canDelete(Attachment a) {
    final me = _crewMember;
    if (me == null) return false;
    return a.addedByUid == me.uid || me.role == CrewRole.administrator;
  }

  Future<void> _confirmDelete(Attachment a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteAttachment),
          content: Text(
            AppLocalizations.of(context)!.deleteAttachmentConfirmation,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await attachmentStorage.delete(a);
      await _load();
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
    _loadCrewMember();
  }
}
