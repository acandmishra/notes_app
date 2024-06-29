import 'package:flutter/material.dart';
import 'package:notes_app/extensions/buildcontext/loc.dart';
import 'package:notes_app/utilities/dialogs/generic_dialogs.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.delete,
    content: context.loc.delete_note_prompt,
    optionBuilder: () => {
      context.loc.cancel: false,
      context.loc.yes: true,
    },
  ).then((value) => value ?? false);
}
