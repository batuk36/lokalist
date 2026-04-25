import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tema_yonetici.dart';
import 'giris_gerekli.dart';

// web3forms.com → e-postanı gir → gelen maildeki linke tıkla → key'i buraya yapıştır
const String _web3formsKey = '669ac10d-5ac9-49da-bb37-4048ba708e2f';

class DestekPage extends StatefulWidget {
  const DestekPage({super.key});

  @override
  State<DestekPage> createState() => _DestekPageState();
}

class _DestekPageState extends State<DestekPage> {
  Future<void> _hataBildirimiGoster(bool dark) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool gonderiliyor = false;

    final textColor = dark ? Colors.white : Colors.black87;
    final bgColor = dark ? const Color(0xFF1A1A1A) : Colors.white;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          backgroundColor: bgColor,
          title: Row(
            children: [
              const Icon(Icons.bug_report, color: Colors.redAccent, size: 22),
              const SizedBox(width: 8),
              Text('Hata Bildir', style: TextStyle(color: textColor, fontSize: 18)),
            ],
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              maxLines: 5,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Karşılaştığınız sorunu açıklayın...',
                hintStyle: TextStyle(color: dark ? Colors.white38 : Colors.black38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: dark ? Colors.white24 : Colors.black26),
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Lütfen bir açıklama girin' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('İptal', style: TextStyle(color: dark ? Colors.white54 : Colors.black54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056b3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: gonderiliyor
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setDialog(() => gonderiliyor = true);
                      try {
                        final kullaniciEmail = FirebaseAuth.instance.currentUser?.email ?? 'Anonim';
                        final mesaj = controller.text.trim();

                        await FirebaseFirestore.instance
                            .collection('hata_bildirimleri')
                            .add({
                          'mesaj': mesaj,
                          'tarih': FieldValue.serverTimestamp(),
                          'kullanici_email': kullaniciEmail,
                          'kullanici_id': FirebaseAuth.instance.currentUser?.uid ?? '',
                        });

                        http.post(
                          Uri.parse('https://api.web3forms.com/submit'),
                          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
                          body: jsonEncode({
                            'access_key': _web3formsKey,
                            'subject': 'Lokatist - Yeni Hata Bildirimi',
                            'from_name': 'Lokatist App',
                            'email': kullaniciEmail,
                            'message': mesaj,
                          }),
                        );

                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Geri bildiriminiz iletildi, teşekkürler!'),
                              backgroundColor: Color(0xFF0056b3),
                            ),
                          );
                        }
                      } catch (_) {
                        setDialog(() => gonderiliyor = false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gönderilemedi, lütfen tekrar deneyin.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    },
              child: gonderiliyor
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Gönder', style: TextStyle(color: Colors.white)),
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
    final textColor = dark ? Colors.white : Colors.black87;
    final subtextColor = dark ? Colors.white54 : Colors.black54;
    const midnightBlue = Color(0xFF0056b3);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Destek ve Yardım', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Sık Sorulan Sorular',
            style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _sss(
            soru: 'Uygulama nasıl kullanılır?',
            cevap: 'Ana sayfadan mekanları keşfedebilir, favorilerine ekleyebilirsin. Sol menüden cafeler veya restoranlara göre filtreleme yapabilirsin.',
            dark: dark,
            textColor: textColor,
            subtextColor: subtextColor,
            onSoruIkonu: const Icon(Icons.help, color: Colors.redAccent, size: 20),
          ),
          _sss(
            soru: 'Mekan ekleyebilir miyim?',
            cevap: 'Favorilere basarak mekanları kendi listenize ekleyebilirsiniz.',
            dark: dark,
            textColor: textColor,
            subtextColor: subtextColor,
            onSoruIkonu: const Icon(Icons.add_location_alt, color: midnightBlue, size: 20),
          ),
          const SizedBox(height: 30),
          Text(
            'İletişim',
            style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.email, color: midnightBlue),
            title: Text('desteklokatist@gmail.com', style: TextStyle(color: subtextColor)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                if (FirebaseAuth.instance.currentUser == null) {
                  girisGerekliGoster(context);
                } else {
                  _hataBildirimiGoster(dark);
                }
              },
              icon: const Icon(Icons.bug_report, color: Colors.redAccent),
              label: const Text(
                'Hata Bildir',
                style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.redAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sss({
    required String soru,
    required String cevap,
    required bool dark,
    required Color textColor,
    required Color subtextColor,
    required Widget onSoruIkonu,
  }) {
    return ExpansionTile(
      leading: onSoruIkonu,
      title: Text(soru, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
      iconColor: textColor,
      collapsedIconColor: subtextColor,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(cevap, style: TextStyle(color: subtextColor)),
        ),
      ],
    );
  }
}
