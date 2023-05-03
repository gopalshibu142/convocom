import 'dart:async';

import 'package:convocom/global.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'loginpage.dart';
import 'Home.dart';
import 'package:flutter/material.dart';
import 'package:convocom/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:convocom/firebasefn.dart';
import 'package:convocom/firebasefn.dart';
import 'package:flutter_background/flutter_background.dart';

class SplashFuturePage extends StatefulWidget {
  SplashFuturePage({Key? key}) : super(key: key);

  @override
  _SplashFuturePageState createState() => _SplashFuturePageState();
}

class _SplashFuturePageState extends State<SplashFuturePage> {
  @override
  void initState() {
    //FlutterBackgroundAndroidConfig

    super.initState();
  }

  late UserDetails user;
  late bool? signed;
  late FirebaseAuth auth;
  var email;
  var pass;
  Future<Widget> futureCallLogin() async {
    // do async operation ( api call, auto login)

    user = UserDetails();
    auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var prefs =await  SharedPreferences.getInstance();
    themeno = prefs.containsKey('theme') ? prefs.getInt('theme') ?? 0 : 0;
    await Future.delayed(Duration(seconds: 1));
    getTheme(themeno);
    signed = prefs.getBool('issignedin');
    if (signed == true) {
      email = prefs.getString('useremail');
      pass = prefs.getString('userpass');
      user_ID = prefs.getString('user_ID') ?? 'null';
      user.signInWithEmailAndPassword(
          email: email, password: pass, context: context);

      if (auth.currentUser != null)
        return Future.value(Home(
          user: user,
        ));
      else
        return Future.value(Login(
          user: user,
        ));
    } else {
      return Future.value(Login(
        user: user,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      
      logo: Image.asset('assets/logoconvocom.png'),
      title: Text("CONVOCOM",
          style:
              GoogleFonts.permanentMarker(color: Colors.white, fontSize: 38)),
      backgroundColor: Colors.black,
      showLoader: true,
      loadingText: Text("Loading..."),
      futureNavigator: futureCallLogin(),
      durationInSeconds: 2,
      loaderColor: Colors.red,
    );
  }
}
