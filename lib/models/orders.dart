class Order {
  final int siparisId;
  final DateTime? siparisVerilmeTarihi;
  final String durum;
  final String toplamFiyat;
  final int alici;
  final int faturaAdresi;

  const Order({
    required this.siparisId,
    required this.siparisVerilmeTarihi,
    required this.durum,
    required this.toplamFiyat,
    required this.alici,
    required this.faturaAdresi,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final dynamic tarihRaw = json['siparis_verilme_tarihi'] ?? json['tarih'];
    final String? tarihStr = tarihRaw?.toString();
    final DateTime? parsedDate = (tarihStr == null || tarihStr.isEmpty)
        ? null
        : DateTime.tryParse(tarihStr);

    final dynamic toplamRaw = json['toplam_fiyat'] ?? json['toplam'];

    return Order(
      siparisId:
          int.tryParse((json['siparis_id'] ?? json['id']).toString()) ?? 0,
      siparisVerilmeTarihi: parsedDate,
      durum: (json['durum'] ?? '').toString(),
      toplamFiyat: (toplamRaw ?? '0').toString(),
      alici: int.tryParse((json['alici'] ?? 0).toString()) ?? 0,
      faturaAdresi: int.tryParse(
              (json['fatura_adresi'] ?? json['fatura_adres'] ?? 0)
                  .toString()) ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'siparis_id': siparisId,
      'siparis_verilme_tarihi': siparisVerilmeTarihi?.toIso8601String(),
      'durum': durum,
      'toplam_fiyat': toplamFiyat,
      'alici': alici,
      'fatura_adresi': faturaAdresi,
    };
  }

  double? get toplamFiyatDouble => double.tryParse(toplamFiyat);

  static List<Order> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
