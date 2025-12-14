# Destek / Support Ekranı

## 📋 Genel Bakış

Bu modül, kullanıcıların destek talebi oluşturabilmesi ve müşteri hizmetleri ile iletişime geçebilmesi için tasarlanmış tam özellikli bir Neumorphism (Soft UI) stili destek ekranıdır.

## 🎨 Tasarım Özellikleri

### Neumorphism (Soft UI) Tasarımı
- **Extruded (Çıkıntılı) Elementler**: Kartlar ve butonlar yüzeyden yükselmiş görünür
- **Intruded (Girintili) Elementler**: Input alanları yüzeye basılmış görünür
- **Renk Paleti**: 
  - Arka plan: `#E0E5EC`
  - Birincil metin: `#2D3142`
  - İkincil metin: `#6B7280`
  - Vurgu rengi: `#4ECDC4`
- **Yumuşak Gölgeler**: Beyaz ve koyu gri gölgeler ile 3D efekt

## 📁 Dosya Yapısı

```
lib/screens/profil/support/
├── support_screen.dart               # Ana ekran
├── widgets/
│   ├── neumorphic_container.dart    # Temel Neumorphic widget'lar
│   ├── contact_info_card.dart       # İletişim bilgileri kartı
│   ├── contact_form_card.dart       # Destek talebi formu
│   └── faq_card.dart                # Sık sorulan sorular kartı
└── README.md                        # Bu dosya
```

## 🚀 Kullanım

### Route Tanımı

`/profil/support` route'u zaten `app_router.dart`'a eklenmiştir:

```dart
'/profil/support': (context) => const SupportScreen(),
```

### Ekrana Yönlendirme

```dart
Navigator.pushNamed(context, '/profil/support');
```

## 🧩 Bileşenler

### 1. NeumorphicContainer
Temel neumorphic konteyner widget'ı. İki mod destekler:
- **isPressed: false** - Çıkıntılı (yükselmiş) görünüm
- **isPressed: true** - Girintili (basılmış) görünüm

```dart
NeumorphicContainer(
  isPressed: false,
  borderRadius: 20.0,
  padding: EdgeInsets.all(16),
  child: Text('İçerik'),
)
```

### 2. NeumorphicButton
Tıklanabilir neumorphic buton. Animasyonlu basma efekti içerir.

```dart
NeumorphicButton(
  onPressed: () {},
  gradient: LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFC06C84)],
  ),
  child: Text('Gönder'),
)
```

### 3. ContactInfoCard
4'lü grid şeklinde iletişim bilgilerini görüntüler:
- Telefon
- E-posta
- Çalışma Saatleri
- Adres

### 4. ContactFormCard
Destek talebi oluşturma formu. Alanlar:
- Ad Soyad (zorunlu)
- E-posta (zorunlu)
- Telefon (opsiyonel)
- Konu (dropdown)
- Mesaj (zorunlu)
- Dosya Eki (opsiyonel - jpg, png, pdf, doc, docx)

**Provider Entegrasyonu:**
```dart
await ref.read(supportsProvider.notifier).createSupportTicket(
  name: 'Ahmet Yılmaz',
  email: 'ahmet@example.com',
  subject: 'Ürün Sorunu',
  message: 'Mesajım...',
);
```

### 5. FaqCard
Genişletilebilir SSS listesi. Her item tıklandığında açılır/kapanır.

## 🔌 Provider Kullanımı

### SupportsProvider (Riverpod Notifier)

```dart
// Provider'ı okuma
final supportsState = ref.watch(supportsProvider);

// Loading durumu
if (supportsState.isLoading) {
  return CircularProgressIndicator();
}

// Hata durumu
if (supportsState.error != null) {
  return Text('Hata: ${supportsState.error}');
}
```

### Metodlar

#### 1. Yeni Ticket Oluştur
```dart
await ref.read(supportsProvider.notifier).createSupportTicket(
  name: 'Kullanıcı Adı',
  email: 'email@example.com',
  phone: '+90 555 123 4567', // opsiyonel
  subject: 'Konu',
  message: 'Mesaj içeriği',
  attachment: multipartFile, // opsiyonel
);
```

