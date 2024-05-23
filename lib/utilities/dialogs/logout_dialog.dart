import 'package:flutter/material.dart';
import 'package:notes_app/utilities/dialogs/generic_dialogs.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Log Out",
    content: "Are you sure you want to log out ?",
    optionBuilder: () => {
      "Cancel": false,
      "Log Out": true,
    },
  ).then((value) => value ?? false);
}
