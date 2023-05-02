//import 'dart:html';

//import 'dart:js';
import 'dart:io';
import 'dart:convert';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:convocom/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_options.dart';
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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
          user_ID = curuser.uid;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('issignedin', true);
          prefs.setString('useremail', email);
          prefs.setString('userpass', password);
          prefs.setString('user_ID', curuser.uid);
          // debugPrint("helloworld");
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        success = false;
      }
    } on FirebaseAuthException catch (e) {
      QuickAlert.show(context: context, type: QuickAlertType.error);
      Vibration.vibrate();
      error = e.toString();
      showSnack(error, context);
    } catch (e) {
      showSnack(e.toString(), context);
    }
    listenMessages();
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
      textColor: Colors.white,
      onConfirmBtnTap: () async {
        auth.signOut();
        Navigator.pushReplacementNamed(context, '/login');
        Future.delayed(Duration(seconds: 1));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('issignedin', false);
        prefs.setStringList('', []);
        prefs.setString('user_ID', 'null');
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

Future addConncetion(String email, context) async {
  try {
    databaseReference.child('test2').set({});
    bool haschild = false;
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
    Query query = usersRef.orderByChild('email').equalTo(email);
    query.once().then((snap) async {
      if (!snap.snapshot.exists) {
        showSnack('User not found', context);
        // print('object');
      } else {
        var value = await snap.snapshot;
        databaseReference
            .child('users')
            .child(curuser.uid)
            .child('people')
            .once()
            .then((snap) async {
          haschild =
              await snap.snapshot.hasChild(value.children.first.key.toString());
          // print(haschild);
          // print(value.children.first.key.toString());
          if (haschild == false) {
            showSnack(
                " ${value.children.first.child('name').value} has been added",
                context);
            // print(value.children.first.key);
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
              //   print('object');
            });
            cloud.collection(con_name).add({});
          } else {
            showSnack(
                "User name: ${value.children.first.child('name').value} already exist in your connections",
                context);
          }
        });
      }

      // Do something with the results
    });
  } catch (r) {
    showSnack('User not found', context);
    // print('object');
  }
}

Future<void> getPeoplelist() async {
  islistadded = false;
  people = [];
  List peopleID = [];
  List msgID = [];
  profileUrls = [];

  mapname_id = {};
  await databaseReference
      .child('users')
      .child(curuser.uid)
      .child('people')
      .once()
      .then((value) {
    //  print('called');
    //print(value.snapshot.children);
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
    var name, url;

    await databaseReference
        .child('users')
        .child(element.toString())
        .child('name')
        .once()
        .then((value) {
      // print(value.snapshot.value);
      name = value.snapshot.value.toString();
      mapname_id.addAll({value.snapshot.value: element});
    });
    await databaseReference
        .child('users')
        .child(element.toString())
        .child('profile')
        .once()
        .then((value) {
      // print(value.snapshot.value);
      url = value.snapshot.value.toString();

      //mapname_id.addAll({value.snapshot.value: element});
    });
    people.add(PersonDetail(name, url));
    //print(mapname_id);
  }
  // print(profile);
  islistadded = true;
}

Future<String> getConvId(name) async {
  var receiverID = mapname_id[name];
  //var v;

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
      msgs.insert(0, msg);
      //msgs = msgs.reversed.toList();
    });
  });
  return msgs;
}

Future<void> uploadProfile(File image) async {
  if (kIsWeb) {
    var bytes = await image.readAsBytes();
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(curuser.uid)
        .child('profile.jpg');
    final uploadTask = storageRef.putData(bytes);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    databaseReference
        .child('users')
        .child(curuser.uid)
        .child('profile')
        .set(downloadUrl);
  }
  // print(await Permission.photos.status);

  final storageRef = FirebaseStorage.instance
      .ref()
      .child('users')
      .child(curuser.uid)
      .child('profile.jpg');
  final uploadTask = storageRef.putFile(image);
  final snapshot = await uploadTask.whenComplete(() => null);
  final downloadUrl = await snapshot.ref.getDownloadURL();
  databaseReference
      .child('users')
      .child(curuser.uid)
      .child('profile')
      .set(downloadUrl);
}

Future<String> getProfileUrl({required userId}) async {
  late String url = 'error';
  await databaseReference
      .child('users')
      .child(userId)
      .child('profile')
      .once()
      .then((value) {
    url = value.snapshot.value.toString();
    //print('url');
  }).onError((error, stackTrace) {
    url = 'error';
  });
  return url;
}

void cloudMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming messages when the app is in the foreground
      print('Received message: ${message.notification?.title}');
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      // Handle incoming messages when the app is in the background
      print('Received message in background: ${message.notification?.title}');
    });
  }
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void initLocalNotification() async {
//  print('init');
  // configure the settings of the plugin
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  var initializationSettingsIOS = DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification(
    {required String title, required String body}) async {
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          // vibrationPattern: Int64List.fromList([10,50,50,50]),
          priority: Priority.high,
          enableVibration: true,
          colorized: true,
          ticker: 'ticker');
  NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, notificationDetails, payload: 'item x');
}

void listenMessages() async {
  if (await Permission.notification.isDenied)
    await Permission.notification.request();
  // print('here');
  DatabaseReference db = await FirebaseDatabase.instance.ref();
  List<DataSnapshot> snaps = [];
  List<String> connections = [];
  await db.once();
  String id = '';
  await db
      .child('connections')
      .once()
      .then((value) => snaps = value.snapshot.children.toList());
  snaps.forEach((element) {
    connections.add(element.key ?? '');
  });
  //print(connections);

  await db.child('users').child(user_ID).child('people').once().then((value) {
    value.snapshot.children.forEach((element) {
      map_coniv_name.addAll({element.value.toString(): element.key.toString()});
    });
  });
  //print(map_coniv_name);
  for (int i = 0; i < connections.length; i++) {
    id = map_coniv_name.containsKey(connections[i])
        ? map_coniv_name[connections[i]] ?? 'null'
        : 'null';
    var name = await getName(id);
    if (name != 'null') {
      //db..child('messages').child(connections[i]).once().then((value) => null);
      db.child('messages').child(connections[i]).onValue.listen((event) async {
        var n;
        DatabaseReference dref = FirebaseDatabase.instance.ref();
        String idval = '';
        await dref
            .child('messages')
            .child(connections[i])
            .orderByChild('createdAt')
            .once()
            .then((value) async {
          idval = value.snapshot.children.last.child('auther').value.toString();
          n = await getName(map_coniv_name[connections[i]]);
          //  print('${n} ${event.snapshot.children.last.value.toString()}\n');
          //print('last message:${value.snapshot.children.last.key.toString()}');

          if (idval != curuser.uid) {
            showNotification(
                title: n,
                body: value.snapshot.children.last
                    .child('text')
                    .value
                    .toString());
          }

          /// print(event.snapshot.children.last.value);
        });

        //h print(event.snapshot.value);
      });
    }
  }
  // connections.forEach((element) async{

  //   var name = mapname_id.keys.firstWhere((i) => mapname_id[i]==element);

  // });
}

Future<String> getName(id) async {
  String name = 'null';
  DatabaseReference db = await FirebaseDatabase.instance.ref();
  await db
      .child('users')
      .child(id)
      .child('name')
      .once()
      .then((value) => name = value.snapshot.value.toString());
  return name;
}
