import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';
import 'kullanici_servisi.dart';

class MekanServisi {
  static final _db = FirebaseFirestore.instance;
  static List<Mekan> _cache = [];

  static List<Mekan> get mekanlar =>
      _cache.isNotEmpty ? _cache : tumMekanlarListesi;

  static Stream<List<Mekan>> get stream {
    return _db.collection('mekanlar').snapshots().map((snap) {
      final list = snap.docs.map(_docToMekan).toList();
      for (final m in list) {
        m.isFavorite = KullaniciServisi.cachedFavoriler.contains(m.isim);
      }
      _cache = list;
      return list;
    });
  }

  static Future<void> yukle() async {
    try {
      final snap = await _db
          .collection('mekanlar')
          .get()
          .timeout(const Duration(seconds: 8));
      if (snap.docs.isEmpty) {
        await _seed();
        final seeded = await _db.collection('mekanlar').get();
        _cache = seeded.docs.map(_docToMekan).toList();
      } else {
        _cache = snap.docs.map(_docToMekan).toList();
      }
    } catch (_) {
      _cache = List.from(tumMekanlarListesi);
    }
  }

  static Future<void> _seed() async {
    final batch = _db.batch();
    for (final m in tumMekanlarListesi) {
      batch.set(_db.collection('mekanlar').doc(), m.toMap());
    }
    await batch.commit();
  }

  static Mekan _docToMekan(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Mekan(
      isim: (d['isim'] as String?) ?? '',
      tur: (d['tur'] as String?) ?? 'Cafe',
      kategori: (d['kategori'] as String?) ?? 'Cafeler',
      adres: (d['adres'] as String?) ?? '',
      resim: (d['resim'] as String?) ?? '',
      telefon: (d['telefon'] as String?) ?? '03121234567',
      puan: (d['puan'] as num?)?.toDouble() ?? 4.0,
      acilisSaati: (d['acilisSaati'] as String?) ?? '09:00 - 22:00',
      enlem: (d['enlem'] as num?)?.toDouble() ?? 39.9334,
      boylam: (d['boylam'] as num?)?.toDouble() ?? 32.8597,
      fiyatSeviyesi: (d['fiyatSeviyesi'] as int?) ?? 2,
    );
  }
}
