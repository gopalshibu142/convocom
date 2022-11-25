import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UI {
  var backgrounds = ['assets/bg1.json', 'assets/bg2.json', 'assets/bg3.json'];
  //var colorlogin = [Colors.white, Colors.black];
  var background;
  late Color clrlog;
  late int rn;

  void changeBG() {
    rn++;
    if (rn > 2) rn = 0;
    this.background = backgrounds[rn];
    this.clrlog = rn == 0 ? Colors.white : Colors.black;
  }

  UI() {
    final _random = new Random();
    rn = _random.nextInt(backgrounds.length);
// generate a random index based on the list length
// and use it to retrieve the element
    this.background = backgrounds[rn];
    this.clrlog = rn == 0 ? Colors.white : Colors.black;
  }
}

class LoginDetails {
  LoginDetails() {
    loginemail = TextControl();
    loginpass = TextControl();

    name = TextControl();
    email = TextControl();
    pass = TextControl();
    phone = TextControl();
    dob = TextEditingController(text: " ");
    age = TextControl();
    code = TextEditingController();
  }
  late TextControl loginemail;
  late TextControl loginpass;

  late TextControl name;
  late TextControl email;
  late TextControl pass;
  late TextControl phone;
  late TextEditingController dob;
  late TextEditingController code;
  late TextControl age;

  void validSignin() {}
}

class TextControl {
  TextControl() {
    control = TextEditingController();
    validator = false;
  }
  late TextEditingController control;
  late bool validator;
}

class UserDetails {
  late BuildContext context;
  late final FirebaseAuth _auth;
  UserDetails(context) {
    _auth = FirebaseAuth.instance;
    this.context = context;
  }

  bool success = false;
  String userEmail = '';
  bool registered = false;
  var error = "failed";

  Future register({required email, required password}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credential.user != null ? registered = true : registered = false;
    } on FirebaseAuthException catch (e) {
      error = e.toString();
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    //_auth.user == null ? registered = false : registered = true;

    debugPrint("\n$registered\n");
  }

  Future signInWithEmailAndPassword({required email, required password}) async {
    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        success = true;
        userEmail = user.email.toString();
        if (success) {
           SharedPreferences prefs = await SharedPreferences.getInstance();
           prefs.setBool('issignedin', true);
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        success = false;
      }
    } on FirebaseAuthException catch (e) {
      error = e.toString();
    } catch (e) {
      print(e);
    }
  }

  void signout(BuildContext context) async{
    _auth.signOut();
    Navigator.pushReplacementNamed(context, '/');
    Future.delayed(Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('issignedin', false);
    showSnack("Signout successfull", context);
  }

  void showSnack(content, context) {
    var snackbar = SnackBar(
      content: const Text('Signed out successfully'),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
