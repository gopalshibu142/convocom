import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
  }
  late TextControl loginemail;
  late TextControl loginpass;

  late TextControl name;
  late TextControl email;
  late TextControl pass;
  late TextControl phone;
  late TextEditingController dob;
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
