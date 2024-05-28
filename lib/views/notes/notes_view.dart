import 'package:flutter/material.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/enums/menu_action.dart';
import 'dart:developer' as devtools show log;
import 'package:notes_app/utilities/dialogs/logout_dialog.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/crud/notes_service.dart';
import 'package:notes_app/views/notes/create_update_note_view.dart';
import 'package:notes_app/views/notes/notes_list_view.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Notes"),
            backgroundColor: const Color.fromARGB(255, 253, 97, 128),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createUpdateNoteRoute);
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
                      // implicit fall through is done here
                      // the waiting case falls through to the active case in which widget is returned
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allNotes = snapshot.data as List<DatabaseNote>;
                          return NotesListView(
                            onDeleteNote: (note) async {
                              _notesService.deleteNote(id: note.id);
                            },
                            notes: allNotes,
                            onTap: (note) {
                              Navigator.of(context).pushNamed(
                                createUpdateNoteRoute,
                                arguments: note,
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
