import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

class MekanServisi {
  static final _db = FirebaseFirestore.instance;
  static List<Mekan> _cache = [];

  static List<Mekan> get mekanlar =>
      _cache.isNotEmpty ? _cache : tumMekanlarListesi;

  static Future<void> yukle() async {
    try {
      final snap = await _db
          .collection('mekanlar')
          .get()
          .timeout(const Duration(seconds: 8));
      if (snap.docs.isEmpty) {
        _cache = List.from(tumMekanlarListesi);
        return;
      }
      _cache = snap.docs.map((doc) {
        final d = doc.data();
        return Mekan(
          isim: (d['isim'] as String?) ?? '',
          tur: (d['tur'] as String?) ?? 'Cafe',
          adres: (d['adres'] as String?) ?? '',
          resim: (d['resim'] as String?) ?? '',
          telefon: (d['telefon'] as String?) ?? '03121234567',
          puan: (d['puan'] as num?)?.toDouble() ?? 4.0,
          acilisSaati: (d['acilisSaati'] as String?) ?? '09:00 - 22:00',
          enlem: (d['enlem'] as num?)?.toDouble() ?? 39.9334,
          boylam: (d['boylam'] as num?)?.toDouble() ?? 32.8597,
          fiyatSeviyesi: (d['fiyatSeviyesi'] as int?) ?? 2,
        );
      }).toList();
    } catch (_) {
      _cache = List.from(tumMekanlarListesi);
    }
  }
}
