import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convocom/global.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final FirebaseAuth _auth;
  @override
  var usermail;
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    usermail = _auth.currentUser?.email?? " ";
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //leading: IconButton(),
          ),
      body: Center(
        child: Container(
          color: Colors.black45,
          child: Text("${usermail}"),
        ),
      ),
    );
  }
}
