import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tema_yonetici.dart';
import 'auth_servisi.dart';
import 'giris_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool _yukleniyor = false;

  User? get _kullanici => FirebaseAuth.instance.currentUser;

  Future<void> _adDuzenle(bool dark) async {
    if (_kullanici == null) return;
    final controller =
        TextEditingController(text: _kullanici!.displayName ?? '');

    final yeniAd = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dark ? const Color(0xFF1A1A1A) : Colors.white,
        title: Text('Adı Düzenle',
            style:
                TextStyle(color: dark ? Colors.white : Colors.black87)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style:
              TextStyle(color: dark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: 'Ad Soyad',
            hintStyle: TextStyle(
                color: dark ? Colors.white38 : Colors.black38),
            filled: true,
            fillColor: dark
                ? const Color(0xFF161616)
                : Colors.grey.shade100,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('İptal',
                  style: TextStyle(
                      color: dark
                          ? Colors.white38
                          : Colors.black38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0056b3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () =>
                Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Kaydet',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (yeniAd == null || yeniAd.isEmpty) return;
    setState(() => _yukleniyor = true);
    try {
      await _kullanici!.updateDisplayName(yeniAd);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_kullanici!.uid)
          .update({'displayName': yeniAd});
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Güncelleme başarısız'),
            backgroundColor: Colors.redAccent));
      }
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  Future<void> _sifreDegistir() async {
    final email = _kullanici?.email;
    if (email == null) return;
    try {
      await AuthServisi.sifreSifirla(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '$email adresine şifre sıfırlama bağlantısı gönderildi.'),
          backgroundColor: const Color(0xFF0056b3),
        ));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Gönderilemedi. Tekrar deneyin.'),
            backgroundColor: Colors.redAccent));
      }
    }
  }

  Future<void> _hesapSil(bool dark) async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dark ? const Color(0xFF1A1A1A) : Colors.white,
        title: const Text('Hesabı Sil',
            style: TextStyle(color: Colors.redAccent)),
        content: Text(
          'Bu işlem geri alınamaz. Hesabın ve tüm verilerin kalıcı olarak silinecek.',
          style: TextStyle(
              color: dark ? Colors.white70 : Colors.black54),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Vazgeç',
                  style: TextStyle(
                      color: dark
                          ? Colors.white54
                          : Colors.black54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sil',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (onay != true) return;
    setState(() => _yukleniyor = true);
    try {
      final uid = _kullanici!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .delete();
      await _kullanici!.delete();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const GirisPage()),
          (_) => false,
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Hesap silinemedi. Tekrar giriş yapıp deneyin.'),
          backgroundColor: Colors.redAccent,
        ));
        setState(() => _yukleniyor = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = context.watch<TemaYonetici>().karanlikMod;
    final bgColor = dark ? const Color(0xFF0A0A0A) : Colors.white;
    final textColor = dark ? Colors.white : Colors.black87;
    final subtextColor = dark ? Colors.white54 : Colors.black54;
    final surfaceColor =
        dark ? const Color(0xFF161616) : Colors.grey.shade100;
    const blue = Color(0xFF0056b3);

    final kullanici = _kullanici;
    final ad = kullanici?.displayName ?? 'Kullanıcı';
    final email = kullanici?.email ?? '';
    final harf = ad.isNotEmpty ? ad[0].toUpperCase() : 'L';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Profilim', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: _yukleniyor
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF0056b3)))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: blue,
                    child: Text(harf,
                        style: const TextStyle(
                            fontSize: 42,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                    child: Text(ad,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor))),
                const SizedBox(height: 4),
                Center(
                    child: Text(email,
                        style: TextStyle(
                            fontSize: 14, color: subtextColor))),
                const SizedBox(height: 36),
                _aksiyon(
                  ikon: Icons.edit_outlined,
                  baslik: 'Adı Düzenle',
                  altBaslik: ad,
                  renk: blue,
                  surface: surfaceColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () => _adDuzenle(dark),
                ),
                const SizedBox(height: 12),
                _aksiyon(
                  ikon: Icons.lock_reset_outlined,
                  baslik: 'Şifremi Değiştir',
                  altBaslik: 'E-postana sıfırlama bağlantısı gönderilir',
                  renk: Colors.orange,
                  surface: surfaceColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: _sifreDegistir,
                ),
                const SizedBox(height: 36),
                _aksiyon(
                  ikon: Icons.delete_forever_outlined,
                  baslik: 'Hesabı Sil',
                  altBaslik: 'Bu işlem geri alınamaz',
                  renk: Colors.redAccent,
                  surface: dark
                      ? Colors.redAccent.withOpacity(0.08)
                      : Colors.red.shade50,
                  textColor: Colors.redAccent,
                  subtextColor: Colors.redAccent.withOpacity(0.7),
                  onTap: () => _hesapSil(dark),
                ),
              ],
            ),
    );
  }

  Widget _aksiyon({
    required IconData ikon,
    required String baslik,
    required String altBaslik,
    required Color renk,
    required Color surface,
    required Color textColor,
    required Color subtextColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: renk.withOpacity(0.15),
                    shape: BoxShape.circle),
                child: Icon(ikon, color: renk, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(baslik,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(altBaslik,
                        style: TextStyle(
                            color: subtextColor, fontSize: 13),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: subtextColor),
            ],
          ),
        ),
      ),
    );
  }
}
