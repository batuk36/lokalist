import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_servisi.dart';
import 'destek_page.dart';
import 'giris_page.dart';

class YanMenu extends StatelessWidget {
  final Function(String) onKategoriSec;
  final VoidCallback onProfilTikla;
  final VoidCallback onAyarlarTikla;
  final VoidCallback onRastgeleSec;

  const YanMenu({
    super.key,
    required this.onKategoriSec,
    required this.onProfilTikla,
    required this.onAyarlarTikla,
    required this.onRastgeleSec,
  });

  @override
  Widget build(BuildContext context) {
    const midnightBlue = Color(0xFF0056b3);
    final kullanici = FirebaseAuth.instance.currentUser;
    final ad = kullanici?.displayName ?? 'Misafir';
    final email = kullanici?.email ?? '';
    final harf = ad.isNotEmpty ? ad[0].toUpperCase() : 'L';

    return Drawer(
      child: Container(
        color: const Color(0xFF0A0A0A),
        child: Column(
          children: [
            GestureDetector(
              onTap: onProfilTikla,
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFF121212)),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: midnightBlue,
                  child: Text(
                    harf,
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                accountName: Text(
                  ad,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  email,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: midnightBlue, size: 30),
              title: const Text('Ana Sayfa', style: TextStyle(fontSize: 22)),
              onTap: () {
                Navigator.pop(context);
                onKategoriSec('Hepsi');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite,
                  color: Colors.redAccent, size: 30),
              title: const Text('Favoriler', style: TextStyle(fontSize: 22)),
              onTap: () {
                Navigator.pop(context);
                onKategoriSec('Favoriler');
              },
            ),
            ListTile(
              leading: const Icon(Icons.coffee, color: midnightBlue, size: 30),
              title: const Text('Cafeler', style: TextStyle(fontSize: 22)),
              onTap: () {
                Navigator.pop(context);
                onKategoriSec('Cafeler');
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading:
                  const Icon(Icons.restaurant, color: midnightBlue, size: 30),
              title:
                  const Text('Restoranlar', style: TextStyle(fontSize: 22)),
              onTap: () {
                Navigator.pop(context);
                onKategoriSec('Restoranlar');
              },
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(Icons.auto_awesome,
                  color: Colors.amber, size: 30),
              title: const Text('Beni Oraya Götür!',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                onRastgeleSec();
              },
            ),
            const Spacer(),
            ListTile(
              leading:
                  const Icon(Icons.settings, color: Colors.grey, size: 30),
              title: const Text('Ayarlar', style: TextStyle(fontSize: 22)),
              onTap: onAyarlarTikla,
            ),
            ListTile(
              leading: const Icon(Icons.contact_support,
                  color: midnightBlue, size: 30),
              title: const Text('Destek ve Yardım',
                  style: TextStyle(fontSize: 22)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DestekPage()));
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.logout, color: Colors.redAccent, size: 30),
              title: const Text('Çıkış Yap',
                  style:
                      TextStyle(fontSize: 22, color: Colors.redAccent)),
              onTap: () async {
                Navigator.pop(context);
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
