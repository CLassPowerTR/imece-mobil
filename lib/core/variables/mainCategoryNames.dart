enum MainCategory {
  meyveler,
  sebzeler,
  elektronik,
  modaVeGiyim,
  evVeYasam,
  kozmetikVeKisiselBakim,
  sporVeOutdoor,
  anneBebekUrunleri,
  kitapFilmMuzikVeHobi,
  otomobilVeMotosiklet,
  supermarketVeGida,
  petShop,
  saglikVeMedikalUrunler,
}

String mainCategoryToString(MainCategory category) {
  switch (category) {
    case MainCategory.meyveler:
      return 'Meyveler';
    case MainCategory.sebzeler:
      return 'Sebzeler';
    case MainCategory.elektronik:
      return 'Elektronik';
    case MainCategory.modaVeGiyim:
      return 'Moda ve Giyim';
    case MainCategory.evVeYasam:
      return 'Ev ve Yaşam';
    case MainCategory.kozmetikVeKisiselBakim:
      return 'Kozmetik ve Kişisel Bakım';
    case MainCategory.sporVeOutdoor:
      return 'Spor ve Outdoor';
    case MainCategory.anneBebekUrunleri:
      return 'Anne & Bebek Ürünleri';
    case MainCategory.kitapFilmMuzikVeHobi:
      return 'Kitap, Film, Müzik ve Hobi';
    case MainCategory.otomobilVeMotosiklet:
      return 'Otomobil ve Motosiklet';
    case MainCategory.supermarketVeGida:
      return 'Süpermarket & Gıda';
    case MainCategory.petShop:
      return 'Pet Shop (Evcil Hayvan Ürünleri)';
    case MainCategory.saglikVeMedikalUrunler:
      return 'Sağlık ve Medikal Ürünler';
  }
}

MainCategory? mainCategoryFromInt(int? value) {
  if (value == null) return null;
  switch (value) {
    case 1:
      return MainCategory.meyveler;
    case 2:
      return MainCategory.sebzeler;
    case 3:
      return MainCategory.elektronik;
    case 4:
      return MainCategory.modaVeGiyim;
    case 5:
      return MainCategory.evVeYasam;
    case 6:
      return MainCategory.kozmetikVeKisiselBakim;
    case 7:
      return MainCategory.sporVeOutdoor;
    case 8:
      return MainCategory.anneBebekUrunleri;
    case 9:
      return MainCategory.kitapFilmMuzikVeHobi;
    case 10:
      return MainCategory.otomobilVeMotosiklet;
    case 11:
      return MainCategory.supermarketVeGida;
    case 12:
      return MainCategory.petShop;
    case 13:
      return MainCategory.saglikVeMedikalUrunler;
    default:
      return null;
  }
}
