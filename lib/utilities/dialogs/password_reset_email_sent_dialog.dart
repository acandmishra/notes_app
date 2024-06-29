import 'package:flutter/material.dart';
import 'package:notes_app/extensions/buildcontext/loc.dart';
import 'package:notes_app/utilities/dialogs/generic_dialogs.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: context.loc.password_reset,
    content: context.loc.password_reset_dialog_prompt,
    optionBuilder: () => {
      context.loc.ok: null,
    },
  );
}
