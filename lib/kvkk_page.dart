import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tema_yonetici.dart';

class KvkkPage extends StatelessWidget {
  const KvkkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = context.watch<TemaYonetici>().karanlikMod;
    final bgColor = dark ? const Color(0xFF0A0A0A) : Colors.white;
    final textColor = dark ? Colors.white : Colors.black87;
    final subtextColor = dark ? Colors.white70 : Colors.black54;
    final surfaceColor =
        dark ? const Color(0xFF161616) : Colors.grey.shade50;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Gizlilik Politikası',
            style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _baslik('Son güncelleme: Nisan 2025', subtextColor,
              fontSize: 13),
          const SizedBox(height: 20),
          _bolum(
            'Toplanan Veriler',
            'LOKATİST uygulaması aşağıdaki verileri toplar:\n\n'
                '• E-posta adresi ve ad-soyad (hesap oluşturma için)\n'
                '• Favori mekanlar listesi (kişiselleştirme için)\n'
                '• Mekan puanlarınız (hizmet kalitesi için)\n'
                '• Hata bildirimleri (uygulama iyileştirme için)\n'
                '• Konum bilgisi (yakın mekan gösterimi için, yalnızca uygulama açıkken)',
            surfaceColor,
            textColor,
            subtextColor,
          ),
          _bolum(
            'Verilerin Kullanımı',
            'Topladığımız veriler yalnızca şu amaçlarla kullanılır:\n\n'
                '• Size kişiselleştirilmiş mekan önerileri sunmak\n'
                '• Favori ve puan bilgilerinizi cihazlar arası senkronize etmek\n'
                '• Uygulama hatalarını tespit edip gidermek\n\n'
                'Verileriniz hiçbir koşulda üçüncü taraflarla ticari amaçla paylaşılmaz.',
            surfaceColor,
            textColor,
            subtextColor,
          ),
          _bolum(
            'Veri Güvenliği',
            'Tüm veriler Google Firebase altyapısında şifreli biçimde saklanır. '
                'Firebase, SOC 1, SOC 2 ve ISO 27001 sertifikalarına sahip olup '
                'endüstri standardı güvenlik önlemleri uygulamaktadır.\n\n'
                'Konum bilginiz yalnızca yakın mekanları listelemek için kullanılır '
                've hiçbir zaman sunucularımıza kaydedilmez.',
            surfaceColor,
            textColor,
            subtextColor,
          ),
          _bolum(
            'Kullanıcı Hakları',
            'Kişisel Verilerin Korunması Kanunu (KVKK) kapsamında şu haklara sahipsiniz:\n\n'
                '• Verilerinize erişim talep etme\n'
                '• Verilerinizin düzeltilmesini isteme\n'
                '• Hesabınızı ve tüm verilerinizi kalıcı olarak silme\n'
                '  (Profil → Hesabı Sil)\n\n'
                'Hesabınızı sildiğinizde tüm kişisel verileriniz (e-posta, '
                'favoriler, puanlar) kalıcı olarak silinir.',
            surfaceColor,
            textColor,
            subtextColor,
          ),
          _bolum(
            'Çerezler ve Analitik',
            'LOKATİST, uygulama performansını ve kullanıcı deneyimini iyileştirmek '
                'amacıyla Firebase Analytics kullanır. Toplanan analitik veriler '
                'anonim olup sizi kişisel olarak tanımlamak için kullanılmaz.',
            surfaceColor,
            textColor,
            subtextColor,
          ),
          _bolum(
            'İletişim',
            'Gizlilik politikamıza ilişkin sorularınız için:\n\n'
                'E-posta: desteklokalist@gmail.com\n\n'
                'Talebiniz en geç 30 gün içinde yanıtlanacaktır.',
            surfaceColor,
            textColor,
            subtextColor,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _baslik(String metin, Color renk,
      {double fontSize = 16, FontWeight weight = FontWeight.normal}) {
    return Text(metin,
        style: TextStyle(
            color: renk, fontSize: fontSize, fontWeight: weight));
  }

  Widget _bolum(String baslik, String icerik, Color surface,
      Color textColor, Color subtextColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(baslik,
              style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(icerik,
              style: TextStyle(
                  color: subtextColor, fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }
}
