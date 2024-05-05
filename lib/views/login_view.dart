import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/views/register_view.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  
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
        title: const Text("Log in"),
        backgroundColor: Color.fromARGB(255, 255, 36, 153),
      ),
      body: Column(
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
                          final userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        print("-----------------> $userCredential");
                        } on FirebaseAuthException catch (e){
                          print(":********************:ERROR OCCURED HERE:********************:");
                          if (e.code == "user-not-found"){
                            print("User Not Found!!");
                          } else if (e.code=="wrong-password"){
                            print("Password is wrong");
                          } else if (e.code=="invalid-email"){
                            print("Invalid email entered");
                          }
                        }
                        
                      },
                      child:const Text("Log in"),
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil("/register/", (route) => false);
                      },
                      child: const Text("Not register? Register here!"),
                    ),
                  ],
            ),
    );
  }

}