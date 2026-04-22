import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';
import 'drawer_menu.dart';
import 'detail_page.dart';
import 'ayarlar_page.dart';
import 'auth_servisi.dart';
import 'giris_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Mekan> gosterilenMekanlar = List.from(tumMekanlarListesi);
  String mevcutKategori = "Hepsi";
  final Color midnightBlue = const Color(0xFF0056b3);
  Position? kullaniciKonumu;

  TextEditingController aramaController = TextEditingController();
  String aramaKelimesi = "";

  @override
  void initState() {
    super.initState();
    _konumAl();
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
    setState(() {
      kullaniciKonumu = konum;
    });
  }

  List<Mekan> _enYakinMekanlar() {
    if (kullaniciKonumu == null) return tumMekanlarListesi;

    List<Mekan> siralananlar = List.from(tumMekanlarListesi);
    siralananlar.sort((a, b) {
      double mesafeA = Geolocator.distanceBetween(
        kullaniciKonumu!.latitude, kullaniciKonumu!.longitude,
        a.enlem, a.boylam,
      );
      double mesafeB = Geolocator.distanceBetween(
        kullaniciKonumu!.latitude, kullaniciKonumu!.longitude,
        b.enlem, b.boylam,
      );
      return mesafeA.compareTo(mesafeB);
    });
    return siralananlar.take(10).toList();
  }

  void _filtrele(String kategori) {
    setState(() {
      mevcutKategori = kategori;
      aramaController.clear();
      aramaKelimesi = "";

      if (kategori == 'Hepsi') {
        gosterilenMekanlar = List.from(tumMekanlarListesi);
      } else if (kategori == 'Favoriler') {
        gosterilenMekanlar = tumMekanlarListesi.where((m) => m.isFavorite).toList();
      } else {
        gosterilenMekanlar = tumMekanlarListesi.where((m) => m.tur == kategori).toList();
      }
    });
  }

  void _aramaYap(String kelime) {
    setState(() {
      aramaKelimesi = kelime.toLowerCase();
      gosterilenMekanlar = tumMekanlarListesi.where((m) {
        final isim = m.isim.toLowerCase();
        final aramaUygun = isim.contains(aramaKelimesi);

        if (mevcutKategori == "Hepsi") return aramaUygun;
        if (mevcutKategori == "Favoriler") return m.isFavorite && aramaUygun;
        return m.tur == mevcutKategori && aramaUygun;
      }).toList();
    });
  }

  void _profilGoster() {
    final kullanici = FirebaseAuth.instance.currentUser;
    final ad = kullanici?.displayName ?? 'Misafir';
    final email = kullanici?.email ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFF0056b3),
              child: Text(
                ad.isNotEmpty ? ad[0].toUpperCase() : 'L',
                style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(ad,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text(email,
                style:
                    const TextStyle(fontSize: 13, color: Colors.white38)),
            const SizedBox(height: 20),
            ListTile(
              leading:
                  const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Çıkış Yap',
                  style: TextStyle(color: Colors.redAccent, fontSize: 16)),
              onTap: () async {
                Navigator.pop(ctx);
                await AuthServisi.cikisYap();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const GirisPage()),
                    (_) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      drawer: YanMenu(
        onKategoriSec: _filtrele,
        onProfilTikla: _profilGoster,
        onAyarlarTikla: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AyarlarPage()));
        },
        onRastgeleSec: () {
          final random = Random();
          final m = tumMekanlarListesi[random.nextInt(tumMekanlarListesi.length)];
          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(mekan: m)));
        },
      ),
      appBar: AppBar(
        title: Text('LOKATİST', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: midnightBlue)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Henüz bildirim yok')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextField(
                controller: aramaController,
                onChanged: _aramaYap,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Mekan ara...",
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0056b3)),
                  filled: true,
                  fillColor: const Color(0xFF161616),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  suffixIcon: aramaKelimesi.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white38),
                    onPressed: () { aramaController.clear(); _aramaYap(""); },
                  )
                      : null,
                ),
              ),
            ),
            if (mevcutKategori == 'Favoriler')
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Favorilerim", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 20),
                    if (gosterilenMekanlar.isEmpty)
                      const Center(child: Text("\nHenüz favori eklemedin bro!", style: TextStyle(color: Colors.white54)))
                    else
                      ...gosterilenMekanlar.map((m) => _trendMekanKarti(m)),
                  ],
                ),
              )
            else ...[
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text("Öne Çıkanlar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white70)),
              ),
              SizedBox(
                height: 350,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.85),
                  itemCount: gosterilenMekanlar.length > 5 ? 5 : gosterilenMekanlar.length,
                  itemBuilder: (context, index) => _premiumKart(gosterilenMekanlar[index]),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("Sana En Yakınlar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 15),
                  itemCount: _enYakinMekanlar().length,
                  itemBuilder: (context, index) => _kucukKart(_enYakinMekanlar()[index]),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text("Trend Mekanlar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gosterilenMekanlar.length,
                itemBuilder: (context, index) => _trendMekanKarti(gosterilenMekanlar[index]),
              ),
            ],
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _premiumKart(Mekan m) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(image: NetworkImage(m.resim), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent]),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(m.isim, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(m.tur, style: TextStyle(color: midnightBlue, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _kucukKart(Mekan m) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(mekan: m))),
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: NetworkImage(m.resim), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _trendMekanKarti(Mekan m) {
    return ListTile(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(mekan: m))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(m.resim, width: 60, height: 60, fit: BoxFit.cover),
      ),
      title: Text(m.isim, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
      subtitle: Text(m.adres, style: const TextStyle(color: Colors.white38, fontSize: 14)),
      trailing: const Icon(Icons.star, color: Colors.amber, size: 20),
    );
  }
}