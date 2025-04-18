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
    apiKey: 'AIzaSyCEEN8flqW03g8JwQL85AuB-nC1C7x6P7U',
    appId: '1:841682457265:web:257241a6f10987dd67c890',
    messagingSenderId: '841682457265',
    projectId: 'agribot-99dcf',
    authDomain: 'agribot-99dcf.firebaseapp.com',
    storageBucket: 'agribot-99dcf.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3VMujVAiQGPu2SLVKwOEj1zMRw0b2YWg',
    appId: '1:841682457265:android:07e26b93cb1c764867c890',
    messagingSenderId: '841682457265',
    projectId: 'agribot-99dcf',
    storageBucket: 'agribot-99dcf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByLhPuhknbSi2n9_-34PJUvupUiBTFNgM',
    appId: '1:841682457265:ios:7e9f2d04ed8ba91d67c890',
    messagingSenderId: '841682457265',
    projectId: 'agribot-99dcf',
    storageBucket: 'agribot-99dcf.firebasestorage.app',
    iosClientId: '841682457265-k9vtcqaers1nliqnq22ncffjvht14ob7.apps.googleusercontent.com',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByLhPuhknbSi2n9_-34PJUvupUiBTFNgM',
    appId: '1:841682457265:ios:7e9f2d04ed8ba91d67c890',
    messagingSenderId: '841682457265',
    projectId: 'agribot-99dcf',
    storageBucket: 'agribot-99dcf.firebasestorage.app',
    iosClientId: '841682457265-k9vtcqaers1nliqnq22ncffjvht14ob7.apps.googleusercontent.com',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCEEN8flqW03g8JwQL85AuB-nC1C7x6P7U',
    appId: '1:841682457265:web:11fe650e27c6074867c890',
    messagingSenderId: '841682457265',
    projectId: 'agribot-99dcf',
    authDomain: 'agribot-99dcf.firebaseapp.com',
    storageBucket: 'agribot-99dcf.firebasestorage.app',
  );
}
