class Mekan {
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
  final int fiyatSeviyesi; // 1=₺  2=₺₺  3=₺₺₺
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
    this.fiyatSeviyesi = 2,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() => {
    'isim': isim,
    'tur': tur,
    'adres': adres,
    'resim': resim,
    'kategori': kategori,
    'telefon': telefon,
    'puan': puan,
    'acilisSaati': acilisSaati,
    'enlem': enlem,
    'boylam': boylam,
    'fiyatSeviyesi': fiyatSeviyesi,
  };
}

List<Mekan> tumMekanlarListesi = [

// --- CAFELER ---
Mekan(
  isim: 'Coffee La Pause',
  tur: 'Cafe', kategori: 'Cafeler',
  adres: 'Cemal Gürsel Cad. No:84/B, Cebeci, Çankaya/Ankara',
  resim: 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAG4DAfA-FepgWwUKxNJxsOp_Uer_EDI0Zto6gqg_BmjgVPF9RW_r9h2Nvp0chHCbuIidmoiRhrb5YXoZBYdhPq8wZCwn_7dYAnyI09zdOGR9P2nwEwnD3-iiQZiUpFlUGr46_1PKLwXCYYM=w800-h600-k-no',
  telefon: '03123456789',
  puan: 4.3,
  acilisSaati: '08:00 - 23:00',
  enlem: 39.9434, boylam: 32.8770,
  fiyatSeviyesi: 2,
),

Mekan(
  isim: 'Leyla Coffee',
  tur: 'Cafe', kategori: 'Cafeler',
  adres: 'Kutlugün Sk. No:7, Cebeci, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
  telefon: '03123456780',
  puan: 4.4,
  acilisSaati: '08:30 - 22:30',
  enlem: 39.9420, boylam: 32.8780,
  fiyatSeviyesi: 2,
),

Mekan(
  isim: "Lil' Street Coffee",
  tur: 'Cafe', kategori: 'Cafeler',
  adres: 'Siyasal Bilgiler Fakültesi Yanı, Cebeci, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1559925393-8be0ec41b518?w=800',
  telefon: '03123456781',
  puan: 4.6,
  acilisSaati: '08:00 - 23:00',
  enlem: 39.9425, boylam: 32.8775,
  fiyatSeviyesi: 1,
),

Mekan(
  isim: 'Thila Coffee',
  tur: 'Cafe', kategori: 'Cafeler',
  adres: 'Cemal Gürsel Cad. No:49/A, Cebeci, Çankaya/Ankara',
  resim: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/bc/6a/30/thila-coffe.jpg',
  telefon: '05522990143',
  puan: 4.4,
  acilisSaati: '07:30 - 00:30',
  enlem: 39.9430, boylam: 32.8772,
  fiyatSeviyesi: 2,
),

Mekan(
  isim: 'Coffy',
  tur: 'Cafe', kategori: 'Cafeler',
  adres: 'Cemal Gürsel Cad. No:47/A, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1461023233467-55c4763905c1?w=800',
  telefon: '03123456782',
  puan: 4.2,
  acilisSaati: '08:00 - 22:00',
  enlem: 39.9432, boylam: 32.8768,
  fiyatSeviyesi: 1,
),

Mekan(
  isim: 'Angora Coffee & Bakery',
  tur: 'Cafe', kategori: 'Cafeler',
  adres: 'Süngübayırı Sk. No:1/B, Cebeci, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800',
  telefon: '03123630010',
  puan: 4.0,
  acilisSaati: '06:00 - 01:00',
  enlem: 39.9428, boylam: 32.8778,
  fiyatSeviyesi: 2,
),

Mekan(
  isim: 'Kahveci Hacıbaba',
  tur: 'Cafe', kategori: 'Cafeler',
  adres: 'Cemal Gürsel Cad. No:46, Cebeci, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=800',
  telefon: '03124345558',
  puan: 3.9,
  acilisSaati: '08:00 - 23:00',
  enlem: 39.9418, boylam: 32.8782,
  fiyatSeviyesi: 1,
),

Mekan(
  isim: 'Figen Pastanesi',
  tur: 'Cafe', kategori: 'Cafeler',
  adres: 'Cemal Gürsel Cad. No:62/A, Kurtuluş, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=800',
  telefon: '03123191041',
  puan: 4.3,
  acilisSaati: '07:00 - 22:00',
  enlem: 39.9300, boylam: 32.8650,
  fiyatSeviyesi: 2,
),

Mekan(
  isim: 'Mackbear Coffee',
  tur: 'Cafe', kategori: 'Cafeler',
  adres: 'Cemal Gürsel Cad. No:49/C, Cebeci, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1507133750040-4a8f5700e535?w=800',
  telefon: '03123456783',
  puan: 4.5,
  acilisSaati: '07:00 - 22:00',
  enlem: 39.9305, boylam: 32.8655,
  fiyatSeviyesi: 3,
),

Mekan(
  isim: 'Arabica Coffee House',
  tur: 'Cafe', kategori: 'Cafeler',
  adres: 'Cemal Gürsel Cad. No:44/B, Kurtuluş, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=800',
  telefon: '03124306171',
  puan: 4.2,
  acilisSaati: '07:00 - 01:00',
  enlem: 39.9295, boylam: 32.8660,
  fiyatSeviyesi: 3,
),

// --- RESTORANLAR ---
Mekan(
  isim: 'Esnaf Dürüm',
  tur: 'Restoran', kategori: 'Restoranlar',
  adres: 'Cemal Gürsel Cad. No:55, Kurtuluş, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=800',
  telefon: '05327056163',
  puan: 4.4,
  acilisSaati: '10:00 - 22:00',
  enlem: 39.9302, boylam: 32.8652,
  fiyatSeviyesi: 1,
),

Mekan(
  isim: 'Harbi Döner',
  tur: 'Restoran', kategori: 'Restoranlar',
  adres: 'Ziya Gökalp Cad. No:18, Kurtuluş, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=800',
  telefon: '03123456784',
  puan: 4.1,
  acilisSaati: '10:00 - 23:00',
  enlem: 39.9308, boylam: 32.8658,
  fiyatSeviyesi: 1,
),

Mekan(
  isim: 'Tavuk Dünyası',
  tur: 'Restoran', kategori: 'Restoranlar',
  adres: 'Kurtuluş Kavşağı, Kurtuluş, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800',
  telefon: '08502228858',
  puan: 3.8,
  acilisSaati: '10:00 - 23:00',
  enlem: 39.9298, boylam: 32.8648,
  fiyatSeviyesi: 1,
),

Mekan(
  isim: 'Popeyes',
  tur: 'Restoran', kategori: 'Restoranlar',
  adres: 'Cemal Gürsel Cad. No:64/A, Cebeci, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1513639776629-58912cbbdaac?w=800',
  telefon: '08503085959',
  puan: 4.0,
  acilisSaati: '10:00 - 23:00',
  enlem: 39.9303, boylam: 32.8653,
  fiyatSeviyesi: 2,
),

Mekan(
  isim: 'Kebap 9',
  tur: 'Restoran', kategori: 'Restoranlar',
  adres: 'Cemal Gürsel Cad. No:72, Kurtuluş, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800',
  telefon: '03123456785',
  puan: 4.2,
  acilisSaati: '11:00 - 22:00',
  enlem: 39.9301, boylam: 32.8651,
  fiyatSeviyesi: 2,
),

Mekan(
  isim: "Domino's Pizza",
  tur: 'Restoran', kategori: 'Restoranlar',
  adres: 'Cemal Gürsel Cad. No:39/A, Cebeci, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
  telefon: '03123633535',
  puan: 4.1,
  acilisSaati: '10:00 - 01:30',
  enlem: 39.9306, boylam: 32.8656,
  fiyatSeviyesi: 2,
),

Mekan(
  isim: 'Aspava Dürüm',
  tur: 'Restoran', kategori: 'Restoranlar',
  adres: 'Kurtuluş Metro Çıkışı, Kurtuluş, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1529003641296-18957480afe3?w=800',
  telefon: '03123456786',
  puan: 4.3,
  acilisSaati: '07:00 - 23:00',
  enlem: 39.9296, boylam: 32.8662,
  fiyatSeviyesi: 1,
),

Mekan(
  isim: 'Orhan Aspava',
  tur: 'Restoran', kategori: 'Restoranlar',
  adres: 'Ziya Gökalp Cad. No:30, Kurtuluş, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1555393354-1051ad06efd7?w=800',
  telefon: '03123456787',
  puan: 4.4,
  acilisSaati: '07:00 - 23:00',
  enlem: 39.9299, boylam: 32.8649,
  fiyatSeviyesi: 1,
),

Mekan(
  isim: 'Burger King',
  tur: 'Restoran', kategori: 'Restoranlar',
  adres: 'Cemal Gürsel Cad., Kurtuluş, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
  telefon: '04443463',
  puan: 3.9,
  acilisSaati: '08:00 - 00:00',
  enlem: 39.9304, boylam: 32.8654,
  fiyatSeviyesi: 2,
),

Mekan(
  isim: "McDonald's",
  tur: 'Restoran', kategori: 'Restoranlar',
  adres: 'Cemal Gürsel Cad. No:61/22, Cebeci, Çankaya/Ankara',
  resim: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
  telefon: '03123202124',
  puan: 3.8,
  acilisSaati: '08:00 - 23:00',
  enlem: 39.9302, boylam: 32.8650,
  fiyatSeviyesi: 2,
),
];
