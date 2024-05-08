import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
        backgroundColor: Colors.green.shade100,
      ),
      body: Column(
        children: [
          const Text(
            "Email Verication has been sent to your registered email id , please open it to verify account.",
          ),
          const Text(
            "In case you hvaen't received email verification , please click below",
          ),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text("Verify Email"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // This is added because application is unable to refresh the applicatin state and shows verify email view even when the current user is null or the email is verified.
              // This happens because application uses the user locally available and is unable to sync with firebase
              // Therefore we added button to restart which signs out current user and takes us back to register view
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }
}
