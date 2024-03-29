import 'package:convocom/firebasefn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'screens/splash.dart';
import 'screens/Home.dart';
import 'global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setDB();
  cloudMessaging();
 
  //FirebaseAppCheck.instance.useEmulator("10.0.2.2", 9099);
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  Myapp({super.key}) {}
  late final prefs;
  late bool signedin;
  late String root;

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  late UserDetails user;
  var prefs;
  late bool signedin;

  _MyappState() {}

  Future<void> init() async {
    initLocalNotification();
    
    prefs = SharedPreferences.getInstance();
    signedin =
        prefs.containsKey("issignedin") ? prefs.getBool('issignedin') : false;
    //user_ID =  prefs.containsKey("user_ID") ? prefs.getString('User_ID') : false;
  }

  @override
  void initState() {
    super.initState();
    user = UserDetails();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "convocom : let's blaber",
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => SplashFuturePage(),
        '/login': (context) => Login(user: user),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => Home(
              user: user,
            ),
      },
    );
  }
}
