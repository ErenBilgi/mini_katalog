# Mini Katalog Uygulaması

Flutter ile geliştirilmiş eğitim amaçlı mobil katalog uygulaması.

## Ekran Görüntüleri

| Ana Sayfa | Ürün Detayı | Sepet (Dolu) | Sepet (Boş) |
|-----------|-------------|--------------|-------------|
| _(screenshot)_ | _(screenshot)_ | _(screenshot)_ | _(screenshot)_ |

## Özellikler

- **Ürün Listesi** – GridView ile kart tabanlı 8 ürün
- **Arama & Filtreleme** – Gerçek zamanlı ürün arama, kategori filtresi
- **Ürün Detayı** – Görsel, açıklama, teknik özellikler
- **Sepet Sistemi** – Ürün ekleme / çıkarma, toplam fiyat hesaplama
- **Sayfa Geçişleri** – Navigator.push / pop ile ekranlar arası geçiş
- **Route Arguments** – Sayfalar arası veri taşıma

## Kullanılan Flutter Sürümü

```
Flutter 3.x (stable)
Dart 3.x
```

Sürümünüzü kontrol etmek için:
```bash
flutter --version
```

## Proje Yapısı

```
lib/
├── main.dart                    # Uygulama girişi, sepet state yönetimi
├── models/
│   └── product.dart             # Ürün modeli (fromJson / toJson)
├── data/
│   └── products_data.dart       # JSON simülasyonu - ürün verileri
├── screens/
│   ├── home_screen.dart         # Ana sayfa (GridView, arama, banner)
│   ├── product_detail_screen.dart  # Ürün detay ekranı
│   └── cart_screen.dart         # Sepet ekranı
└── widgets/
    └── product_card.dart        # Tekrar kullanılabilir ürün kartı
```

## Kullanılan Paketler

- `flutter/material.dart` (varsayılan – ekstra paket kullanılmamıştır)

## Çalıştırma Adımları

### 1. Gereksinimler

- [Flutter SDK](https://flutter.dev/docs/get-started/install) kurulu olmalı
- Android Studio veya VS Code yüklü olmalı
- Android Emulator veya fiziksel cihaz bağlı olmalı

### 2. Projeyi İndir

```bash
git clone https://github.com/KULLANICI_ADIN/mini_katalog.git
cd mini_katalog
```

### 3. Bağımlılıkları Yükle

```bash
flutter pub get
```

### 4. Uygulamayı Çalıştır

```bash
flutter run
```

### 5. Release Build (APK)

```bash
flutter build apk --release
```

## Öğrenilen Konular

| Gün | Konu |
|-----|------|
| Gün 1 | Flutter kurulumu, Stateless/Stateful widget, proje yapısı |
| Gün 2 | Dart temelleri, Text/Container/Row/Column, Card, ListTile |
| Gün 3 | Navigator.push/pop, Route Arguments, MaterialPageRoute |
| Gün 4 | JSON model sınıfı, fromJson/toJson, ListView.builder, arama |
| Gün 5 | GridView, ürün detayı, sepet state yönetimi, UI teması |

## Veri Kaynakları

Bu proje eğitim amaçlıdır. Ürün verileri local JSON simülasyonuyla oluşturulmuştur.

Alternatif test API'leri:
- [Fake Store API](https://fakestoreapi.com/products)
- [DummyJSON](https://dummyjson.com/products)
