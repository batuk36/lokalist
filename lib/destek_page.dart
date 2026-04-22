import 'package:flutter/material.dart';

class DestekPage extends StatelessWidget {
  const DestekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Destek ve Yardım'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Sık Sorulan Sorular',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _sss('Uygulama nasıl kullanılır?',
              'Ana sayfadan mekanları keşfedebilir, favorilerine ekleyebilirsin.'),
          _sss('Mekan ekleyebilir miyim?',
              'Şu an için mekan ekleme özelliği geliştirme aşamasındadır.'),
          const SizedBox(height: 30),
          const Text('İletişim',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.email, color: Color(0xFF0056b3)),
            title: const Text('destek@lokatist.com',
                style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }

  Widget _sss(String soru, String cevap) {
    return ExpansionTile(
      title: Text(soru, style: const TextStyle(color: Colors.white)),
      children: [Padding(
        padding: const EdgeInsets.all(15),
        child: Text(cevap, style: const TextStyle(color: Colors.white54)),
      )],
    );
  }
}