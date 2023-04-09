// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBTLW9xdEbPiUQhRzovor-2NM-ZJZlQ0B8',
    appId: '1:611363612087:web:a75aba4869d5ace5c07432',
    messagingSenderId: '611363612087',
    projectId: 'convocomdb',
    authDomain: 'convocomdb.firebaseapp.com',
    databaseURL: 'https://convocomdb-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'convocomdb.appspot.com',
    measurementId: 'G-21Q8PH8HB3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjNgg1xafvmrfJuaBrXFHXJC5b1_B4GOA',
    appId: '1:611363612087:android:be0d8ce35263b4b4c07432',
    messagingSenderId: '611363612087',
    projectId: 'convocomdb',
    databaseURL: 'https://convocomdb-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'convocomdb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_IA2HFm0BmC8yo8rqO6MSduirUAXhjsM',
    appId: '1:611363612087:ios:7b94f0e3e9906161c07432',
    messagingSenderId: '611363612087',
    projectId: 'convocomdb',
    databaseURL: 'https://convocomdb-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'convocomdb.appspot.com',
    iosClientId: '611363612087-k1kphf9krscjluejfljo0fh141h72pa7.apps.googleusercontent.com',
    iosBundleId: 'com.example.convocom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB_IA2HFm0BmC8yo8rqO6MSduirUAXhjsM',
    appId: '1:611363612087:ios:7b94f0e3e9906161c07432',
    messagingSenderId: '611363612087',
    projectId: 'convocomdb',
    databaseURL: 'https://convocomdb-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'convocomdb.appspot.com',
    iosClientId: '611363612087-k1kphf9krscjluejfljo0fh141h72pa7.apps.googleusercontent.com',
    iosBundleId: 'com.example.convocom',
  );
}
