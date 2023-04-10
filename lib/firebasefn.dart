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
import 'package:cloud_firestore/cloud_firestore.dart' as store;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

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

void addConncetion(String email, context) async {
  try {
    databaseReference.child('test2').set({});
    bool haschild = false;
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
    Query query = usersRef.orderByChild('email').equalTo(email);
    query.once().then((snap) async {
      if (!snap.snapshot.exists) {
        showSnack('User not found', context);
        print('object');
      } else {
        var value = snap.snapshot;
        databaseReference.child('users').child('people').once().then((snap) {
          haschild =
              snap.snapshot.hasChild(value.children.first.key.toString());
          print(haschild);
          print(snap.snapshot.children);
        });
        if (!haschild) {
          showSnack(
              " ${value.children.first.child('name').value} has been added",
              context);
          print(value.children.first.key);
          var con_name = randomString();
          await FirebaseDatabase.instance
              .ref()
              .child('connections')
              .update({con_name: 'active'});
          await databaseReference
              .child('users')
              .child(curuser.uid)
              .child('people')
              .update({value.children.first.key.toString(): con_name});
          await databaseReference
              .child('users')
              .child(value.children.first.key.toString())
              .child('people')
              .update({curuser.uid: con_name}).then((rec) {
            print('object');
          });
          cloud.collection(con_name).add({});
        } else {
          showSnack(
              "User name: ${value.children.first.child('name').value} already added",
              context);
        }
      }

      // Do something with the results
    });
  } catch (r) {
    showSnack('User not found', context);
    print('object');
  }
}

Future<List> getPeoplelist() async {
  // print('called');
  List people = [];
  List peopleID = [];
  List msgID = [];
  mapname_id = {};
  await databaseReference
      .child('users')
      .child(curuser.uid)
      .child('people')
      .once()
      .then((value) {
    value.snapshot.children.forEach((element) {
      // print(element);
      //print(value.snapshot.value);
      value.snapshot.children.forEach((element) {
        if (!peopleID.contains(element.key)) peopleID.add(element.key);
        msgID.add(element.value);
      });
    });
    //print(peopleID[0]);
  });

  // print(peopleID);
  for (int i = 0; i < peopleID.length; i++) {
    var element = peopleID[i].toString();
    //print(element);
    await databaseReference
        .child('users')
        .child(element.toString())
        .child('name')
        .once()
        .then((value) {
      // print(value.snapshot.value);
      people.add(value.snapshot.value);
      mapname_id.addAll({value.snapshot.value: element});
    });
    //print(mapname_id);
  }
  return people;
}

Future<String> getConvId(name) async {
  var receiverID = mapname_id[name];
  var v;

  var conId;
  await databaseReference
      .child('users')
      .child(curuser.uid)
      .child('people')
      .child(receiverID)
      .once()
      .then((value) {
    conId = value.snapshot.value;
  });
  return conId;
}

void addMessagetoDB(types.TextMessage message, name) async {
  //print("object");
  var conId = await getConvId(name);
  databaseReference.child('messages').child(conId).update({
    message.id: {
      'auther': curuser.uid,
      'createdAt': message.createdAt,
      'text': message.text
    }
  });
}

Future<List<types.TextMessage>> getMessage(name) async {
  List<types.TextMessage> msgs = [];
  var convid = await getConvId(name);
  await databaseReference
      .child('messages')
      .child(convid)
      .orderByChild('createdAt')
      .once()
      .then((value) {
    value.snapshot.children.forEach((element) {
      var msg = types.TextMessage(
          author: types.User(id: element.child('auther').value.toString()),
          id: element.key ?? '',
          text: element.child('text').value.toString(),
          createdAt: int.parse(element.child('createdAt').value.toString()));
      msgs.insert(0,msg);
      //msgs = msgs.reversed.toList();
      
    });
  });
  return msgs;
}


