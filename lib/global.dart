//import 'dart:html';
import 'dart:math';
import 'dart:convert';
import 'package:convocom/firebasefn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UI {
  var w;
  var h;
  var backgrounds = [
    'assets/bg1.json',
    'assets/bg2.json',
    'assets/bg3.json',
  ];
  //var colorlogin = [Colors.white, Colors.black];
  var background;
  late Color clrlog;
  late Color txt;
  late int rn;

  UI(context) {
    // w = MediaQuery.of(context).size.width;
    // h = MediaQuery.of(context).size.height;
    final _random = new Random();

    rn = _random.nextInt(backgrounds.length);

// generate a random index based on the list length
// and use it to retrieve the element
    this.clrlog = Colors.white;
    this.txt = Colors.blue;
  }
}

class UIColor {
  Color lvl0 = Color(0xff03001C);
  Color lvl1 = Color(0xff301E67);
  Color lvl2 = Color(0xff5B8FB9);
  Color lvl3 = Color(0xffB6EADA);
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

  void validSignup() {}
}

class TextControl {
  TextControl() {
    control = TextEditingController();
    validator = false;
  }
  late TextEditingController control;
  late bool validator;
}

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

late User curuser;
late DatabaseReference databaseReference;
void setDB() {
  databaseReference = FirebaseDatabase.instance.ref();
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

FirebaseFirestore cloud = FirebaseFirestore.instance;

var curr_msgid = '';
Map mapname_id = {};
var convID;
