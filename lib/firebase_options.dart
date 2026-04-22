// Bu dosya 'flutterfire configure' komutuyla otomatik oluşturulur.
// Komut çalıştırıldığında bu dosyanın içeriği değiştirilecektir.
// Şu an için placeholder — uygulama bu dosya doldurulmadan çalışmaz.

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDcGJ3c3zfSn4Vfd74VZeBS5HftdjBIw7A',
    appId: '1:1038796563377:android:8655d09851dbf7fcbc1390',
    messagingSenderId: '1038796563377',
    projectId: 'lokatist-63a74',
    storageBucket: 'lokatist-63a74.firebasestorage.app',
  );

  // TODO: 'flutterfire configure' sonrası bu değerler dolacak

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBAbxUn0edZc17CGt8t0hsP9YfQKiD30FA',
    appId: '1:1038796563377:ios:ca4edc8853f65352bc1390',
    messagingSenderId: '1038796563377',
    projectId: 'lokatist-63a74',
    storageBucket: 'lokatist-63a74.firebasestorage.app',
    iosBundleId: 'com.batuhan.lokalistProje',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'BURAYA_API_KEY',
    appId: 'BURAYA_APP_ID',
    messagingSenderId: 'BURAYA_SENDER_ID',
    projectId: 'BURAYA_PROJECT_ID',
    storageBucket: 'BURAYA_STORAGE_BUCKET',
    authDomain: 'BURAYA_AUTH_DOMAIN',
  );
}