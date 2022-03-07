import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
          return const MyHomePage(title: "Flutter Demo bro");
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      }
      
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {

        if (snapshot.data == null)  {
          return const LoginPage();
        } else {
          return const Scaffold(body: Text("bruh"),);
        }
      }
    );
  }
}