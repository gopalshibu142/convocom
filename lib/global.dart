//import 'dart:html';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:convocom/firebasefn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

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
  late Color lvl0;
  late Color lvl1;
  late Color lvl2;
  late Color lvl3;

  void defaulttheme() {
    lvl0 = Color(0xff2a044a);
    lvl1 = Color(0xff0b2e59);
    lvl2 = Color(0xff0d6759);
    lvl3 = Color(0xff7ab317);
  }

  void blueblue() {
    lvl0 = Color(0xff000230);
    lvl1 = Color(0xff000f4d);
    lvl2 = Color(0xff0500a3);
    lvl3 = Color(0xff000acc);
  }

  void pinkeverywhere() {
    lvl0 = Color(0xffd9387f);
    lvl1 = Color(0xffda5892);
    lvl2 = Color(0xffc01a50);
    lvl3 = Color(0xfff7bef5);
  }

  void nature() {
    lvl0 = Color(0xff193534);
    lvl1 = Color(0xff3e6e3a);
    lvl2 = Color(0xff395b2d);
    lvl3 = Color(0xff627653);
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

UIColor theme = UIColor();
void getTheme(int n) {
  print(n);
  switch (n) {
    case 0:
      theme.defaulttheme();
      break;
    case 1:
      theme.blueblue();
      break;
    case 2:
      theme.pinkeverywhere();
      break;
    case 3:
      theme.nature();
      break;
    default:
      theme.defaulttheme();
  }
}

FirebaseFirestore cloud = FirebaseFirestore.instance;
int themeno = 0;
var curr_msgid = '';
Map mapname_id = {};
var convID;
List people = [];
List profileUrls = [];
bool islistadded = false;
