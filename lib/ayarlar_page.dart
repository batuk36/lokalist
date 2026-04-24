import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tema_yonetici.dart';
import 'profil_page.dart';
import 'kvkk_page.dart';

class AyarlarPage extends StatefulWidget {
  const AyarlarPage({super.key});

  @override
  State<AyarlarPage> createState() => _AyarlarPageState();
}

class _AyarlarPageState extends State<AyarlarPage> {
  bool _bildirimler = true;

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaYonetici>(context);
    final bool dark = tema.karanlikMod;
    final bgColor = dark ? const Color(0xFF0A0A0A) : Colors.white;
    final textColor = dark ? Colors.white : Colors.black87;
    final subtextColor = dark ? Colors.white54 : Colors.black54;
    final surfaceColor = dark ? const Color(0xFF161616) : Colors.grey.shade100;
    const blue = Color(0xFF0056b3);

    final kullanici = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Ayarlar', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hesap
          if (kullanici != null) ...[
            _bolumBasligi('Hesap', subtextColor),
            _tile(
              ikon: Icons.person_outline,
              ikonRenk: blue,
              baslik: 'Profilim',
              altBaslik: kullanici.displayName ?? kullanici.email ?? '',
              surface: surfaceColor,
              textColor: textColor,
              subtextColor: subtextColor,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProfilPage())),
            ),
            const SizedBox(height: 8),
          ],

          // Görünüm
          _bolumBasligi('Görünüm', subtextColor),
          Container(
            decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14)),
            child: SwitchListTile(
              secondary: Icon(
                  dark ? Icons.dark_mode : Icons.light_mode,
                  color: blue),
              title: Text('Karanlık Mod',
                  style: TextStyle(color: textColor, fontSize: 16)),
              subtitle: Text(dark ? 'Açık' : 'Kapalı',
                  style:
                      TextStyle(color: subtextColor, fontSize: 13)),
              value: tema.karanlikMod,
              onChanged: (v) => tema.degistir(v),
              activeColor: blue,
            ),
          ),
          const SizedBox(height: 8),

          // Bildirimler
          _bolumBasligi('Bildirimler', subtextColor),
          Container(
            decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14)),
            child: SwitchListTile(
              secondary:
                  Icon(Icons.notifications_outlined, color: blue),
              title: Text('Bildirimler',
                  style: TextStyle(color: textColor, fontSize: 16)),
              subtitle: Text(_bildirimler ? 'Açık' : 'Kapalı',
                  style:
                      TextStyle(color: subtextColor, fontSize: 13)),
              value: _bildirimler,
              onChanged: (v) => setState(() => _bildirimler = v),
              activeColor: blue,
            ),
          ),
          const SizedBox(height: 8),

          // Hakkında
          _bolumBasligi('Hakkında', subtextColor),
          _tile(
            ikon: Icons.privacy_tip_outlined,
            ikonRenk: blue,
            baslik: 'Gizlilik Politikası',
            altBaslik: 'KVKK ve veri gizliliği',
            surface: surfaceColor,
            textColor: textColor,
            subtextColor: subtextColor,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const KvkkPage())),
          ),
          const SizedBox(height: 4),
          _tile(
            ikon: Icons.info_outline,
            ikonRenk: subtextColor,
            baslik: 'Versiyon',
            altBaslik: '1.0.0',
            surface: Colors.transparent,
            textColor: textColor,
            subtextColor: subtextColor,
            onTap: null,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _bolumBasligi(String metin, Color renk) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(metin.toUpperCase(),
          style: TextStyle(
              color: renk,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2)),
    );
  }

  Widget _tile({
    required IconData ikon,
    required Color ikonRenk,
    required String baslik,
    required String altBaslik,
    required Color surface,
    required Color textColor,
    required Color subtextColor,
    required VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
          color: surface, borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(ikon, color: ikonRenk),
        title: Text(baslik,
            style: TextStyle(color: textColor, fontSize: 16)),
        subtitle: Text(altBaslik,
            style: TextStyle(color: subtextColor, fontSize: 13),
            overflow: TextOverflow.ellipsis),
        trailing: onTap != null
            ? Icon(Icons.chevron_right, color: subtextColor)
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
