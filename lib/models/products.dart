// lib/models/product.dart

class Product {
  final int? urunId;
  final String? urunAdi;
  final String? aciklama;
  final String? urunUretimTarihi;
  final String? urunEklemeTarihi;
  final String? urunBilgisiGuncellemeTarihi;
  final bool? imeceOnayli;
  final String? urunParakendeFiyat;
  final String? urunMinFiyat;
  final int? stokDurumu;
  final dynamic? degerlendirmePuani;
  final String? labSonucPdf;
  final String? urunSertifikaPdf;
  final String? kapakGorseli;
  final bool? urunGorunurluluk;
  final int? satis_turu;
  final int? satici;
  final int? kategori;

  Product({
    this.urunId,
    this.urunAdi,
    this.aciklama,
    this.urunUretimTarihi,
    this.urunEklemeTarihi,
    this.urunBilgisiGuncellemeTarihi,
    this.imeceOnayli,
    this.urunParakendeFiyat,
    this.urunMinFiyat,
    this.stokDurumu,
    this.degerlendirmePuani,
    this.labSonucPdf,
    this.urunSertifikaPdf,
    this.kapakGorseli,
    this.urunGorunurluluk,
    this.satis_turu,
    this.satici,
    this.kategori,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      urunId: json['urun_id'] as int? ?? json['id'],
      urunAdi: json['urun_adi'] as String? ?? '',
      aciklama: json['aciklama'] as String? ?? '',
      urunUretimTarihi: json['urun_uretim_tarihi'] as String? ?? '',
      urunEklemeTarihi: json['urun_ekleme_tarihi'] as String? ?? '',
      urunBilgisiGuncellemeTarihi:
          json['urunbilgisi_guncelleme_tarihi'] as String? ?? '',
      imeceOnayli: json['imece_onayli'] as bool? ?? false,
      urunParakendeFiyat: json['urun_perakende_fiyati'] as String? ?? '',
      urunMinFiyat: json['urun_min_fiyati'] as String? ?? '',
      stokDurumu: json['stok_durumu'] as int? ?? 0,
      degerlendirmePuani: (() {
        final val = json['degerlendirme_puani'];
        if (val == null || val == '-' || val.toString().isEmpty) {
          return 0.0;
        }
        if (val is int) {
          return val.toDouble();
        }
        if (val is double) {
          return val;
        }
        return double.tryParse(val.toString()) ?? 0.0;
      })(),
      labSonucPdf: json['lab_sonuc_pdf'] as String? ?? '',
      urunSertifikaPdf: json['urun_sertifika_pdf'] as String? ?? '',
      kapakGorseli: json['kapak_gorseli'] as String? ?? '',
      urunGorunurluluk: json['urun_gorunurluluk'] as bool? ?? false,
      satis_turu: json['satis_turu'] as int? ?? 0,
      satici: json['satici'] as int? ?? 0,
      kategori: json['kategori'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'urun_id': urunId,
      'urun_adi': urunAdi,
      'aciklama': aciklama,
      'urun_uretim_tarihi': urunUretimTarihi,
      'urun_ekleme_tarihi': urunEklemeTarihi,
      'urunbilgisi_guncelleme_tarihi': urunBilgisiGuncellemeTarihi,
      'stok_durumu': stokDurumu,
      'degerlendirme_puani': degerlendirmePuani,
      'lab_sonuc_pdf': labSonucPdf,
      'urun_sertifika_pdf': urunSertifikaPdf,
      'kapak_gorseli': kapakGorseli,
      'urun_gorunurluluk': urunGorunurluluk,
      'satis_turu': satis_turu,
      'satici': satici,
      'kategori': kategori,
    };
  }
}
