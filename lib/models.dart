class Mekan { // 'class' küçük harf olmalı
  final String isim;
  final String tur;
  final String adres;
  final String resim;
  final String kategori;
  final String telefon;
  final double puan;
  final String acilisSaati;
  final double enlem;
  final double boylam;
  bool isFavorite;

  Mekan({
    required this.isim,
    required this.tur,
    required this.adres,
    required this.resim,
    this.kategori = 'Cafeler',
    this.telefon = "03121234567",
    this.puan = 4.5,
    this.acilisSaati = "09:00 - 22:00",
    this.enlem = 39.9334,
    this.boylam = 32.8597,
    this.isFavorite = false,
  }); // Noktalı virgül burada olmalı
}

List<Mekan> tumMekanlarListesi = [
// --- CAFELER ---
Mekan(isim: 'Coffee La Pause', tur: 'Cafe', kategori: 'Cafeler', adres: 'Cemal Gürsel Cad. No: 84/B, Cebeci', resim: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800', enlem: 39.9434, boylam: 32.8770),
Mekan(isim: 'Leyla Coffee', tur: 'Cafe', kategori: 'Cafeler', adres: 'Dumlupınar Cd. No:12, Cebeci', resim: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800', enlem: 39.9420, boylam: 32.8780),
Mekan(isim: 'Lil\' Street Coffee', tur: 'Cafe', kategori: 'Cafeler', adres: 'Siyasal Bilgiler Fakültesi Yanı, Cebeci', resim: 'https://images.unsplash.com/photo-1559925393-8be0ec41b518?w=800', enlem: 39.9425, boylam: 32.8775),
Mekan(isim: 'Thila Coffee', tur: 'Cafe', kategori: 'Cafeler', adres: 'Cemal Gürsel Cad., Cebeci', resim: 'https://images.unsplash.com/photo-1521017432531-fbd92d768814?w=800', enlem: 39.9430, boylam: 32.8772),
Mekan(isim: 'Coffy', tur: 'Cafe', kategori: 'Cafeler', adres: 'Cemal Gürsel Cad. No:45, Cebeci', resim: 'https://images.unsplash.com/photo-1461023233467-55c4763905c1?w=800', enlem: 39.9432, boylam: 32.8768),
Mekan(isim: 'Angora Coffee', tur: 'Cafe', kategori: 'Cafeler', adres: 'Siyasal Yanı, Cebeci', resim: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800', enlem: 39.9428, boylam: 32.8778),
Mekan(isim: 'Kahveci Hacıbaba', tur: 'Cafe', kategori: 'Cafeler', adres: 'Dumlupınar Cd., Cebeci', resim: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=800', enlem: 39.9418, boylam: 32.8782),
Mekan(isim: 'Figen Pastanesi', tur: 'Cafe', kategori: 'Cafeler', adres: 'Ziya Gökalp Cd., Kurtuluş', resim: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=800', enlem: 39.9300, boylam: 32.8650),
Mekan(isim: 'Mackbear Coffee', tur: 'Cafe', kategori: 'Cafeler', adres: 'Ziya Gökalp Cd., Kurtuluş', resim: 'https://images.unsplash.com/photo-1507133750040-4a8f5700e535?w=800', enlem: 39.9305, boylam: 32.8655),
Mekan(isim: 'Arabica Coffee House', tur: 'Cafe', kategori: 'Cafeler', adres: 'Kurtuluş Parkı Karşısı, Kurtuluş', resim: 'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800', enlem: 39.9295, boylam: 32.8660),

// --- RESTORANLAR ---
Mekan(isim: 'Esnaf Dürüm', tur: 'Restoran', kategori: 'Restoranlar', adres: 'Cemal Gürsel Cd., Kurtuluş', resim: 'https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=800', enlem: 39.9302, boylam: 32.8652),
Mekan(isim: 'Harbi Döner', tur: 'Restoran', kategori: 'Restoranlar', adres: 'Ziya Gökalp Cd., Kurtuluş', resim: 'https://images.unsplash.com/photo-1633321702518-7feccaf0ad44?w=800', enlem: 39.9308, boylam: 32.8658),
Mekan(isim: 'Tavuk Dünyası', tur: 'Restoran', kategori: 'Restoranlar', adres: 'Kurtuluş Kavşağı, Kurtuluş', resim: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800', enlem: 39.9298, boylam: 32.8648),
Mekan(isim: 'Popeyes', tur: 'Restoran', kategori: 'Restoranlar', adres: 'Kurtuluş, Kurtuluş', resim: 'https://images.unsplash.com/photo-1513639776629-58912cbbdaac?w=800', enlem: 39.9303, boylam: 32.8653),
Mekan(isim: 'Kebap 9', tur: 'Restoran', kategori: 'Restoranlar', adres: 'Cemal Gürsel Cad., Kurtuluş', resim: 'https://images.unsplash.com/photo-1544124499-58912cbbdaa7?w=800', enlem: 39.9301, boylam: 32.8651),
Mekan(isim: 'Dominos Pizza', tur: 'Restoran', kategori: 'Restoranlar', adres: 'Ziya Gökalp Cd., Kurtuluş', resim: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300', enlem: 39.9306, boylam: 32.8656),
Mekan(isim: 'Aspava Dürüm', tur: 'Restoran', kategori: 'Restoranlar', adres: 'Kurtuluş Metro Çıkışı, Kurtuluş', resim: 'https://images.unsplash.com/photo-1529003641296-18957480afe3?w=800', enlem: 39.9296, boylam: 32.8662),
Mekan(isim: 'Orhan Aspava', tur: 'Restoran', kategori: 'Restoranlar', adres: 'Kurtuluş Kavşağı, Kurtuluş', resim: 'https://images.unsplash.com/photo-1555393354-1051ad06efd7?w=800', enlem: 39.9299, boylam: 32.8649),
Mekan(isim: 'Burger King', tur: 'Restoran', kategori: 'Restoranlar', adres: 'Kurtuluş, Ankara', resim: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800', enlem: 39.9304, boylam: 32.8654),
Mekan(isim: 'McDonalds', tur: 'Restoran', kategori: 'Restoranlar', adres: 'Cemal Gürsel Cad., Kurtuluş', resim: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800', enlem: 39.9302, boylam: 32.8650),];