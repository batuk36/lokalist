import 'package:shared_preferences/shared_preferences.dart';

class AramaGecmisiServisi {
  static const _key = 'arama_gecmisi';
  static const _maxAdet = 10;

  static Future<List<String>> getir() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> ekle(String kelime) async {
    final temiz = kelime.trim();
    if (temiz.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final liste = prefs.getStringList(_key) ?? [];
    liste.remove(temiz);
    liste.insert(0, temiz);
    if (liste.length > _maxAdet) liste.removeLast();
    await prefs.setStringList(_key, liste);
  }

  static Future<void> sil(String kelime) async {
    final prefs = await SharedPreferences.getInstance();
    final liste = prefs.getStringList(_key) ?? [];
    liste.remove(kelime);
    await prefs.setStringList(_key, liste);
  }

  static Future<void> temizle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
