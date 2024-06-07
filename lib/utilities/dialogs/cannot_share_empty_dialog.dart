import 'package:flutter/material.dart';
import 'package:notes_app/utilities/dialogs/generic_dialogs.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Sharing",
    content: "Can't share an empty note",
    optionBuilder: () => {
      "OK": null,
    },
  );
}
