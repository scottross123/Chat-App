import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'models/database_service.dart';
import 'pages/homepage.dart';
import 'pages/login.dart';

void main() {
  WidgetsFlutterBinding();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initializer = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<FirebaseApp>(future: _initializer, 
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if(snapshot.hasError) {
          return const Center(child: Text("oh no bro")); 
        }

        if(snapshot.connectionState == ConnectionState.done) {
          return const HomePage(title: "Flutter Demo bro");
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      }
      
      ),
    );
  }
}

