class SellerProducts {
  final int urunId;
  final String urunAdi;
  final String aciklama;
  final String? urunUretimTarihi;
  final String urunEklemeTarihi;
  final String urunBilgisiGuncellemeTarihi;
  final bool imeceOnayli;
  final String urunPerakendeFiyati;
  final String urunMinFiyati;
  final int stokDurumu;
  final double degerlendirmePuani;
  final String? labSonucPdf;
  final String? urunSertifikaPdf;
  final String kapakGorseli;
  final bool urunGorunurluluk;
  final int satisTuru;
  final int satici;
  final int kategori;

  SellerProducts({
    required this.urunId,
    required this.urunAdi,
    required this.aciklama,
    required this.urunUretimTarihi,
    required this.urunEklemeTarihi,
    required this.urunBilgisiGuncellemeTarihi,
    required this.imeceOnayli,
    required this.urunPerakendeFiyati,
    required this.urunMinFiyati,
    required this.stokDurumu,
    required this.degerlendirmePuani,
    required this.labSonucPdf,
    required this.urunSertifikaPdf,
    required this.kapakGorseli,
    required this.urunGorunurluluk,
    required this.satisTuru,
    required this.satici,
    required this.kategori,
  });

  factory SellerProducts.fromJson(Map<String, dynamic> json) {
    double parseRating(dynamic value) {
      if (value == null || value == '-' || value.toString().isEmpty) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return SellerProducts(
      urunId: json['urun_id'] as int,
      urunAdi: json['urun_adi'] as String? ?? '',
      aciklama: json['aciklama'] as String? ?? '',
      urunUretimTarihi: json['urun_uretim_tarihi'] as String?,
      urunEklemeTarihi: json['urun_ekleme_tarihi'] as String? ?? '',
      urunBilgisiGuncellemeTarihi:
          json['urunbilgisi_guncelleme_tarihi'] as String? ?? '',
      imeceOnayli: json['imece_onayli'] as bool? ?? false,
      urunPerakendeFiyati: json['urun_perakende_fiyati'] as String? ?? '',
      urunMinFiyati: json['urun_min_fiyati'] as String? ?? '',
      stokDurumu: json['stok_durumu'] as int? ?? 0,
      degerlendirmePuani: parseRating(json['degerlendirme_puani']),
      labSonucPdf: json['lab_sonuc_pdf'] as String?,
      urunSertifikaPdf: json['urun_sertifika_pdf'] as String?,
      kapakGorseli: json['kapak_gorseli'] as String? ?? '',
      urunGorunurluluk: json['urun_gorunurluluk'] as bool? ?? false,
      satisTuru: json['satis_turu'] as int? ?? 0,
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
      'imece_onayli': imeceOnayli,
      'urun_perakende_fiyati': urunPerakendeFiyati,
      'urun_min_fiyati': urunMinFiyati,
      'stok_durumu': stokDurumu,
      'degerlendirme_puani': degerlendirmePuani,
      'lab_sonuc_pdf': labSonucPdf,
      'urun_sertifika_pdf': urunSertifikaPdf,
      'kapak_gorseli': kapakGorseli,
      'urun_gorunurluluk': urunGorunurluluk,
      'satis_turu': satisTuru,
      'satici': satici,
      'kategori': kategori,
    };
  }
}
