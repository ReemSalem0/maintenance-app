import 'package:flutter/material.dart';
import 'package:maintenance_app/l10n/app_localizations.dart';
import 'package:maintenance_app/models/attachment.dart';
import 'package:maintenance_app/screens/attachments_screen.dart';
import 'package:maintenance_app/services/attachment_storage.dart';
import 'package:maintenance_app/utils/attachment_picker.dart';

class RecordAttachmentRows extends StatefulWidget {
  final String recordId;

  const RecordAttachmentRows({super.key, required this.recordId});

  @override
  State<RecordAttachmentRows> createState() => _RecordAttachmentRowsState();
}

class _RecordAttachmentRowsState extends State<RecordAttachmentRows> {
  int _attachmentCount = 0;

  Future<void> _refreshAttachmentCount() async {
    final items = await attachmentStorage.list(
      AttachmentOwnerType.record,
      widget.recordId,
    );
    if (!mounted) return;
    setState(() => _attachmentCount = items.length);
  }

  @override
  void initState() {
    super.initState();
    _refreshAttachmentCount();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.attach_file_outlined),
          title: Text(AppLocalizations.of(context)!.attachFiles),
          onTap: () async {
            await pickAndAttach(
              context,
              AttachmentOwnerType.record,
              widget.recordId,
            );
            _refreshAttachmentCount();
          },
        ),
        if (_attachmentCount > 0)
          ListTile(
            leading: const Icon(Icons.file_present_outlined),
            title: Text(AppLocalizations.of(context)!.attachments),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttachmentsScreen(
                    ownerType: AttachmentOwnerType.record,
                    ownerId: widget.recordId,
                  ),
                ),
              );
              _refreshAttachmentCount();
            },
          ),
      ],
    );
  }
}
