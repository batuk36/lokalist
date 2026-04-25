import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'kullanici_servisi.dart';
import 'tema_yonetici.dart';
import 'giris_gerekli.dart';

class DetailPage extends StatefulWidget {
  final Mekan mekan;
  const DetailPage({super.key, required this.mekan});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _kullaniciPuani = 0;

  @override
  void initState() {
    super.initState();
    _puanYukle();
  }

  Future<void> _puanYukle() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final puan = await KullaniciServisi.puanGetir(uid, widget.mekan.isim);
    if (mounted) setState(() => _kullaniciPuani = puan);
  }

  Future<void> _puanVer(int puan) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() => _kullaniciPuani = puan);
    await KullaniciServisi.puanKaydet(uid, widget.mekan.isim, puan);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$puan yıldız verdiniz!'), backgroundColor: const Color(0xFF0056b3), duration: const Duration(seconds: 2)),
      );
    }
  }

  String get _paylasMesaji =>
      '${widget.mekan.isim} mekanını Lokatist\'te keşfet! 📍\n'
      '${widget.mekan.adres}\n\n'
      'Haritada gör 👉 https://maps.google.com/?q=${widget.mekan.enlem},${widget.mekan.boylam}';

  String get _haritaLinki =>
      'https://maps.google.com/?q=${widget.mekan.enlem},${widget.mekan.boylam}';

  void _sosyalMedyaPaylasimGoster() {
    if (FirebaseAuth.instance.currentUser == null) {
      girisGerekliGoster(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('Paylaş', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _platformButon(
                  renk: const Color(0xFF25D366),
                  etiket: 'WhatsApp',
                  ikon: Icons.chat,
                  onTap: () async {
                    Navigator.pop(ctx);
                    final url = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(_paylasMesaji)}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      Share.share(_paylasMesaji);
                    }
                  },
                ),
                _platformButon(
                  renk: const Color(0xFF2AABEE),
                  etiket: 'Telegram',
                  ikon: Icons.send,
                  onTap: () async {
                    Navigator.pop(ctx);
                    final url = Uri.parse(
                      'https://t.me/share/url?url=${Uri.encodeComponent(_haritaLinki)}&text=${Uri.encodeComponent('${widget.mekan.isim} - ${widget.mekan.adres}')}',
                    );
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),
                _platformButon(
                  renk: Colors.black,
                  etiket: 'Twitter/X',
                  ikon: Icons.tag,
                  onTap: () async {
                    Navigator.pop(ctx);
                    final url = Uri.parse(
                      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(_paylasMesaji)}',
                    );
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),
                _platformButon(
                  renk: const Color(0xFFE1306C),
                  etiket: 'Instagram',
                  ikon: Icons.camera_alt,
                  onTap: () async {
                    Navigator.pop(ctx);
                    await Clipboard.setData(ClipboardData(text: _paylasMesaji));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Metin kopyalandı! Instagram\'da yapıştırabilirsin.'),
                          backgroundColor: Color(0xFFE1306C),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: _genisPlatformButon(
                  renk: const Color(0xFF0056b3),
                  etiket: 'Linki Kopyala',
                  ikon: Icons.link,
                  onTap: () async {
                    Navigator.pop(ctx);
                    await Clipboard.setData(ClipboardData(text: _haritaLinki));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link kopyalandı!'), backgroundColor: Color(0xFF0056b3)),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _genisPlatformButon(
                  renk: const Color(0xFF333333),
                  etiket: 'Diğer',
                  ikon: Icons.more_horiz,
                  onTap: () { Navigator.pop(ctx); Share.share(_paylasMesaji, subject: widget.mekan.isim); },
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _platformButon({required Color renk, required String etiket, required IconData ikon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: renk, shape: BoxShape.circle),
            child: Icon(ikon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 6),
          Text(etiket, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _genisPlatformButon({required Color renk, required String etiket, required IconData ikon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: renk, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(etiket, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _haritaAc() async {
    if (FirebaseAuth.instance.currentUser == null) {
      girisGerekliGoster(context);
      return;
    }
    final Uri url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${widget.mekan.enlem},${widget.mekan.boylam}'
      '&destination_place_name=${Uri.encodeComponent(widget.mekan.isim)}',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harita uygulaması açılamadı')));
    }
  }

  Future<void> _ara() async {
    if (FirebaseAuth.instance.currentUser == null) {
      girisGerekliGoster(context);
      return;
    }
    final Uri tel = Uri.parse('tel:${widget.mekan.telefon}');
    if (!await launchUrl(tel)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Arama yapılamadı')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.watch<TemaYonetici>().karanlikMod;
    final bgColor = dark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = dark ? Colors.white : Colors.black87;
    final subtextColor = dark ? Colors.white54 : Colors.black54;
    final titleColor = dark ? Colors.blueAccent : const Color(0xFF0056b3);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.mekan.resim, height: 300, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 300, width: double.infinity, color: const Color(0xFF1A1A2E), child: const Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.white24, size: 64))),
                  loadingBuilder: (_, child, p) => p == null ? child : Container(height: 300, width: double.infinity, color: const Color(0xFF1E1E1E), child: const Center(child: CircularProgressIndicator(color: Color(0xFF0056b3)))),
                ),
                Positioned(top: 40, left: 20, child: CircleAvatar(backgroundColor: Colors.black54, child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)))),
                Positioned(top: 40, right: 70, child: CircleAvatar(backgroundColor: Colors.black54, child: IconButton(icon: const Icon(Icons.share_outlined, color: Colors.white), onPressed: _sosyalMedyaPaylasimGoster, tooltip: 'Paylaş'))),
                Positioned(top: 40, right: 20, child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: Icon(widget.mekan.isFavorite ? Icons.favorite : Icons.favorite_border, color: widget.mekan.isFavorite ? Colors.red : Colors.white),
                    onPressed: () async {
                      final uid = FirebaseAuth.instance.currentUser?.uid;
                      if (uid == null) {
                        girisGerekliGoster(context);
                        return;
                      }
                      setState(() => widget.mekan.isFavorite = !widget.mekan.isFavorite);
                      await KullaniciServisi.favoriGuncelle(uid, widget.mekan.isim, widget.mekan.isFavorite);
                    },
                  ),
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.mekan.isim, style: TextStyle(color: titleColor, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text('${widget.mekan.puan} (120+ Yorum)', style: TextStyle(color: subtextColor, fontSize: 15)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFF0056b3).withOpacity(0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF0056b3).withOpacity(0.5))),
                      child: Text('₺' * widget.mekan.fiyatSeviyesi, style: const TextStyle(color: Color(0xFF0056b3), fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [Icon(Icons.location_on, color: subtextColor, size: 18), const SizedBox(width: 5), Expanded(child: Text(widget.mekan.adres, style: TextStyle(color: subtextColor)))]),
                  const SizedBox(height: 8),
                  Row(children: [const Icon(Icons.access_time_filled, color: Colors.green, size: 18), const SizedBox(width: 5), Text('Şu an Açık · Kapanış: ${widget.mekan.acilisSaati.split('-')[1]}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))]),
                  const SizedBox(height: 25),

                  // Puan bölümü
                  Text('Puanınız', style: TextStyle(color: subtextColor, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: List.generate(5, (i) {
                    final y = i + 1;
                    return GestureDetector(
                      onTap: () => _puanVer(y),
                      child: Padding(padding: const EdgeInsets.only(right: 6), child: Icon(y <= _kullaniciPuani ? Icons.star : Icons.star_border, color: Colors.amber, size: 38)),
                    );
                  })),
                  if (_kullaniciPuani > 0) Padding(padding: const EdgeInsets.only(top: 6), child: Text('$_kullaniciPuani/5 puan verdiniz', style: TextStyle(color: subtextColor, fontSize: 13))),
                  const SizedBox(height: 25),

                  // Butonlar
                  Row(children: [
                    Expanded(flex: 2, child: ElevatedButton.icon(onPressed: _haritaAc, icon: const Icon(Icons.map), label: const Text('Beni Oraya Götür'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 15)))),
                    const SizedBox(width: 10),
                    Expanded(child: ElevatedButton.icon(onPressed: _ara, icon: const Icon(Icons.phone), label: const Text('Ara'), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 15)))),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _sosyalMedyaPaylasimGoster,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0056b3), padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Icon(Icons.share_outlined, color: Colors.white),
                    ),
                  ]),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
