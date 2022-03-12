import 'package:flutter/material.dart';
import 'package:chat_app/services/authentication.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), backgroundColor: Colors.black),
      body: Container(
          child: Center(
        child: OutlinedButton(
            style: TextButton.styleFrom(
            primary: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 26.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),),
            child: Text('Sign in with Google'),
            onPressed: Authentication.handleLogin,
        ),
      )),
    );
  }
}
