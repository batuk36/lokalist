import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'tema_yonetici.dart';

// !! Kendi WhatsApp numaranızı buraya girin (90 ile başlayan, boşuksuz)
const String _wpNumara = '905XXXXXXXXXX';

class BusinessPackagePage extends StatefulWidget {
  const BusinessPackagePage({super.key});

  @override
  State<BusinessPackagePage> createState() => _BusinessPackagePageState();
}

class _BusinessPackagePageState extends State<BusinessPackagePage> {
  int _secilenPaket = -1;

  static final List<_Paket> _paketler = [
    _Paket(
      isim: 'Ücretsiz',
      altBaslik: 'Giriş Seviyesi',
      fiyat: 'Ücretsiz',
      periyot: null,
      baslikRenk1: const Color(0xFF3A3A3A),
      baslikRenk2: const Color(0xFF555555),
      vurguRenk: const Color(0xFF888888),
      ozellikler: [
        _Ozellik('Temel listeleme (isim, adres, telefon)', true),
        _Ozellik('Arama sonuçlarında görünme', true),
        _Ozellik('Fotoğraf yükleme', false),
        _Ozellik('Sosyal medya & web sitesi linkleri', false),
        _Ozellik('Menü ekleme', false),
        _Ozellik('Analiz ve raporlar', false),
      ],
    ),
    _Paket(
      isim: 'Standart',
      altBaslik: 'Büyüyen İşletmeler İçin',
      fiyat: '1.500 TL',
      periyot: '/ Aylık',
      baslikRenk1: const Color(0xFF003d82),
      baslikRenk2: const Color(0xFF0073e6),
      vurguRenk: const Color(0xFF0056b3),
      ozellikler: [
        _Ozellik('Öncelikli listeleme (orta sıralarda görünme)', true),
        _Ozellik('Sınırsız fotoğraf yükleme ve menü ekleme', true),
        _Ozellik('Instagram, WhatsApp ve web sitesi linkleri', true),
        _Ozellik('Haftalık ziyaretçi ve yol tarifi raporu', true),
        _Ozellik('Ayda 1 kampanya veya etkinlik duyurusu', true),
        _Ozellik('Kullanıcılar tek tıkla mekanı arayabilir', true),
      ],
    ),
    _Paket(
      isim: 'Premium',
      altBaslik: 'Lokatist Gold',
      fiyat: '3.000 TL',
      periyot: '/ Aylık',
      baslikRenk1: const Color(0xFF7B5A00),
      baslikRenk2: const Color(0xFFDAA520),
      vurguRenk: const Color(0xFFFFD700),
      premium: true,
      ozellikler: [
        _Ozellik('Kategori ve bölgede her zaman ilk 3 sıra', true),
        _Ozellik('Ayda 2 push bildirim (2-5 km çevresi)', true),
        _Ozellik('Sınırsız kampanya yönetimi (Happy Hour, İndirim...)', true),
        _Ozellik('Detaylı demografi ve yoğun saat analiz paneli', true),
        _Ozellik('"Lokatist Gold" onaylı işletme rozeti', true),
        _Ozellik('Haritada öne çıkan özel ikon', true),
        _Ozellik('7/24 VIP öncelikli destek hattı', true),
      ],
    ),
  ];

  Future<void> _wpAc() async {
    final paket = _paketler[_secilenPaket];
    final mesaj =
        'Merhaba! 👋\n\n'
        'Lokatist uygulamasından "${paket.isim} Paket" (${paket.fiyat}${paket.periyot != null ? ' ${paket.periyot}' : ''}) almak istiyorum.\n\n'
        'Ödeme bilgilerini (IBAN vb.) paylaşabilir misiniz?';
    final url = Uri.parse(
        'https://wa.me/$_wpNumara?text=${Uri.encodeComponent(mesaj)}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('WhatsApp açılamadı.'),
              backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.watch<TemaYonetici>().karanlikMod;
    final bgColor =
        dark ? const Color(0xFF0A0A0A) : const Color(0xFFF2F4F8);
    final textColor = dark ? Colors.white : Colors.black87;
    final subtextColor = dark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: _secilenPaket > 0
          ? _yukselButonu(_paketler[_secilenPaket])
          : null,
      body: CustomScrollView(
        slivers: [
          // — Header —
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF003d82),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF001f4d), Color(0xFF0056b3), Color(0xFF1a7de0)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.business_center,
                            color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'LOKATİST Business',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          'Mekanınızı binlerce kişiye duyurmaya\nhazır mısınız?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // — Paket Kartları —
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Bir paket seçin',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                ),
                for (int i = 0; i < _paketler.length; i++)
                  _paketKarti(i, dark, textColor, subtextColor),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paketKarti(
      int index, bool dark, Color textColor, Color subtextColor) {
    final paket = _paketler[index];
    final secili = _secilenPaket == index;

    return GestureDetector(
      onTap: () => setState(() => _secilenPaket = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF161616) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: secili ? paket.vurguRenk : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: secili
                  ? paket.vurguRenk.withOpacity(0.35)
                  : Colors.black.withOpacity(dark ? 0.3 : 0.08),
              blurRadius: secili ? 18 : 10,
              spreadRadius: secili ? 1 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kart başlığı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [paket.baslikRenk1, paket.baslikRenk2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              paket.isim,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            if (paket.premium) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.white, size: 11),
                                    SizedBox(width: 3),
                                    Text('GOLD',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          paket.altBaslik,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        paket.fiyat,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      if (paket.periyot != null)
                        Text(
                          paket.periyot!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Özellik listesi
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                children: paket.ozellikler
                    .map((o) => _ozellikSatiri(o, paket.vurguRenk, textColor, subtextColor))
                    .toList(),
              ),
            ),

            // Seçiliyse ve ücretsiz pakette ise bilgi
            if (secili && index == 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Şu an bu paketi kullanıyorsunuz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _ozellikSatiri(
      _Ozellik o, Color vurguRenk, Color textColor, Color subtextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: o.aktif ? vurguRenk : Colors.grey.shade300,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              o.metin,
              style: TextStyle(
                color: o.aktif ? textColor : subtextColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _yukselButonu(_Paket paket) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: _wpAc,
          icon: const Icon(Icons.chat_rounded, color: Colors.white, size: 22),
          label: Text(
            'Hemen Yükselt  —  ${paket.isim} ${paket.fiyat}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF25D366),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

class _Paket {
  final String isim;
  final String altBaslik;
  final String fiyat;
  final String? periyot;
  final Color baslikRenk1;
  final Color baslikRenk2;
  final Color vurguRenk;
  final bool premium;
  final List<_Ozellik> ozellikler;

  const _Paket({
    required this.isim,
    required this.altBaslik,
    required this.fiyat,
    required this.periyot,
    required this.baslikRenk1,
    required this.baslikRenk2,
    required this.vurguRenk,
    this.premium = false,
    required this.ozellikler,
  });
}

class _Ozellik {
  final String metin;
  final bool aktif;
  const _Ozellik(this.metin, this.aktif);
}
