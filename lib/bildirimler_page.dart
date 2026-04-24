import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tema_yonetici.dart';

class BildirimlerPage extends StatefulWidget {
  const BildirimlerPage({super.key});

  @override
  State<BildirimlerPage> createState() => _BildirimlerPageState();
}

class _BildirimlerPageState extends State<BildirimlerPage> {
  final List<Map<String, dynamic>> _bildirimler = [
    {
      'baslik': 'Çevrende popüler mekanlar var!',
      'icerik': 'Cebeci\'de 5 yıldızlı 3 mekan seni bekliyor. Hemen keşfet!',
      'zaman': '2 saat önce',
      'ikon': Icons.location_on,
      'renk': Color(0xFF0056b3),
      'okundu': false,
      'hedef': 'populer',
    },
    {
      'baslik': 'Yeni mekanlar eklendi!',
      'icerik': 'Kurtuluş bölgesinde yeni restoranlar ve kafeler Lokatist\'te yerini aldı.',
      'zaman': '5 saat önce',
      'ikon': Icons.store,
      'renk': Colors.green,
      'okundu': false,
      'hedef': 'yeni',
    },
    {
      'baslik': 'Favori mekanın açık!',
      'icerik': 'Angora Coffee bugün 09:00\'da kapılarını açtı. İyi kahveler!',
      'zaman': '1 gün önce',
      'ikon': Icons.favorite,
      'renk': Colors.redAccent,
      'okundu': true,
      'hedef': 'favoriler',
    },
    {
      'baslik': 'Hafta sonu önerileri',
      'icerik': 'Bu hafta sonu için Cebeci\'nin en iyi 5 mekanını seçtik. Kaçırma!',
      'zaman': '2 gün önce',
      'ikon': Icons.weekend,
      'renk': Colors.orange,
      'okundu': true,
      'hedef': 'oneri',
    },
    {
      'baslik': 'Lokatist\'e hoş geldin!',
      'icerik': 'Ankara\'nın en iyi mekanlarını keşfetmeye hazır mısın? Başlayalım!',
      'zaman': '5 gün önce',
      'ikon': Icons.waving_hand,
      'renk': Color(0xFF0056b3),
      'okundu': true,
      'hedef': null,
    },
  ];

  int get _okunmamisSayi => _bildirimler.where((b) => !(b['okundu'] as bool)).length;

  void _hepsiniOku() {
    setState(() {
      for (final b in _bildirimler) {
        b['okundu'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.watch<TemaYonetici>().karanlikMod;
    final bgColor = dark ? const Color(0xFF0A0A0A) : Colors.white;
    final surfaceColor = dark ? const Color(0xFF161616) : Colors.grey.shade100;
    final textColor = dark ? Colors.white : Colors.black87;
    final subtextColor = dark ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Bildirimler'),
            if (_okunmamisSayi > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0056b3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_okunmamisSayi yeni',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_okunmamisSayi > 0)
            TextButton(
              onPressed: _hepsiniOku,
              child: const Text('Tümünü Oku', style: TextStyle(color: Color(0xFF0056b3))),
            ),
        ],
      ),
      body: _bildirimler.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 64, color: subtextColor),
                  const SizedBox(height: 12),
                  Text('Henüz bildirim yok', style: TextStyle(color: subtextColor, fontSize: 16)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _bildirimler.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: dark ? Colors.white12 : Colors.black12,
                indent: 72,
              ),
              itemBuilder: (context, index) {
                final b = _bildirimler[index];
                final okundu = b['okundu'] as bool;

                return InkWell(
                  onTap: () {
                    setState(() => _bildirimler[index]['okundu'] = true);
                    final hedef = b['hedef'] as String?;
                    if (hedef != null) {
                      Navigator.pop(context, hedef);
                    }
                  },
                  child: Container(
                    color: okundu ? Colors.transparent : (dark ? Colors.white.withOpacity(0.04) : const Color(0xFF0056b3).withOpacity(0.05)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (b['renk'] as Color).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(b['ikon'] as IconData, color: b['renk'] as Color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      b['baslik'] as String,
                                      style: TextStyle(
                                        fontWeight: okundu ? FontWeight.normal : FontWeight.bold,
                                        color: textColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  if (!okundu)
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(left: 6, top: 4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0056b3),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                b['icerik'] as String,
                                style: TextStyle(color: subtextColor, fontSize: 13),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                b['zaman'] as String,
                                style: TextStyle(color: subtextColor, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
