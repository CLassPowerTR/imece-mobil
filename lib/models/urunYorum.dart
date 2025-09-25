class UrunYorum {
  final String kullaniciAd;
  final String kullaniciSoyad;
  final String yorum;
  final num puan;
  final DateTime tarih;
  final List<String> resimler;

  UrunYorum({
    required this.kullaniciAd,
    required this.kullaniciSoyad,
    required this.yorum,
    required this.puan,
    required this.tarih,
    required this.resimler,
  });

  factory UrunYorum.fromJson(Map<String, dynamic> json) {
    final dynamic rawPuan = json['puan'];
    num parsedPuan;
    if (rawPuan is num) {
      parsedPuan = rawPuan;
    } else if (rawPuan is String) {
      parsedPuan = num.tryParse(rawPuan) ?? 0;
    } else {
      parsedPuan = 0;
    }

    final String? tarihStr = json['tarih'];

    return UrunYorum(
      kullaniciAd: json['kullanici_ad'] ?? '',
      kullaniciSoyad: json['kullanici_soyad'] ?? '',
      yorum: json['yorum'] ?? '',
      puan: parsedPuan,
      tarih: tarihStr != null && tarihStr.isNotEmpty
          ? DateTime.parse(tarihStr)
          : DateTime.fromMillisecondsSinceEpoch(0),
      resimler: (json['resimler'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kullanici_ad': kullaniciAd,
      'kullanici_soyad': kullaniciSoyad,
      'yorum': yorum,
      'puan': puan,
      'tarih': tarih.toIso8601String(),
      'resimler': resimler,
    };
  }
}

class UrunYorumlarResponse {
  final String durum;
  final List<UrunYorum> yorumlar;

  UrunYorumlarResponse({
    required this.durum,
    required this.yorumlar,
  });

  factory UrunYorumlarResponse.fromJson(Map<String, dynamic> json) {
    return UrunYorumlarResponse(
      durum: json['durum'] ?? '',
      yorumlar: (json['yorumlar'] as List<dynamic>? ?? [])
          .map((e) => UrunYorum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'durum': durum,
      'yorumlar': yorumlar.map((e) => e.toJson()).toList(),
    };
  }
}
