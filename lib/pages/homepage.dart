
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {

        if (_auth.currentUser == null)  {
          return const LoginPage();
        } else {
          return Scaffold(
            body: Container(
              child: Center(child: Text("Chat")),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.grey.shade600,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: "Chats",
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.group_work),
                  label: "Channels",
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box),
                  label: "Profile",
                ),
              ],
            ),
          );
        }
      }
    );
  }
}