#### 2. Ticket Listesi Getir (Admin)
```dart
await ref.read(supportsProvider.notifier).fetchTickets(
  status: 'pending', // opsiyonel: pending, in_progress, resolved, closed
  subject: 'Ürün Sorunu', // opsiyonel
  search: 'arama terimi', // opsiyonel
);
```

#### 3. Ticket Detayı Getir (Admin)
```dart
await ref.read(supportsProvider.notifier).fetchTicketDetail(ticketId);
```

#### 4. Ticket Durumu Güncelle (Admin)
```dart
await ref.read(supportsProvider.notifier).updateTicketStatus(
  ticketId: 123,
  status: 'resolved', // pending, in_progress, resolved, closed
);
```

#### 5. Ticket Ata (Admin)
```dart
await ref.read(supportsProvider.notifier).assignTicket(
  ticketId: 123,
  assignedTo: 456, // staff user ID
);
```

#### 6. Ticket Notu Güncelle (Admin)
```dart
await ref.read(supportsProvider.notifier).updateTicketNotes(
  ticketId: 123,
  notes: 'Admin notları...',
);
```

#### 7. Staff Kullanıcıları Getir (Admin)
```dart
await ref.read(supportsProvider.notifier).fetchStaffUsers();
```

#### 8. Toplu Durum Güncelle (Admin)
```dart
await ref.read(supportsProvider.notifier).bulkUpdateTicketStatus(
  ticketIds: [1, 2, 3],
  status: 'closed',
);
```

### Yardımcı Metodlar
```dart
// Hata mesajını temizle
ref.read(supportsProvider.notifier).clearError();

// Ticket detayını temizle
ref.read(supportsProvider.notifier).clearTicketDetail();

// Tüm verileri temizle
ref.read(supportsProvider.notifier).clearAll();
```

## 📱 Ekran Görüntüsü Akışı

1. **Ana Başlık**: "Müşteri Hizmetleri"
2. **İletişim Bilgileri Kartı**: 4'lü grid ile iletişim bilgileri
3. **Bize Ulaşın Kartı**: 6 alanlı form + dosya yükleme + gönder butonu
4. **SSS Kartı**: 3 adet genişletilebilir soru-cevap

## 🎯 Özellikler

✅ Tam Neumorphism (Soft UI) tasarımı
✅ Responsive ve mobile-first
✅ Form validasyonu
✅ Dosya yükleme desteği
✅ Riverpod state management
✅ API entegrasyonu
✅ Loading ve error state'leri
✅ Genişletilebilir SSS listesi
✅ Admin işlemleri desteği
✅ Toplu işlem desteği

## 🔧 Gereksinimler

### Paketler (pubspec.yaml)
```yaml
dependencies:
  flutter_riverpod: ^3.0.3
  google_fonts: ^6.3.3
  file_picker: ^10.3.3
  http: ^1.5.0
```

### API Konfigürasyonu (.env)
```env
SUPPOR_TICKET_API_URL=https://imecehub.com/api/support/tickets/
```

## 🐛 Hata Ayıklama

### Provider import hatası
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

### Google Fonts hatası
```bash
flutter pub get
```

### Dosya seçme hatası
Platform-specific ayarlar gerekebilir. `file_picker` dökümantasyonuna bakın.

## 📝 TODO / Gelecek Geliştirmeler

- [ ] Image preview for uploaded files
- [ ] Multi-language support
- [ ] Dark mode support
- [ ] Push notification for ticket updates
- [ ] Chat-based real-time support
- [ ] Ticket history tracking
- [ ] Rating system for support quality

## 👥 Katkıda Bulunanlar

Bu modül ImeCeHub mobil uygulama projesi için geliştirilmiştir.

---

**Not**: Bu modül production-ready durumda ve lint hatasız olarak test edilmiştir.

