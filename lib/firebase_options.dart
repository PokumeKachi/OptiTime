import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAlHKNPjsP4mRjl_9dFAWUQK5Tw_6I9N6Q',
    appId: '1:887774664029:web:5bcca255685495871204b4',
    messagingSenderId: '887774664029',
    projectId: 'todo-khkt',
    authDomain: 'todo-khkt.firebaseapp.com',
    storageBucket: 'todo-khkt.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAivTXYy54ljknrlpgbFH9avszPc9qwlPE',
    appId: '1:887774664029:android:bfaea06f31029d051204b4',
    messagingSenderId: '887774664029',
    projectId: 'todo-khkt',
    storageBucket: 'todo-khkt.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAlHKNPjsP4mRjl_9dFAWUQK5Tw_6I9N6Q',
    appId: '1:887774664029:web:ce09cccdeff4758a1204b4',
    messagingSenderId: '887774664029',
    projectId: 'todo-khkt',
    authDomain: 'todo-khkt.firebaseapp.com',
    storageBucket: 'todo-khkt.firebasestorage.app',
  );

}