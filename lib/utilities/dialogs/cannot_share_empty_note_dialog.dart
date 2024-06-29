import 'package:flutter/material.dart';
import 'package:notes_app/extensions/buildcontext/loc.dart';
import 'package:notes_app/utilities/dialogs/generic_dialogs.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.sharing,
    content: context.loc.cannot_share_empty_note_prompt,
    optionBuilder: () => {
      context.loc.ok: null,
    },
  );
}
