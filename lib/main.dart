import 'package:convocom/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'screens/Home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseAppCheck.instance.useEmulator("10.0.2.2", 9099);
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({super.key});

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  late UserDetails user;
  @override
  void initState() {
    super.initState();
    user = UserDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "convocom : let's blaber",
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Login(user: user,),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => Home(user: user,),
      },
    );
  }
}
