import 'package:flutter/material.dart';
import 'package:notes_app/services/cloud/cloud_note.dart';
import 'package:notes_app/utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final NoteCallBack onDeleteNote;
  final Iterable<CloudNote> notes;
  final NoteCallBack onTap;

  const NotesListView({
    super.key,
    required this.onDeleteNote,
    required this.notes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
