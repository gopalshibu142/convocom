import 'package:flutter/material.dart';
import 'screens/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "convocom : let's blaber",
      home: Login(),
      theme: ThemeData.dark(),
    );
  }
}
