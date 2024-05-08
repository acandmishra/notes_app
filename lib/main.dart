import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/firebase_options.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = (FirebaseAuth.instance.currentUser);
            if (user != null) {
              if (user.emailVerified == true) {
                devtools.log("Email is verified");
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Notes"),
          backgroundColor: const Color.fromARGB(255, 253, 97, 128),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case (MenuAction.logout):
                    // we are awaiting to let use click any button in the dialog box
                    final shouldLogout = await showLogOutDialog(context);
                    devtools.log(shouldLogout.toString());
                    if (shouldLogout) {
                      await FirebaseAuth.instance.signOut();
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
      body: const Text("Hello World"),
    );
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
