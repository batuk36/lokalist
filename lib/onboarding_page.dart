import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _mevcut = 0;

  static const _sayfalar = [
    _SayfaVeri(
      ikon: Icons.explore_rounded,
      renk: Color(0xFF0056b3),
      baslik: 'Mekanları Keşfet',
      aciklama:
          'Ankara\'daki en iyi kafeleri ve restoranları tek bir uygulamada keşfet.',
    ),
    _SayfaVeri(
      ikon: Icons.favorite_rounded,
      renk: Colors.redAccent,
      baslik: 'Favorilerine Ekle',
      aciklama:
          'Beğendiğin mekanları favorilere ekle, dilediğin zaman hızlıca ulaş.',
    ),
    _SayfaVeri(
      ikon: Icons.map_rounded,
      renk: Color(0xFF00A86B),
      baslik: 'Yol Tarifi Al',
      aciklama:
          'Tek tuşla Google Maps\'e yönlen, mekanı ara veya arkadaşlarınla paylaş.',
    ),
  ];

  Future<void> _bitir() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sonSayfa = _mevcut == _sayfalar.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _bitir,
                child: const Text('Geç',
                    style:
                        TextStyle(color: Colors.white38, fontSize: 15)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _sayfalar.length,
                onPageChanged: (i) => setState(() => _mevcut = i),
                itemBuilder: (_, i) => _Sayfa(veri: _sayfalar[i]),
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _sayfalar.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _mevcut == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _mevcut == i
                        ? _sayfalar[i].renk
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (sonSayfa) {
                      _bitir();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _sayfalar[_mevcut].renk,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    sonSayfa ? 'Başla' : 'Devam Et',
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Sayfa extends StatelessWidget {
  final _SayfaVeri veri;
  const _Sayfa({required this.veri});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: veri.renk.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(veri.ikon, color: veri.renk, size: 70),
          ),
          const SizedBox(height: 48),
          Text(
            veri.baslik,
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            veri.aciklama,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.white54,
                height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SayfaVeri {
  final IconData ikon;
  final Color renk;
  final String baslik;
  final String aciklama;

  const _SayfaVeri({
    required this.ikon,
    required this.renk,
    required this.baslik,
    required this.aciklama,
  });
}
