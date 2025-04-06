// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyA9tjY3CTill6NPO3rDr5JGnx41up2oI88',
    appId: '1:799885511523:web:0ac965e4196d954df8e156',
    messagingSenderId: '799885511523',
    projectId: 'greenguardai-45879',
    authDomain: 'greenguardai-45879.firebaseapp.com',
    storageBucket: 'greenguardai-45879.firebasestorage.app',
    measurementId: 'G-QER2G3K8YJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5LAJ_hGktcYRNFsp3DGXU-u2F0cF3MvY',
    appId: '1:799885511523:android:9afb0b34a5ae8f14f8e156',
    messagingSenderId: '799885511523',
    projectId: 'greenguardai-45879',
    storageBucket: 'greenguardai-45879.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAScMpXCs1Q5FJVfTJWkZzDNEUHWhOtgM',
    appId: '1:799885511523:ios:c1a573d62f0d5d0bf8e156',
    messagingSenderId: '799885511523',
    projectId: 'greenguardai-45879',
    storageBucket: 'greenguardai-45879.firebasestorage.app',
    iosBundleId: 'com.example.chanakya',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDAScMpXCs1Q5FJVfTJWkZzDNEUHWhOtgM',
    appId: '1:799885511523:ios:c1a573d62f0d5d0bf8e156',
    messagingSenderId: '799885511523',
    projectId: 'greenguardai-45879',
    storageBucket: 'greenguardai-45879.firebasestorage.app',
    iosBundleId: 'com.example.chanakya',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA9tjY3CTill6NPO3rDr5JGnx41up2oI88',
    appId: '1:799885511523:web:8f1301cc3054151ef8e156',
    messagingSenderId: '799885511523',
    projectId: 'greenguardai-45879',
    authDomain: 'greenguardai-45879.firebaseapp.com',
    storageBucket: 'greenguardai-45879.firebasestorage.app',
    measurementId: 'G-NJERWGL4L3',
  );
}
