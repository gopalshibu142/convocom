import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:convocom/global.dart';

class Home extends StatefulWidget {
  late UserDetails user;
  Home({super.key, required UserDetails user}) {
    this.user = user;
  }

  @override
  State<Home> createState() => _HomeState(user);
}

class _HomeState extends State<Home> {
  late UserDetails user;
  @override
  var usermail;
  _HomeState(user) {
    this.user = user;
  }
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            user.signout(context);
          },
        ),
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
