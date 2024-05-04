import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState(){
    _email=TextEditingController();
    _password=TextEditingController();
    super.initState();
  }

  @override
  void dispose(){
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text("Register"),
        backgroundColor: const Color.fromARGB(255, 159, 193, 210),
      ),
      body: FutureBuilder(
        future:Firebase.initializeApp(
                  options:DefaultFirebaseOptions.currentPlatform,
                ),
        builder:(context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration:const InputDecoration(
                      hintText:"Email ID"
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect:false,
                    decoration:const InputDecoration(
                      hintText:"Password",
                    ),
                  ),
                  TextButton(
                    onPressed:() async{          
                      final email =_email.text;
                      final password =_password.text;
                      try{
                        final userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      print("-----------------> $userCredential");
                      } on FirebaseAuthException catch(e){
                        if (e.code=="weak-password"){
                          print("You have weak password: min 6 characters!!");
                        } else if (e.code=="email-already-in-use"){
                          print("Email already in use");
                        } else if (e.code=="invalid-email"){
                          print("Invalid Email!!");
                        }
                      }
                      
                      
                    },
                    child:const Text("Register"),
                  ),
                ],
          );
          default:
            return const Text("Loading...");
          }
          
        },
      ),
      );
  }
}