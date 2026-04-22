import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';
import 'kullanici_servisi.dart';

class DetailPage extends StatefulWidget {
  final Mekan mekan;
  const DetailPage({super.key, required this.mekan});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Resim Alanı
            Stack(
              children: [
                Image.network(
                  widget.mekan.resim,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // FAVORİ BUTONU - sağ üstte
                Positioned(
                  top: 40,
                  right: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: Icon(
                        widget.mekan.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.mekan.isFavorite
                            ? Colors.red
                            : Colors.white,
                      ),
                      onPressed: () async {
                        setState(() {
                          widget.mekan.isFavorite =
                              !widget.mekan.isFavorite;
                        });
                        final uid =
                            FirebaseAuth.instance.currentUser?.uid;
                        if (uid != null) {
                          await KullaniciServisi.favoriGuncelle(
                            uid,
                            widget.mekan.isim,
                            widget.mekan.isFavorite,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mekan İsmi
                  Text(
                    widget.mekan.isim,
                    style: const TextStyle(color: Colors.blueAccent, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  // YILDIZ VE PUAN
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.mekan.puan} (120+ Yorum)",
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // ADRES
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white54, size: 18),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(widget.mekan.adres, style: const TextStyle(color: Colors.white54)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // AÇILIŞ SAATİ
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled, color: Colors.green, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        "Şu an Açık · Kapanış: ${widget.mekan.acilisSaati.split('-')[1]}",
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // BUTONLAR
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${widget.mekan.isim} ${widget.mekan.adres}");
                            if (!await launchUrl(url)) throw 'Harita açılamadı';
                          },
                          icon: const Icon(Icons.map),
                          label: const Text("Beni Oraya Götür"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final Uri tel = Uri.parse("tel:${widget.mekan.telefon}");
                            if (!await launchUrl(tel)) throw 'Arama yapılamadı';
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text("Ara"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}