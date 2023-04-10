//import 'dart:html';

//import 'dart:js';

import 'dart:convert';

import 'package:convocom/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:quickalert/quickalert.dart';
//import 'firebase_real';

class UserDetails {
  //Credential crd;
  // late BuildContext context;
  late final FirebaseAuth auth;
  late final database;
  //late DatabaseReference userref;
  UserDetails() {
    auth = FirebaseAuth.instance;
    //  database = FirebaseDatabase.instance;
    //  userref = database.ref('users');

    // this.context = context;
  }

  bool success = false;
  String userEmail = '';
  bool registered = false;
  var error = "failed";

  Future register({required LoginDetails details, required context}) async {
    try {
      registered = false;

      final credential = await auth
          .createUserWithEmailAndPassword(
        email: details.email.control.text,
        password: details.pass.control.text,
      )
          .then((value) async {
        showSnack('Success', context);
        curuser = auth.currentUser!;
        auth.currentUser?.updateDisplayName(details.name.control.text);
        auth.currentUser?.updatePhoneNumber(
            details.phone.control.text as PhoneAuthCredential);
        auth.currentUser?.updateDisplayName(details.name.control.text);
        auth.signInWithEmailAndPassword(
          email: details.email.control.text,
          password: details.pass.control.text,
        );
      });

      credential.user != null ? registered = true : registered = false;
    } on FirebaseAuthException catch (e) {
      error = e.toString();
      Vibration.vibrate();
      showSnack(error, context);
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
    databaseReference.child('users').child(curuser.uid).set({
      'email': details.email.control.text,
      'name': details.name.control.text,
      'phone': details.phone.control.text,
      'dob': details.dob.text,
    });
    print({
      'name': details.name.control.text,
      'phone': details.phone.control.text,
      'dob': details.dob.text,
    });
  }

  Future signInWithEmailAndPassword(
      {required email, required password, required context}) async {
    try {
      QuickAlert.show(context: context, type: QuickAlertType.loading);
      final User? user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        success = true;
        userEmail = user.email.toString();
        curuser = user;
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
    QuickAlert.show(
      backgroundColor: Colors.black,
      context: context,
      type: QuickAlertType.confirm,
      animType: QuickAlertAnimType.slideInUp,
      //widget: Lottie.asset('assets/warning.json'),
      text: 'Do you want to logout',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,

      onConfirmBtnTap: () async {
        auth.signOut();
        Navigator.pushReplacementNamed(context, '/login');
        Future.delayed(Duration(seconds: 1));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('issignedin', false);
        prefs.setStringList('', []);
        showSnack("Signout successfull", context);
      },
    );

    //showAWDialog(context, DialogType.success,'Success!',"Your account has been registered successfully");
  }

  // void phonenocheck() {
  //   FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       timeout: const Duration(minutes: 2),
  //       verificationCompleted: (credential) async {
  //         await (await auth.currentUser())?.updatePhoneNumberCredential(credential);
  //         // either this occurs or the user needs to manually enter the SMS code
  //       },
  //       verificationFailed: null,
  //       codeSent: (verificationId, [forceResendingToken]) async {
  //         String smsCode;
  //         // get the SMS code from the user somehow (probably using a text field)
  //         final AuthCredential credential =
  //           PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: smsCode);
  //         await (await FirebaseAuth.instance.currentUser()).updatePhoneNumberCredential(credential);
  //       },
  //       codeAutoRetrievalTimeout: null);
  // }
  void forgotpass({required email, required context}) async {
    try {
      await auth
          .sendPasswordResetEmail(email: email.trim())
          .then((value) => showSnack("Check your email", context));
    } on FirebaseAuthException catch (e) {
      //var error;
      Vibration.vibrate();
      error = e.toString();
      showSnack(error, context);
    } catch (e) {
      showSnack(e.toString(), context);
    }
  }

  // void showAWDialog(context, dialogtype, title, content) {
  //   AwesomeDialog(
  //     context: context,
  //     animType: AnimType.scale,
  //     dialogType: dialogtype,
  //     title: title,
  //     desc: content,
  //     btnOkOnPress: () {},
  //   ).show();
  // }

  void createuser({required LoginDetails details, context}) async {
    try {
      // DatabaseReference ref = await userref.child("${auth.currentUser?.uid}");
      // await ref.set({
      //   'name': details.name.control.text,
      //   'email': details.email.control.text,
      //   'phone': details.phone.control.text,
      //   'dob': details.dob.text,
      // });
    } catch (e) {
      debugPrint(e.toString());
      //showSnack(e.toString(), context);
    }
  }

  void blash({context}) async {
    try {
      // DatabaseReference ref = database.ref("test");
      //ref.set({"ok": "ser"});
    } catch (e) {
      debugPrint(e.toString());
      showSnack(e.toString(), context);
    }
  }
}

void debugDB() {
  databaseReference.once().then((snapshot) {
    print('Data: ${snapshot.snapshot.value}');
  });
}

void addConncetion(String email, context) {
  try {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
    Query query =
        usersRef.orderByChild('email').equalTo(email);
    query.once().then((snap) {
      
      if (!snap.snapshot.exists ) {
        showSnack('User not found', context);
        print('object');
      } else {
        var value = snap.snapshot;
        showSnack('UserFOund', context);
        print(value.children.first.key);
      }
      
      // Do something with the results
    });
  } catch (r) {
    showSnack('User not found', context);
    print('object');
  }
}
