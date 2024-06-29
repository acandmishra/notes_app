import 'package:flutter/material.dart';
import 'package:notes_app/extensions/buildcontext/loc.dart';
import 'package:notes_app/utilities/dialogs/generic_dialogs.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.logout_button,
    content: context.loc.logout_dialog_prompt,
    optionBuilder: () => {
      context.loc.cancel: false,
      context.loc.logout_button: true,
    },
  ).then((value) => value ?? false);
}
