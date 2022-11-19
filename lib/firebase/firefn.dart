import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:convocom/global.dart';

void verifyPhone(TextEditingController phone) async{
  await FirebaseAuth.instance.verifyPhoneNumber(
  phoneNumber:phone.text ,
  verificationCompleted: (PhoneAuthCredential credential) {
    
  },
  verificationFailed: (FirebaseAuthException e) {},
  codeSent: (String verificationId, int? resendToken) {},
  codeAutoRetrievalTimeout: (String verificationId) {},
);
}
