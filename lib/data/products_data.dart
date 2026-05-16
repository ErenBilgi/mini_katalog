import '../models/product.dart';

// Her ürüne ismiyle örtüşen TEK bir görsel atandı
final List<Map<String, dynamic>> productsJson = [
  {
    'id': 1,
    'name': 'iPhone 15 Pro',
    'category': 'Smartphone',
    'description': 'iPhone 15 Pro, titanyum tasarımıyla inanılmaz hafifliği ve dayanıklılığı bir arada sunar. A17 Pro çipi ile profesyonel düzeyde performans sağlar. 48MP ana kamerası ile olağanüstü fotoğraflar çekebilirsiniz.',
    'price': 999.0,
    // Akıllı telefon — dikey tutulan iPhone görseli
    'imageUrl': 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&q=80',
    'size': '6.1 inç', 'audio': '360 derece', 'colors': '4 renk',
  },
  {
    'id': 2,
    'name': 'AirPods Pro 2nd Gen',
    'category': 'Kulaklık',
    'description': 'AirPods Pro (2. Nesil), Aktif Gürültü Engelleme teknolojisi ile sizi müziğe kaptırır. Adaptif Şeffaflık modu ile çevrenizden haberdar olabilirsiniz.',
    'price': 249.0,
    // Küçük in-ear kulaklık + kılıfı
    'imageUrl': 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=400&q=80',
    'size': 'One Size', 'audio': 'H2 çip', 'colors': '1 renk',
  },
  {
    'id': 3,
    'name': 'AirPods Max',
    'category': 'Kulaklık',
    'description': 'AirPods Max, kulak üstü tasarımıyla premium ses deneyimi sunar. Özel dinamik sürücüsü sayesinde müziği canlı ve doğal bir şekilde duyarsınız.',
    'price': 549.0,
    // Kulak ÜSTÜ (over-ear) kulaklık
    'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&q=80',
    'size': 'One Size', 'audio': 'H1 çip', 'colors': '5 renk',
  },
  {
    'id': 4,
    'name': 'MacBook Pro 14"',
    'category': 'Bilgisayar',
    'description': 'MacBook Pro 14 inç, M3 Pro veya M3 Max çipli seçenekleriyle en zorlu profesyonel iş yüklerini kolayca kaldırır. Liquid Retina XDR ekranı ile görsel netlik olağanüstüdür.',
    'price': 1999.0,
    // Laptop — açık MacBook üstten görünüm
    'imageUrl': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&q=80',
    'size': '14 inç', 'audio': 'Altı hoparlör', 'colors': '2 renk',
  },
  {
    'id': 5,
    'name': 'iPad Air',
    'category': 'Tablet',
    'description': 'iPad Air, M1 çipi ile güçlü performansı ince tasarımıyla buluşturur. Apple Pencil ve Magic Keyboard ile prodüktiviteni bir üst seviyeye taşı.',
    'price': 599.0,
    // Tablet — ince çerçeveli iPad görünümü
    'imageUrl': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400&q=80',
    'size': '10.9 inç', 'audio': 'Stereo', 'colors': '5 renk',
  },
  {
    'id': 6,
    'name': 'HomePod',
    'category': 'Ses Sistemi',
    'description': 'HomePod, odandaki her köşeyi dolduran sürükleyici bir ses deneyimi sunar. Akıllı ev cihazlarınızı kontrol etmek ve müzik çalmak için mükemmel bir seçim.',
    'price': 299.0,
    // Silindirik akıllı hoparlör
    'imageUrl': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80',
    'size': '16.8 cm', 'audio': '360 derece', 'colors': '2 renk',
  },
  {
    'id': 7,
    'name': 'HomePod Mini',
    'category': 'Ses Sistemi',
    'description': 'HomePod Mini, küçük boyutuna rağmen büyük ses sunar. S5 çipi ile müzik deneyimini optimize eder ve akıllı ev merkezi olarak hizmet verir.',
    'price': 99.0,
    // Küçük yuvarlak hoparlör
    'imageUrl': 'https://images.unsplash.com/photo-1512446816042-444d641267d4?w=400&q=80',
    'size': '8.4 cm', 'audio': '360 derece', 'colors': '5 renk',
  },
  {
    'id': 8,
    'name': 'Apple Watch Series 9',
    'category': 'Akıllı Saat',
    'description': 'Apple Watch Series 9, S9 SiP çipiyle en hızlı Apple Watch ı temsil eder. Geliştirilmiş çift dokunuş özelliği ile ellerinizi kullanmadan cihazı kontrol edebilirsiniz.',
    'price': 399.0,
    // Kare ekranlı akıllı kol saati
    'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&q=80',
    'size': '41 / 45 mm', 'audio': 'Dahili mikrofon', 'colors': '9 renk',
  },
];

List<Product> getProducts() =>
    productsJson.map((json) => Product.fromJson(json)).toList();
