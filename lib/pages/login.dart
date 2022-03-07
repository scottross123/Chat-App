import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool _loading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading ? Loading() : Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: email,
                validator: (String? text) {
                  if (text == null || text.isEmpty)
                    return "You can't leave this field blank!";
                  else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                .hasMatch(text))
                    return "That is not a valid email address!";
                  return null;
                },
                
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  hintText: "Email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              
              TextFormField(
                controller: password,
                obscureText: true,
                validator: (String? text) {
                  if (text == null || text.length < 8)
                    return "Your password must be at least 8 characters!";
                  return null;
                },

                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key),
                  hintText: "Password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),

              ElevatedButton(onPressed: () {
                _loading = true;
                login(context);
              }, child: const Text("Log In"),),

              ElevatedButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const RegisterPage()));    
              }, child: const Text("Register"),),

              ElevatedButton(onPressed: () {}, child: const Text("Sign in with Google"),),

            ],
          )
        )
      )
    );
  }

  void login(BuildContext context) async {
    if(_formKey.currentState!.validate()) {
      try {
        await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const HomePage(title: '',)));
        _loading = false;
      } on FirebaseAuthException catch(e) {
        if(e.code == "wrong-email" || e.code == "wrong-password")
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect login information!!!")));
      } catch(e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
  
}