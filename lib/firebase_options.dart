import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// This file is a placeholder. Please run `firebase login` then
// `flutterfire configure --project startupapp-bd1d1` to regenerate it with real values.

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not set for this platform. Run flutterfire configure.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCfDg5DeBp5ySansGgrf8hbHdKPj-ktlBA',
    appId: '1:157070792738:web:8cb22dd470a91b639e127b',
    messagingSenderId: '157070792738',
    projectId: 'startupapp-bd1d1',
    authDomain: 'startupapp-bd1d1.firebaseapp.com',
    storageBucket: 'startupapp-bd1d1.firebasestorage.app',
    measurementId: 'G-J33TEVGVDJ',
  );

  // PLACEHOLDER VALUES — replace by running flutterfire configure

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBaG0r5JNcNJebPvuFC6dzDL9_b9gmcYnI',
    appId: '1:157070792738:android:66a99263e24b59349e127b',
    messagingSenderId: '157070792738',
    projectId: 'startupapp-bd1d1',
    storageBucket: 'startupapp-bd1d1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCH7ZLEz-M9G1op_kPR3rTo7rpJFy0r-CE',
    appId: '1:157070792738:ios:36d0ae30ffbe5df69e127b',
    messagingSenderId: '157070792738',
    projectId: 'startupapp-bd1d1',
    storageBucket: 'startupapp-bd1d1.firebasestorage.app',
    iosBundleId: 'com.example.startup',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCH7ZLEz-M9G1op_kPR3rTo7rpJFy0r-CE',
    appId: '1:157070792738:ios:36d0ae30ffbe5df69e127b',
    messagingSenderId: '157070792738',
    projectId: 'startupapp-bd1d1',
    storageBucket: 'startupapp-bd1d1.firebasestorage.app',
    iosBundleId: 'com.example.startup',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCfDg5DeBp5ySansGgrf8hbHdKPj-ktlBA',
    appId: '1:157070792738:web:304cf785142f260c9e127b',
    messagingSenderId: '157070792738',
    projectId: 'startupapp-bd1d1',
    authDomain: 'startupapp-bd1d1.firebaseapp.com',
    storageBucket: 'startupapp-bd1d1.firebasestorage.app',
    measurementId: 'G-H0CHDYLKQH',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'TODO-REPLACE',
    appId: 'TODO-REPLACE',
    messagingSenderId: 'TODO-REPLACE',
    projectId: 'startupapp-bd1d1',
    storageBucket: 'startupapp-bd1d1.appspot.com',
  );
}