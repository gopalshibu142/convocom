import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/Home.dart';

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

// Future registerUser(LoginDetails user, BuildContext context) async {
//  // var _credential;
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   var smsCode;
//   _auth.verifyPhoneNumber(
//       phoneNumber: user.phone.control.text,
//       timeout: Duration(seconds: 60),
//       verificationCompleted: (AuthCredential authCredential) {
//         _auth.signInWithCredential(authCredential).then((UserCredential result) {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (context) => Home()));
//         }).catchError((e) {
//           print(e);
//         });
//       },
//       verificationFailed: (FirebaseAuthException authException) {
//         print(authException.message);
//       },
//       codeSent: (String verificationId, int? forceResendingToken) {
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (context) => AlertDialog(
//                   title: Text("Enter SMS Code"),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       TextField(
//                         controller: user.code,
//                       ),
//                     ],
//                   ),
//                   actions: <Widget>[
//                     ElevatedButton(
//                       child: Text("Done"),
//                       onPressed: () async{
//                       //   AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: user.code.text);

//                       // UserCredential result = await _auth.signInWithCredential(credential);

//                       // User? userauth = result.user;

//                       // if(userauth != null){
//                       //   Navigator.push(context, MaterialPageRoute(
//                       //       builder: (context) => Home()
//                       //   ));
//                       // }else{
//                       //   print("Error");
//                       // }
//                       },
//                     )
//                   ],
//                 ));
//         //show dialog to take input from the user
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         verificationId = verificationId;
//         print(verificationId);
//         print("Timout");
//       });
// }
class UserDetails {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _success = false;
  String _userEmail = '';
  bool registered = false;

  void register(
      {required emailcontroller, required passwordcontroller}) async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: emailcontroller.text,
      password: passwordcontroller.text,
    ))
        .user;
  }

  void signInWithEmailAndPassword(
      {required emailcontroller, required passwordcontroller}) async {
    final User? user = (await _auth.signInWithEmailAndPassword(
      email: emailcontroller.text,
      password: passwordcontroller.text,
    ))
        .user;

    if (user != null) {
      _success = true;
      _userEmail = user.email.toString();
    } else {
      _success = false;
    }
  }
}
