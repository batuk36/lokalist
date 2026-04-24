import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServisi {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  static User? get mevcutKullanici => _auth.currentUser;
  static Stream<User?> get durumAkisi => _auth.authStateChanges();

  static Future<void> girisYap(String email, String sifre) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: sifre,
    );
  }

  static Future<void> kayitOl(String ad, String email, String sifre) async {
    final uc = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: sifre,
    );
    await uc.user?.updateDisplayName(ad.trim());
    await _db.collection('users').doc(uc.user!.uid).set({
      'displayName': ad.trim(),
      'email': email.trim(),
      'favorites': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> cikisYap() async {
    await _auth.signOut();
  }

  static Future<void> sifreSifirla(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }
}
