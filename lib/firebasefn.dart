import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';

class UserDetails {
  //Credential crd;
  // late BuildContext context;
  late final FirebaseAuth auth;
  UserDetails() {
    auth = FirebaseAuth.instance;
    // this.context = context;
  }

  bool success = false;
  String userEmail = '';
  bool registered = false;
  var error = "failed";

  Future register({required email, required password}) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credential.user != null ? registered = true : registered = false;
    } on FirebaseAuthException catch (e) {
      error = e.toString();
      Vibration.vibrate();
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    //_auth.user == null ? registered = false : registered = true;

    //debugPrint("\n$registered\n");
  }

  Future signInWithEmailAndPassword(
      {required email, required password, required context}) async {
    try {
      final User? user = (await auth.signInWithEmailAndPassword(
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
          prefs.setString('useremail', email);
          prefs.setString('userpass', password);
          debugPrint("helloworld");
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        success = false;
      }
    } on FirebaseAuthException catch (e) {
      Vibration.vibrate();
      error = e.toString();
      showSnack(error, context);
    } catch (e) {
      showSnack(e.toString(), context);
    }
  }

  void signout(BuildContext context) async {
    auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
    Future.delayed(Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('issignedin', false);
    prefs.setStringList('', []);
    showSnack("Signout successfull", context);
    //showAWDialog(context, DialogType.success,'Success!',"Your account has been registered successfully");
  }

  void forgotpass({required email, required context}) async{
    try {
      await auth.sendPasswordResetEmail(email: email.trim()).then((value) => showSnack("Check your email", context));
      
    } on FirebaseAuthException catch (e) {
      //var error;
      Vibration.vibrate();
      error = e.toString();
      showSnack(error, context);
    }
     catch (e) {
      showSnack(e.toString(), context);
    }
  }

  void showSnack(content, context) {
    var snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showAWDialog(context, dialogtype, title, content) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: dialogtype,
      title: title,
      desc: content,
      btnOkOnPress: () {},
    ).show();
  }
}
