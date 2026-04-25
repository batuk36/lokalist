import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'mekan_servisi.dart';
import 'drawer_menu.dart';
import 'detail_page.dart';
import 'ayarlar_page.dart';
import 'bildirimler_page.dart';
import 'auth_servisi.dart';
import 'giris_page.dart';
import 'profil_page.dart';
import 'tema_yonetici.dart';
import 'arama_gecmisi_servisi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String mevcutKategori = "Hepsi";
  final Color midnightBlue = const Color(0xFF0056b3);
  Position? kullaniciKonumu;

  List<Mekan> _mekanlar = [];
  StreamSubscription<List<Mekan>>? _mekanSubscription;

  final TextEditingController aramaController = TextEditingController();
  final FocusNode _aramaFocusu = FocusNode();
  String aramaKelimesi = "";
  bool _aramaAktif = false;
  List<String> _aramaGecmisi = [];

  // Filtre durumu
  Set<int> _secilenFiyatlar = {};
  double _minPuan = 0.0;
  int _maxMesafe = 0;

  bool get _filtreAktif =>
      _secilenFiyatlar.isNotEmpty || _minPuan > 0 || _maxMesafe > 0;

  List<Mekan> get gosterilenMekanlar {
    var liste = List<Mekan>.from(_mekanlar);

    if (mevcutKategori == 'Favoriler') {
      liste = liste.where((m) => m.isFavorite).toList();
    } else if (mevcutKategori != 'Hepsi') {
      liste = liste.where((m) => m.tur == mevcutKategori).toList();
    }

    if (aramaKelimesi.isNotEmpty) {
      liste = liste.where((m) => m.isim.toLowerCase().contains(aramaKelimesi)).toList();
    }

    if (_secilenFiyatlar.isNotEmpty) {
      liste = liste.where((m) => _secilenFiyatlar.contains(m.fiyatSeviyesi)).toList();
    }

    if (_minPuan > 0) {
      liste = liste.where((m) => m.puan >= _minPuan).toList();
    }

    if (kullaniciKonumu != null && _maxMesafe > 0) {
      liste = liste.where((m) {
        final mesafe = Geolocator.distanceBetween(
          kullaniciKonumu!.latitude, kullaniciKonumu!.longitude,
          m.enlem, m.boylam,
        ) / 1000;
        return mesafe <= _maxMesafe;
      }).toList();
    }

    return liste;
  }

  @override
  void initState() {
    super.initState();
    _mekanlar = List.from(MekanServisi.mekanlar);
    _mekanSubscription = MekanServisi.stream.listen((mekanlar) {
      if (mounted) setState(() => _mekanlar = mekanlar);
    });
    _konumAl();
    _aramaGecmisiYukle();
    _aramaFocusu.addListener(() {
      if (mounted) setState(() => _aramaAktif = _aramaFocusu.hasFocus);
    });
  }

  @override
  void dispose() {
    _mekanSubscription?.cancel();
    aramaController.dispose();
    _aramaFocusu.dispose();
    super.dispose();
  }

  Future<void> _konumAl() async {
    bool servisAcik = await Geolocator.isLocationServiceEnabled();
    if (!servisAcik) return;
    LocationPermission izin = await Geolocator.checkPermission();
    if (izin == LocationPermission.denied) {
      izin = await Geolocator.requestPermission();
      if (izin == LocationPermission.denied) return;
    }
    Position konum = await Geolocator.getCurrentPosition();
    setState(() => kullaniciKonumu = konum);
  }

  Future<void> _aramaGecmisiYukle() async {
    final gecmis = await AramaGecmisiServisi.getir();
    if (mounted) setState(() => _aramaGecmisi = gecmis);
  }

  void _aramaYap(String kelime) {
    setState(() => aramaKelimesi = kelime.toLowerCase());
  }

  void _aramaGonderildi(String kelime) async {
    if (kelime.trim().isEmpty) return;
    await AramaGecmisiServisi.ekle(kelime.trim());
    final gecmis = await AramaGecmisiServisi.getir();
    if (mounted) setState(() => _aramaGecmisi = gecmis);
    _aramaFocusu.unfocus();
  }

  void _gecmisdenSec(String kelime) {
    aramaController.text = kelime;
    _aramaYap(kelime);
    _aramaFocusu.unfocus();
  }

  Future<void> _gecmisdenSil(String kelime) async {
    await AramaGecmisiServisi.sil(kelime);
    final gecmis = await AramaGecmisiServisi.getir();
    if (mounted) setState(() => _aramaGecmisi = gecmis);
  }

  Future<void> _gecmisiTemizle() async {
    await AramaGecmisiServisi.temizle();
    if (mounted) setState(() => _aramaGecmisi = []);
  }

  List<Mekan> _enYakinMekanlar() {
    var kaynak = List<Mekan>.from(_mekanlar);
    if (mevcutKategori == 'Favoriler') {
      kaynak = kaynak.where((m) => m.isFavorite).toList();
    } else if (mevcutKategori != 'Hepsi') {
      kaynak = kaynak.where((m) => m.tur == mevcutKategori).toList();
    }
    if (kullaniciKonumu == null) return kaynak.take(10).toList();
    kaynak.sort((a, b) {
      double dA = Geolocator.distanceBetween(kullaniciKonumu!.latitude, kullaniciKonumu!.longitude, a.enlem, a.boylam);
      double dB = Geolocator.distanceBetween(kullaniciKonumu!.latitude, kullaniciKonumu!.longitude, b.enlem, b.boylam);
      return dA.compareTo(dB);
    });
    return kaynak.take(10).toList();
  }

  void _filtrele(String kategori) {
    setState(() {
      mevcutKategori = kategori;
      aramaController.clear();
      aramaKelimesi = "";
    });
  }

  void _filtreGoster(bool dark) {
    Set<int> localFiyatlar = Set.from(_secilenFiyatlar);
    double localMinPuan = _minPuan;
    int localMaxMesafe = _maxMesafe;

    final surfaceColor = dark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = dark ? Colors.white : Colors.black87;
    final subColor = dark ? Colors.white54 : Colors.black54;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: dark ? const Color(0xFF121212) : Colors.grey.shade50,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          Widget chipBtn({required bool secili, required String etiket, required VoidCallback onTap, IconData? ikon}) {
            return GestureDetector(
              onTap: onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: secili ? midnightBlue : surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: secili ? midnightBlue : (dark ? Colors.white24 : Colors.black12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (ikon != null) ...[Icon(ikon, color: secili ? Colors.white : Colors.amber, size: 15), const SizedBox(width: 4)],
                    Text(etiket, style: TextStyle(color: secili ? Colors.white : textColor, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: dark ? Colors.white24 : Colors.black26, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text('Filtrele', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 20),
                Text('Fiyat Seviyesi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: subColor)),
                const SizedBox(height: 10),
                Row(children: [
                  chipBtn(secili: localFiyatlar.contains(1), etiket: '₺', onTap: () => setSheet(() => localFiyatlar.contains(1) ? localFiyatlar.remove(1) : localFiyatlar.add(1))),
                  const SizedBox(width: 10),
                  chipBtn(secili: localFiyatlar.contains(2), etiket: '₺₺', onTap: () => setSheet(() => localFiyatlar.contains(2) ? localFiyatlar.remove(2) : localFiyatlar.add(2))),
                  const SizedBox(width: 10),
                  chipBtn(secili: localFiyatlar.contains(3), etiket: '₺₺₺', onTap: () => setSheet(() => localFiyatlar.contains(3) ? localFiyatlar.remove(3) : localFiyatlar.add(3))),
                ]),
                const SizedBox(height: 20),
                Text('Minimum Puan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: subColor)),
                const SizedBox(height: 10),
                Wrap(spacing: 10, children: [
                  chipBtn(secili: localMinPuan == 3.0, etiket: '3+', ikon: Icons.star, onTap: () => setSheet(() => localMinPuan = localMinPuan == 3.0 ? 0.0 : 3.0)),
                  chipBtn(secili: localMinPuan == 4.0, etiket: '4+', ikon: Icons.star, onTap: () => setSheet(() => localMinPuan = localMinPuan == 4.0 ? 0.0 : 4.0)),
                  chipBtn(secili: localMinPuan == 4.5, etiket: '4.5+', ikon: Icons.star, onTap: () => setSheet(() => localMinPuan = localMinPuan == 4.5 ? 0.0 : 4.5)),
                ]),
                if (kullaniciKonumu != null) ...[
                  const SizedBox(height: 20),
                  Text('Maksimum Mesafe', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: subColor)),
                  const SizedBox(height: 10),
                  Wrap(spacing: 10, children: [
                    chipBtn(secili: localMaxMesafe == 1, etiket: '1 km', onTap: () => setSheet(() => localMaxMesafe = localMaxMesafe == 1 ? 0 : 1)),
                    chipBtn(secili: localMaxMesafe == 3, etiket: '3 km', onTap: () => setSheet(() => localMaxMesafe = localMaxMesafe == 3 ? 0 : 3)),
                    chipBtn(secili: localMaxMesafe == 5, etiket: '5 km', onTap: () => setSheet(() => localMaxMesafe = localMaxMesafe == 5 ? 0 : 5)),
                  ]),
                ],
                const SizedBox(height: 24),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setSheet(() { localFiyatlar.clear(); localMinPuan = 0.0; localMaxMesafe = 0; }),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: dark ? Colors.white24 : Colors.black26), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: Text('Sıfırla', style: TextStyle(color: textColor, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() { _secilenFiyatlar = Set.from(localFiyatlar); _minPuan = localMinPuan; _maxMesafe = localMaxMesafe; });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: midnightBlue, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Uygula', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  void _profilGoster(bool dark) {
    final kullanici = FirebaseAuth.instance.currentUser;

    if (kullanici == null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const GirisPage()));
      return;
    }

    final ad = kullanici.displayName ?? 'Kullanıcı';
    final email = kullanici.email ?? '';
    showModalBottomSheet(
      context: context,
      backgroundColor: dark ? const Color(0xFF161616) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 36, backgroundColor: const Color(0xFF0056b3), child: Text(ad.isNotEmpty ? ad[0].toUpperCase() : 'L', style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            Text(ad, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: dark ? Colors.white : Colors.black87)),
            Text(email, style: TextStyle(fontSize: 13, color: dark ? Colors.white38 : Colors.black38)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Color(0xFF0056b3)),
              title: const Text('Profilimi Düzenle', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilPage()))
                    .then((_) { if (mounted) setState(() {}); });
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Çıkış Yap', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
              onTap: () async {
                Navigator.pop(ctx);
                await AuthServisi.cikisYap();
                if (context.mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const GirisPage()), (_) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.watch<TemaYonetici>().karanlikMod;
    final bgColor = dark ? const Color(0xFF0A0A0A) : Colors.white;
    final surfaceColor = dark ? const Color(0xFF161616) : Colors.grey.shade100;
    final textColor = dark ? Colors.white : Colors.black87;
    final subtextColor = dark ? Colors.white38 : Colors.black54;
    final headingColor = dark ? Colors.white70 : Colors.black87;
    final liste = gosterilenMekanlar;

    return Scaffold(
      backgroundColor: bgColor,
      drawer: YanMenu(
        onKategoriSec: _filtrele,
        onProfilTikla: () => _profilGoster(dark),
        onAyarlarTikla: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const AyarlarPage())); },
        onRastgeleSec: () {
          final mekanlar = _mekanlar;
          if (mekanlar.isEmpty) return;
          final m = mekanlar[Random().nextInt(mekanlar.length)];
          Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(mekan: m)))
              .then((_) { if (mounted) setState(() {}); });
        },
      ),
      appBar: AppBar(
        title: Text('LOKATİST', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: midnightBlue)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(icon: Icon(Icons.tune, color: textColor, size: 26), onPressed: () => _filtreGoster(dark), tooltip: 'Filtrele'),
              if (_filtreAktif)
                Positioned(top: 8, right: 8, child: Container(width: 9, height: 9, decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, border: Border.all(color: bgColor, width: 1.5)))),
            ],
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: textColor, size: 28),
            onPressed: () async {
              final sonuc = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (_) => const BildirimlerPage()),
              );
              if (sonuc != null && mounted) {
                if (sonuc == 'favoriler') {
                  _filtrele('Favoriler');
                } else {
                  _filtrele('Hepsi');
                }
              }
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => _aramaFocusu.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: TextField(
                  controller: aramaController,
                  focusNode: _aramaFocusu,
                  onChanged: _aramaYap,
                  onSubmitted: _aramaGonderildi,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: "Mekan ara...",
                    hintStyle: TextStyle(color: subtextColor),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF0056b3)),
                    filled: true,
                    fillColor: surfaceColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    suffixIcon: aramaKelimesi.isNotEmpty
                        ? IconButton(icon: Icon(Icons.clear, color: subtextColor), onPressed: () { aramaController.clear(); _aramaYap(""); })
                        : null,
                  ),
                ),
              ),

              // Arama geçmişi
              if (_aramaAktif && aramaKelimesi.isEmpty && _aramaGecmisi.isNotEmpty)
                _aramaGecmisiWidget(dark, surfaceColor, textColor, subtextColor),

              // Aktif filtre chipleri
              if (_filtreAktif)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      if (_secilenFiyatlar.isNotEmpty) _filtreChip(_secilenFiyatlar.map((f) => '₺' * f).join(', '), () => setState(() => _secilenFiyatlar.clear())),
                      if (_minPuan > 0) _filtreChip('${_minPuan.toString().replaceAll('.0', '')}+ yıldız', () => setState(() => _minPuan = 0.0)),
                      if (_maxMesafe > 0) _filtreChip('$_maxMesafe km içinde', () => setState(() => _maxMesafe = 0)),
                    ],
                  ),
                ),
              const SizedBox(height: 4),

              if (mevcutKategori == 'Favoriler')
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Favorilerim", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 20),
                      if (liste.isEmpty)
                        Center(
                          child: Text(
                            FirebaseAuth.instance.currentUser == null
                                ? "\nFavori eklemek için giriş yapınız."
                                : "\nHenüz favori eklemediniz.",
                            style: TextStyle(color: subtextColor),
                            textAlign: TextAlign.center,
                          ),
                        )
                      else ...liste.map((m) => _trendMekanKarti(m, textColor, subtextColor)),
                    ],
                  ),
                )
              else ...[
                Padding(padding: const EdgeInsets.only(left: 20, top: 10), child: Text("Öne Çıkanlar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: headingColor))),
                SizedBox(
                  height: 350,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.85),
                    itemCount: liste.length > 5 ? 5 : liste.length,
                    itemBuilder: (_, i) => _premiumKart(liste[i]),
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Text("Sana En Yakınlar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: headingColor))),
                Builder(builder: (_) {
                  final yakinlar = _enYakinMekanlar();
                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 15),
                      itemCount: yakinlar.length,
                      itemBuilder: (_, i) => _kucukKart(yakinlar[i]),
                    ),
                  );
                }),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), child: Text("Trend Mekanlar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: headingColor))),
                liste.isEmpty
                    ? Padding(padding: const EdgeInsets.all(30), child: Center(child: Text('Filtrelerinize uygun mekan bulunamadı.', style: TextStyle(color: subtextColor, fontSize: 15), textAlign: TextAlign.center)))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: liste.length,
                        itemBuilder: (_, i) => _trendMekanKarti(liste[i], textColor, subtextColor),
                      ),
              ],
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _aramaGecmisiWidget(bool dark, Color surfaceColor, Color textColor, Color subtextColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.history, color: subtextColor, size: 18),
                const SizedBox(width: 8),
                Text('Son Aramalar', style: TextStyle(color: subtextColor, fontSize: 13, fontWeight: FontWeight.w600)),
                const Spacer(),
                GestureDetector(
                  onTap: _gecmisiTemizle,
                  child: Text('Temizle', style: TextStyle(color: midnightBlue, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: dark ? Colors.white12 : Colors.black12),
          ..._aramaGecmisi.map((kelime) => ListTile(
            dense: true,
            leading: Icon(Icons.search, color: subtextColor, size: 20),
            title: Text(kelime, style: TextStyle(color: textColor, fontSize: 15)),
            trailing: IconButton(
              icon: Icon(Icons.close, color: subtextColor, size: 18),
              onPressed: () => _gecmisdenSil(kelime),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            onTap: () => _gecmisdenSec(kelime),
          )),
        ],
      ),
    );
  }

  Widget _filtreChip(String etiket, VoidCallback onKaldir) {
    return Chip(
      label: Text(etiket, style: const TextStyle(fontSize: 12, color: Colors.white)),
      backgroundColor: midnightBlue,
      deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white70),
      onDeleted: onKaldir,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _premiumKart(Mekan m) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(mekan: m))).then((_) { if (mounted) setState(() {}); }),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: const Color(0xFF161616)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(m.resim, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A1A2E), child: const Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.white24, size: 48))),
                loadingBuilder: (_, child, p) => p == null ? child : Container(color: const Color(0xFF161616), child: const Center(child: CircularProgressIndicator(color: Color(0xFF0056b3), strokeWidth: 2))),
              ),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent]))),
              Positioned(bottom: 20, left: 20, right: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m.isim, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                Row(children: [
                  Text(m.tur, style: TextStyle(color: midnightBlue, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text('₺' * m.fiyatSeviyesi, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ]),
              ])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kucukKart(Mekan m) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(mekan: m))).then((_) { if (mounted) setState(() {}); }),
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: const Color(0xFF161616)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(m.resim, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A1A2E), child: const Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.white24, size: 24))),
            loadingBuilder: (_, child, p) => p == null ? child : Container(color: const Color(0xFF161616), child: const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Color(0xFF0056b3), strokeWidth: 2)))),
          ),
        ),
      ),
    );
  }

  Widget _trendMekanKarti(Mekan m, Color textColor, Color subtextColor) {
    return ListTile(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(mekan: m))).then((_) { if (mounted) setState(() {}); }),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(m.resim, width: 60, height: 60, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: const Color(0xFF1A1A2E), child: const Icon(Icons.image_not_supported_outlined, color: Colors.white24, size: 24)),
          loadingBuilder: (_, child, p) => p == null ? child : Container(width: 60, height: 60, color: const Color(0xFF161616), child: const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Color(0xFF0056b3), strokeWidth: 2)))),
        ),
      ),
      title: Text(m.isim, style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 18)),
      subtitle: Row(children: [
        Expanded(child: Text(m.adres, style: TextStyle(color: subtextColor, fontSize: 13), overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 6),
        Text('₺' * m.fiyatSeviyesi, style: const TextStyle(color: Color(0xFF0056b3), fontSize: 12, fontWeight: FontWeight.bold)),
      ]),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.star, color: Colors.amber, size: 16),
        const SizedBox(width: 2),
        Text(m.puan.toString(), style: TextStyle(color: textColor, fontSize: 13)),
      ]),
    );
  }
}
