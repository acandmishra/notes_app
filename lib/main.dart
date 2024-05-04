import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/firebase_options.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    )
    );
}

class HomePage extends StatelessWidget {
  const HomePage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title:const Text("Home Page"),
          backgroundColor: const Color.fromARGB(255, 159, 193, 210),
        ),
      body: FutureBuilder(
        future:Firebase.initializeApp(
            options:DefaultFirebaseOptions.currentPlatform,
          ),
        builder:(context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
              final user=(FirebaseAuth.instance.currentUser);
              if (user?.emailVerified??false){ //we can also use == false instead of ?? false.
                print("Email is Verified");
              }else {
                print("Please verify your email");
              }
              return const Text("Done",);
          default:
            return const Text("Loading...");
          }
        },
      ),
      );
  }
}





