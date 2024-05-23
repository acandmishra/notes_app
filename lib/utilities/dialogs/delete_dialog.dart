import 'package:flutter/material.dart';
import 'package:notes_app/utilities/dialogs/generic_dialogs.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete Note",
    content: "Are you sure you want to delete this note ?",
    optionBuilder: () => {
      "Cancel": false,
      "Delete": true,
    },
  ).then((value) => value ?? false);
}
