import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';
import 'mekan_servisi.dart';

class KullaniciServisi {
  static final _db = FirebaseFirestore.instance;

  static Future<List<String>> favorileriGetir(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return [];
    return List<String>.from(doc.data()?['favorites'] ?? []);
  }

  static Future<void> favoriGuncelle(
      String uid, String mekanIsmi, bool ekle) async {
    final ref = _db.collection('users').doc(uid);
    if (ekle) {
      await ref.update({
        'favorites': FieldValue.arrayUnion([mekanIsmi])
      });
    } else {
      await ref.update({
        'favorites': FieldValue.arrayRemove([mekanIsmi])
      });
    }
  }

  static Future<void> puanKaydet(String uid, String mekanIsmi, int puan) async {
    final ref = _db.collection('users').doc(uid);
    await ref.set({'ratings': {mekanIsmi: puan}}, SetOptions(merge: true));
  }

  static Future<int> puanGetir(String uid, String mekanIsmi) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return 0;
    final ratings = doc.data()?['ratings'] as Map<String, dynamic>?;
    return (ratings?[mekanIsmi] as int?) ?? 0;
  }

  static Future<void> favorileriUygula(String uid) async {
    final favoriler = await favorileriGetir(uid);
    for (final mekan in MekanServisi.mekanlar) {
      mekan.isFavorite = favoriler.contains(mekan.isim);
    }
  }
}
