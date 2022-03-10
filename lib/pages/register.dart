import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _Register();
}

class _Register extends State<RegisterPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool _loading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register an account!")),
      body: _loading ? Loading() : Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: username,
              validator: (String? text) {
                if (text == null || text.isEmpty)
                  return "You can't leave this field blank!";
                else if (DatabaseService.displayNames.contains(text))
                  return "Username already exists!!! Pick a different one.";
                return null;
              },

              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: "Username",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),

            TextFormField(controller: email,
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

            TextFormField(
              obscureText: true,
              validator: (String? text) {
                if (text == null || text.length < 8)
                  return "Your password must be at least 8 characters!";
                else if (text != password.text) {
                  return "Your passwords don't match!!!";
                }
                return null;
              },

              decoration: InputDecoration(
                prefixIcon: Icon(Icons.key),
                hintText: "Confirm Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),

            ElevatedButton(onPressed: () {
              setState(() {
                _loading = true;
                register(context);
              });
            }, 
            child: const Text("Register"),)
          ],
        )
      )
    ));
  }

  void register(BuildContext context) async {
    if(_formKey.currentState!.validate()) {
      try {
        await auth.createUserWithEmailAndPassword(email: email.text, password: password.text);
        _loading = false;
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginPage()));
      } on FirebaseAuthException catch(e) {
        if(e.code == "no-email" || e.code == "wrong-password")
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect register information!!!")));
      } catch(e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    try {
      if (auth.currentUser != null) {
        await db.collection("users").doc(auth.currentUser!.uid).set(
          {
            "display_name": username.text,
            "role": "USER",
            "email": email.text 
          }
        );
      }
    } on FirebaseException catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "Some error occured!! What did you do?!")));
    }
  }
}

