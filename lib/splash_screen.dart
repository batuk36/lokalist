import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_servisi.dart';
import 'kullanici_servisi.dart';
import 'mekan_servisi.dart';
import 'home_page.dart';
import 'giris_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _kontrol();
  }

  Future<void> _kontrol() async {
    await Future.wait([
      MekanServisi.yukle(),
      Future.delayed(const Duration(seconds: 2)),
    ]);
    if (!mounted) return;

    final User? kullanici = AuthServisi.mevcutKullanici;
    if (kullanici != null) {
      await KullaniciServisi.favorileriUygula(kullanici.uid);
      final favoriler = KullaniciServisi.cachedFavoriler;
      for (final m in MekanServisi.mekanlar) {
        m.isFavorite = favoriler.contains(m.isim);
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GirisPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4A574).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset('assets/images/app_icon.png',
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "LOKATİST",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4A574),
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Mekanını Keşfet",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4A574)),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
