import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'tema_yonetici.dart';
import 'auth_servisi.dart';
import 'business_package_page.dart';
import 'destek_page.dart';
import 'giris_page.dart';
import 'giris_gerekli.dart';

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
    final bool dark = context.watch<TemaYonetici>().karanlikMod;
    final bgColor = dark ? const Color(0xFF0A0A0A) : Colors.white;
    final headerBgColor = dark ? const Color(0xFF121212) : midnightBlue;
    final textColor = dark ? Colors.white : Colors.black87;
    final dividerColor = dark ? Colors.white12 : Colors.black12;

    final kullanici = FirebaseAuth.instance.currentUser;
    final ad = kullanici?.displayName ?? 'Misafir';
    final email = kullanici?.email ?? '';
    final harf = ad.isNotEmpty ? ad[0].toUpperCase() : 'L';

    return Drawer(
      child: Container(
        color: bgColor,
        child: Column(
          children: [
            GestureDetector(
              onTap: onProfilTikla,
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: headerBgColor),
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
              title: Text('Ana Sayfa', style: TextStyle(fontSize: 22, color: textColor)),
              onTap: () {
                Navigator.pop(context);
                onKategoriSec('Hepsi');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite,
                  color: Colors.redAccent, size: 30),
              title: Text('Favoriler', style: TextStyle(fontSize: 22, color: textColor)),
              onTap: () {
                Navigator.pop(context);
                if (FirebaseAuth.instance.currentUser == null) {
                  girisGerekliGoster(context);
                } else {
                  onKategoriSec('Favoriler');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.coffee, color: midnightBlue, size: 30),
              title: Text('Cafeler', style: TextStyle(fontSize: 22, color: textColor)),
              onTap: () {
                Navigator.pop(context);
                onKategoriSec('Cafe');
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading:
                  const Icon(Icons.restaurant, color: midnightBlue, size: 30),
              title: Text('Restoranlar', style: TextStyle(fontSize: 22, color: textColor)),
              onTap: () {
                Navigator.pop(context);
                onKategoriSec('Restoran');
              },
            ),
            Divider(color: dividerColor),
            ListTile(
              leading: const Icon(Icons.auto_awesome,
                  color: Colors.amber, size: 30),
              title: Text('Beni Oraya Götür!',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
              onTap: () {
                Navigator.pop(context);
                if (FirebaseAuth.instance.currentUser == null) {
                  girisGerekliGoster(context);
                } else {
                  onRastgeleSec();
                }
              },
            ),
            const Spacer(),
            if (!Platform.isIOS)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF003d82), Color(0xFF0073e6)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: const Icon(Icons.business_center, color: Colors.white, size: 26),
                  title: const Text(
                    'LOKATİST Business',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessPackagePage()));
                  },
                ),
              ),
            ListTile(
              leading:
                  const Icon(Icons.settings, color: Colors.grey, size: 30),
              title: Text('Ayarlar', style: TextStyle(fontSize: 22, color: textColor)),
              onTap: onAyarlarTikla,
            ),
            ListTile(
              leading: const Icon(Icons.contact_support,
                  color: midnightBlue, size: 30),
              title: Text('Destek ve Yardım',
                  style: TextStyle(fontSize: 22, color: textColor)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DestekPage()));
              },
            ),
            if (kullanici != null)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent, size: 30),
                title: const Text('Çıkış Yap', style: TextStyle(fontSize: 22, color: Colors.redAccent)),
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
