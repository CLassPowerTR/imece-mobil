part of 'order_screen.dart';


class OrderScreenBody extends StatefulWidget {
  final String? selectedCard;
  final ValueChanged<String?> onCardChanged;
  final String? selectedIban;
  final ValueChanged<String?> onIbanChanged;
  final FocusNode focusNode;

  const OrderScreenBody({
    Key? key,
    required this.selectedCard,
    required this.onCardChanged,
    required this.selectedIban,
    required this.onIbanChanged,
    required this.focusNode,
  }) : super(key: key);

  @override
  _OrderScreenBodyState createState() => _OrderScreenBodyState();
}

class _OrderScreenBodyState extends State<OrderScreenBody> {
  late Future<Map<String, dynamic>> _sepetFuture;
  String ic_ticket =
      "https://www.google.com/imgres?q=ticket%20icon&imgurl=https%3A%2F%2Fwww.svgrepo.com%2Fshow%2F326845%2Fticket-outline.svg&imgrefurl=https%3A%2F%2Fwww.svgrepo.com%2Fsvg%2F326845%2Fticket-outline&docid=R1UztiKmlx_AWM&tbnid=lwM-D8NyGUByPM&vet=12ahUKEwjQ8oj37pOOAxUvSfEDHYGzJ8cQM3oECBsQAA..i&w=800&h=800&hcb=2&ved=2ahUKEwjQ8oj37pOOAxUvSfEDHYGzJ8cQM3oECBsQAA";
  String ic_map =
      "https://www.google.com/imgres?q=map%20icon&imgurl=https%3A%2F%2Fpics.freeicons.io%2Fuploads%2Ficons%2Fpng%2F9143113441535956911-512.png&imgrefurl=https%3A%2F%2Ffreeicons.io%2Fdaily-use-and-life-style-icons%2Fmap-google%2520map-location-icon-1378&docid=ZDNuCXzNEhVl4M&tbnid=H3IKUVZ_YzUhaM&vet=12ahUKEwjMsYOK75OOAxWuVPEDHecfL3QQM3oECGcQAA..i&w=512&h=512&hcb=2&ved=2ahUKEwjMsYOK75OOAxWuVPEDHecfL3QQM3oECGcQAA";
  String ic_truck =
      "https://www.google.com/imgres?q=truck%20icon&imgurl=https%3A%2F%2Fwww.iconpacks.net%2Ficons%2F1%2Ffree-truck-icon-1058-thumb.png&imgrefurl=https%3A%2F%2Fwww.iconpacks.net%2Ffree-icon%2Ftruck-1058.html&docid=bizg7D8mL6GfRM&tbnid=uMWDGHndW9MY0M&vet=12ahUKEwi849ud75OOAxVdQ_EDHVMTN6cQM3oECGcQAA..i&w=512&h=512&hcb=2&ved=2ahUKEwi849ud75OOAxVdQ_EDHVMTN6cQM3oECGcQAA";
  String ic_mandalina =
      "https://www.google.com/imgres?q=mandalina%20icon&imgurl=https%3A%2F%2Fw7.pngwing.com%2Fpngs%2F336%2F120%2Fpng-transparent-mandarin-orange-tangerine-tangerine-orange-citrus-logo.png&imgrefurl=https%3A%2F%2Fwww.pngwing.com%2Ftr%2Ffree-png-zutdb&docid=B9CeoLM85ovNxM&tbnid=TVIincIwlMg4NM&vet=12ahUKEwifqt-x75OOAxWDQvEDHX1dMFQQM3oECH4QAA..i&w=920&h=598&hcb=2&itg=1&ved=2ahUKEwifqt-x75OOAxWDQvEDHX1dMFQQM3oECH4QAA";
  String ic_visacard =
      "https://www.google.com/imgres?q=visa%20icon&imgurl=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2F5%2F5e%2FVisa_Inc._logo.svg%2F2560px-Visa_Inc._logo.svg.png&imgrefurl=https%3A%2F%2Ftr.m.wikipedia.org%2Fwiki%2FDosya%3AVisa_Inc._logo.svg&docid=bMWGx7rZzuufMM&tbnid=HJwGCYTXeIHnwM&vet=12ahUKEwjrquzK75OOAxVRHBAIHVmjLuQQM3oECGQQAA..i&w=2560&h=829&hcb=2&ved=2ahUKEwjrquzK75OOAxVRHBAIHVmjLuQQM3oECGQQAA";
  String ic_mastercard =
      "https://www.google.com/imgres?q=mastercard%20icon&imgurl=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2Fthumb%2Fb%2Fb7%2FMasterCard_Logo.svg%2F1280px-MasterCard_Logo.svg.png&imgrefurl=https%3A%2F%2Ftr.m.wikipedia.org%2Fwiki%2FDosya%3AMasterCard_Logo.svg&docid=-f50CVIx2-IFJM&tbnid=AqW71AenfQzC2M&vet=12ahUKEwjTqsja75OOAxXjBtsEHRcHOecQM3oECGUQAA..i&w=1280&h=768&hcb=2&ved=2ahUKEwjTqsja75OOAxXjBtsEHRcHOecQM3oECGUQAA";
  String ic_ziraatBank =
      "https://www.google.com/imgres?q=ziraat%20bank%20icon&imgurl=https%3A%2F%2Fw7.pngwing.com%2Fpngs%2F12%2F951%2Fpng-transparent-ziraat-bankas%25C4%25B1-turkiye-%25C4%25B0%25C5%259F-bankas%25C4%25B1-credit-turkey-bank-text-payment-logo-thumbnail.png&imgrefurl=https%3A%2F%2Fwww.pngwing.com%2Fen%2Fsearch%3Fq%3Dziraat%2BBankas%25C4%25B1&docid=dbQLdlvVAvUm4M&tbnid=5qRUTt0xEYJ_WM&vet=12ahUKEwiM76n38JOOAxVsXvEDHQ0lMHwQM3oECFcQAA..i&w=360&h=156&hcb=2&ved=2ahUKEwiM76n38JOOAxVsXvEDHQ0lMHwQM3oECFcQAA";
  String ic_addProduct =
      "https://www.google.com/imgres?q=add%20product%20icon&imgurl=https%3A%2F%2Fcdn-icons-png.flaticon.com%2F512%2F7387%2F7387315.png&imgrefurl=https%3A%2F%2Fwww.flaticon.com%2Ffree-icon%2Fadd-product_7387315&docid=3kI8IsrBfWJUwM&tbnid=fBsrgdgr-3F1wM&vet=12ahUKEwjspZ3j8JOOAxXGVPEDHWTQH5wQM3oECGwQAA..i&w=512&h=512&hcb=2&ved=2ahUKEwjspZ3j8JOOAxXGVPEDHWTQH5wQM3oECGwQAA";

