import 'package:flutter/material.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/enums/menu_action.dart';
import 'dart:developer' as devtools show log;

import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/crud/notes_service.dart';
import 'package:notes_app/views/notes/new_note_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // created avariable to handle the NotesService object
  late final NotesService _notesService;

  // Getting the user email from the getter of the Firebase_provider_which gives us the email field in the AuthUser
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Notes"),
            backgroundColor: const Color.fromARGB(255, 253, 97, 128),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(newNoteRoute);
                },
                icon: const Icon(Icons.add),
              ),
              PopupMenuButton<MenuAction>(
                onSelected: (value) async {
                  switch (value) {
                    case (MenuAction.logout):
                      // we are awaiting to let use click any button in the dialog box
                      final shouldLogout = await showLogOutDialog(context);
                      devtools.log(shouldLogout.toString());
                      if (shouldLogout) {
                        await AuthService.firebase().logOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                      }
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text("Logout"),
                    ),
                  ];
                },
              ),
            ]),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text("Waiting for Notes...");
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  // This function is a Future because we will be waiting for user to press any one of the button (cancel/log out) or select none
  // based on what is pressed action will be performed
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Alert"),
        content: const Text("Do you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
  // This .then() functions says that , it will grab the value being returned by the function it is applied to and will check if the value is null or not ,
  // if the value is not null it will return the function's value else it will return false
}
