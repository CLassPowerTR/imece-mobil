part of 'order_screen.dart';

SafeArea orderScreenBody(
    BuildContext context,
    String? selectedCard,
    ValueChanged<String?> onCardChanged,
    String? selectedIban,
    ValueChanged<String?> onIbanChanged,
    FocusNode focusNode) {
  return SafeArea(
    child: SingleChildScrollView(
      child: Container(
        color: Colors.white,
        //margin: EdgeInsets.all(10),
        child: Column(children: [
          Card(
            color: Colors.white,
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      'assets/image/img_map.png',
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 30, left: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Türkiye / İstanbul',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                        Text(
                          'Çınar Mahallesi 878 sokak no 14 daire 1 İstanbul Bağcılar',
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          margin: EdgeInsets.all(0),
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Konum bilgileri değiştir',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 34, 255, 34),
                                    fontWeight: FontWeight.w900),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  margin: EdgeInsets.only(left: 10),
                  child: Image.asset(
                    'assets/image/img_truck.png',
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox();
                    },
                  ),
                ),
                Expanded(
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tahmini Teslimat Tarihi',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    '09 / 01 / 2025',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 34, 255, 34),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      decorationColor:
                                          Color.fromARGB(255, 34, 255, 34),
                                    ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.start,
                                    '(2 gün sonra)',
                                    style: TextStyle(fontSize: 14),
                                  )
                                ],
                              ),
                              Text(
                                'Teslimat zamanı değişebilir!',
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.03,
            color: Colors.grey[100],
          ),
          Container(
            margin: EdgeInsets.only(left: 20, top: 5, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/image/img_mandalina.png',
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox();
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Turuncu Mandalina',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 17),
                          ),
                          Text(
                            'Tatlı, Sulu, Turuncu, mandalina, turunçgil',
                            overflow: TextOverflow
                                .ellipsis, // Metin taşarsa sonuna "..." ekler
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Muhammet Yusuf Akar',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                        )),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    spacing: 10,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white, // İsteğe bağlı arka plan rengi
                          borderRadius:
                              BorderRadius.circular(5), // Köşe yuvarlaklığı 5
                          border: Border.all(
                              width: 2,
                              color: Colors
                                  .black), // İnce bir kenarlık (opsiyonel)
                        ),
                        child: Row(
                          children: [
                            // Sol tarafta "11 KG" yazısı
                            Text(
                              '11 KG',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Sağ tarafta - ve + butonları
                            Row(
                              children: [
                                // "-" butonu
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    // '-' butonunun işlevi buraya
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  iconSize: 20,
                                ),
                                // "+" butonu
                                Container(
                                  color: Colors.black,
                                  height: 20,
                                  width: 1,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    // '+' butonunun işlevi buraya
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Text(
                                '1KG:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                '36 Türk Lirası',
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Row(
                            spacing: 5,
                            children: [
                              Text(
                                'Maks. KG:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text('56', style: TextStyle(fontSize: 12))
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Ürün Tutarı',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              '340 Türk Lirası',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    spacing: 10,
                    children: [
                      Image.asset(
                        'assets/image/img_addProduct.png',
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox();
                        },
                      ),
                      Text(
                        'ürün ekle',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 17),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.03,
            color: Colors.grey[100],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.3), // Gölge rengi
                  spreadRadius: 1, // Yayılma oranı
                  blurRadius: 10, // Bulanıklık seviyesi
                  offset: Offset(0, 4), // X=0, Y=4 → Sadece aşağıya gölge ekler
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ara Toplam',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      'Satın alınan farklı ürün sayısı:',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                    ),
                    Text('1 adet')
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      'Ürünlerin Tutarı:',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                    ),
                    Text('340 Türk Lirası')
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.03,
            color: Colors.grey[100],
          ),
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ödeme için Kart Seç',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        alignment: Alignment.centerLeft,
                        borderRadius: BorderRadius.circular(5),
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                        ),
                        value: selectedCard,
                        isExpanded: true,
                        onChanged: onCardChanged,
                        items: [
                          DropdownMenuItem(
                            value: 'Visa Card',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/ic_visacard.png',
                                  width: 24,
                                  height: 24,
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox();
                                  },
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Visa Card',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Master Card',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/ic_mastercard.png',
                                  width: 24,
                                  height: 24,
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox();
                                  },
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Master Card',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Troy Card',
                            child: Row(
                              children: [
                                Image.network(
                                    'https://image.troyodeme.com//File/troy-acilim.png',
                                    width: 24,
                                    height: 24),
                                SizedBox(width: 8),
                                Text(
                                  'Troy Card',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.35,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        alignment: Alignment.centerLeft,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                        ),
                        value: selectedIban,
                        isExpanded: true,
                        onChanged: onIbanChanged,
                        items: [
                          DropdownMenuItem(
                            value: 'İban',
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icon/ic_ziraatBankasi.png',
                                  width: 18,
                                  height: 18,
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox();
                                  },
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'İban',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Kupon veya İndirim kodu gir',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Image.asset(
                      'assets/icon/ic_ticket.png',
                      width: 45,
                      height: 45,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox();
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        focusNode: focusNode,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(),
                          hintText: focusNode.hasFocus ? '' : '0000000',
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    ),
  );
}
