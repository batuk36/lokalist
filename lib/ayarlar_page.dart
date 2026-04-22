import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tema_yonetici.dart';

class AyarlarPage extends StatefulWidget {
  const AyarlarPage({super.key});

  @override
  State<AyarlarPage> createState() => _AyarlarPageState();
}

class _AyarlarPageState extends State<AyarlarPage> {
  bool bildirimler = true;

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<TemaYonetici>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Karanlık Mod'),
            trailing: Switch(
              value: tema.karanlikMod,
              onChanged: (v) => tema.degistir(v),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Bildirimler'),
            trailing: Switch(
              value: bildirimler,
              onChanged: (v) => setState(() => bildirimler = v),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Dil'),
            subtitle: const Text('Türkçe'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}