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
      routes: {
        "/login/": (context)=> const LoginView(),
        "/register/": (context)=> const RegisterView(),
      }
    )
    );
}

class HomePage extends StatelessWidget {
  const HomePage ({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:Firebase.initializeApp(
            options:DefaultFirebaseOptions.currentPlatform,
          ),
        builder:(context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
              // final user=(FirebaseAuth.instance.currentUser);
              // if (user?.emailVerified??false){ 
              // }else {
              //   return VerifyEmailView();
              // }
              // return const Text("Done",);
              return const LoginView();
          default:
            return const CircularProgressIndicator();
          }
        },
      );
  }
}


