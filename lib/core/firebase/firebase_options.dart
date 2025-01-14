import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.iOS) return _ios;
    return _android;
  }

  static const FirebaseOptions _android = FirebaseOptions(
    apiKey: 'AIzaSyBn4Q3ozCXCFbL9tz3qU-18DvB5oOl21aY',
    appId: '1:755391383814:android:6029be2e05eb64fffa7687',
    messagingSenderId: '755391383814',
    projectId: 'tashlih-app',
    storageBucket: 'tashlih-app.appspot.com',
  );

  static const FirebaseOptions _ios = FirebaseOptions(
    apiKey: 'AIzaSyC_SSEGDxU0OAENX-_-X_dN9JZnmF-xJoc',
    appId: '1:755391383814:ios:ea6dd44904af2a88fa7687',
    messagingSenderId: '755391383814',
    projectId: 'tashlih-app',
    storageBucket: 'tashlih-app.appspot.com',
    iosBundleId: 'com.tashlihi.app',
  );
}
