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
    apiKey: 'AIzaSyCkIi5I9NAY6klrGAHDqm1xgBMx37t-BHc',
    appId: '1:212833531485:web:744f0caeaabe4239aeffb4',
    messagingSenderId: '212833531485',
    projectId: 'chat-app-befa0',
    authDomain: 'chat-app-befa0.firebaseapp.com',
    storageBucket: 'chat-app-befa0.firebasestorage.app',
    measurementId: 'G-7PX0PR2W0Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzCDDQJK5nE9KVGAI38aomkW502aiIBB0',
    appId: '1:212833531485:android:a91c38c6bed1db97aeffb4',
    messagingSenderId: '212833531485',
    projectId: 'chat-app-befa0',
    storageBucket: 'chat-app-befa0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBhZ0nVl6emGGVABRoWRLIUyBoeD80fe4I',
    appId: '1:212833531485:ios:3e6b830912417cfaaeffb4',
    messagingSenderId: '212833531485',
    projectId: 'chat-app-befa0',
    storageBucket: 'chat-app-befa0.firebasestorage.app',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBhZ0nVl6emGGVABRoWRLIUyBoeD80fe4I',
    appId: '1:212833531485:ios:3e6b830912417cfaaeffb4',
    messagingSenderId: '212833531485',
    projectId: 'chat-app-befa0',
    storageBucket: 'chat-app-befa0.firebasestorage.app',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCkIi5I9NAY6klrGAHDqm1xgBMx37t-BHc',
    appId: '1:212833531485:web:a54f15d0206be465aeffb4',
    messagingSenderId: '212833531485',
    projectId: 'chat-app-befa0',
    authDomain: 'chat-app-befa0.firebaseapp.com',
    storageBucket: 'chat-app-befa0.firebasestorage.app',
    measurementId: 'G-C89SBM7W11',
  );
}