  @override
  void initState() {
    super.initState();
    _fetchSepet();
  }

  // Otomatik ve manuel yenileme için fonksiyon
  void _fetchSepet() {
    setState(() {
      _sepetFuture = ApiService.fetchSepetGet();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sayfa her ekrana geldiğinde otomatik yenileme
    _fetchSepet();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
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
                        child: Image.network(
                          ic_map,
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
                      child: Image.network(
                        ic_truck,
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
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16),
                                  ),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Text(
                                        '09 / 01 / 2025',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 34, 255, 34),
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
                        Image.network(
                          ic_mandalina,
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
                              color:
                                  Colors.white, // İsteğe bağlı arka plan rengi
                              borderRadius: BorderRadius.circular(
                                  5), // Köşe yuvarlaklığı 5
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
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
                          Image.network(
                            ic_addProduct,
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
                      offset:
                          Offset(0, 4), // X=0, Y=4 → Sadece aşağıya gölge ekler
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          'Satın alınan farklı ürün sayısı:',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w900),
                        ),
                        Text('1 adet')
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          'Ürünlerin Tutarı:',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w900),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
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
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                            ),
                            value: widget.selectedCard,
                            isExpanded: true,
                            onChanged: widget.onCardChanged,
                            items: [
                              DropdownMenuItem(
                                value: 'Visa Card',
                                child: Row(
                                  children: [
                                    Image.network(
                                      ic_visacard,
                                      width: 24,
                                      height: 24,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                    Image.network(
                                      ic_mastercard,
                                      width: 24,
                                      height: 24,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              border: InputBorder.none,
                            ),
                            value: widget.selectedIban,
                            isExpanded: true,
                            onChanged: widget.onIbanChanged,
                            items: [
                              DropdownMenuItem(
                                value: 'İban',
                                child: Row(
                                  children: [
                                    Image.network(
                                      ic_ziraatBank,
                                      width: 18,
                                      height: 18,
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Image.network(
                          ic_ticket,
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
                            focusNode: widget.focusNode,
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              hintText:
                                  widget.focusNode.hasFocus ? '' : '0000000',
                            ),
                          ),
                        )
                      ],
                    ),
                    // Sepet verilerini çekmek için örnek FutureBuilder
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _fetchSepet,
                          child: Text('Sepeti Yenile'),
                        ),
                      ],
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                      future: _sepetFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildLoadingBar(context),
                              const SizedBox(height: 16),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showTemporarySnackBar(
                                context, snapshot.error.toString());
                          });
                          return Text('Sepet verisi alınamadı.');
                        } else if (snapshot.hasData) {
                          final data = snapshot.data!;
                          if (data['durum'] == 'SEPET_DOLU' &&
                              data['sepet'] is List) {
                            final sepetList = data['sepet'] as List;
                            // Sepet dolu ise, ürünleri listele
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sepetinizdeki Ürünler:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ...sepetList.map<Widget>((item) {
                                  return ListTile(
                                    title: Text('Ürün ID: \\${item['urun']}'),
                                    subtitle:
                                        Text('Miktar: \\${item['miktar']}'),
                                    trailing: Text(
                                        'Eklenme: \\${item['sepete_ekleme_tarihi']}'),
                                  );
                                }).toList(),
                              ],
                            );
                          } else if (data['durum'] == 'BOS_SEPET') {
                            return Text(data['mesaj'] ??
                                'Sepetinizde ürün bulunmamaktadır.');
                          } else {
                            return Text('Bilinmeyen sepet durumu.');
                          }
                        } else {
                          return Text('Sepet verisi bulunamadı.');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
