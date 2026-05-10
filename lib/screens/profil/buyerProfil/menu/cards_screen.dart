
part of '../buyer_profil_screen.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final storage = FlutterSecureStorage();
  List<CardInfo> cards = [];
  bool isLoading = true;

  // Kart renk paletleri
  final List<List<Color>> cardColors = [
    [Colors.blue, Colors.purple],
    [Colors.teal, Colors.cyan],
    [Colors.orange, Colors.deepOrange],
    [Colors.indigo, Colors.blue],
    [Colors.pink, Colors.red],
    [Colors.green, Colors.teal],
  ];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() => isLoading = true);
    
    try {
      final storedCards = await storage.read(key: 'savedCards');
      if (storedCards != null && storedCards.isNotEmpty) {
        final List<dynamic> cardsList = jsonDecode(storedCards);
        cards = cardsList.map((c) => CardInfo.fromJson(c)).toList();
      } else {
        // Eski format kontrolü (geriye uyumluluk)
        final oldCardNumber = await storage.read(key: 'cardNumber');
        if (oldCardNumber != null && oldCardNumber.isNotEmpty) {
          cards = [
            CardInfo(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              cardNumber: oldCardNumber,
              cardLateUseDate: await storage.read(key: 'lateDate') ?? '',
              cardCvv: await storage.read(key: 'cvv') ?? '',
              cardUserName: await storage.read(key: 'cartUserName') ?? '',
              cardName: await storage.read(key: 'cartName') ?? 'Kartım',
            ),
          ];
          // Yeni formata taşı
          await _saveCards();
        }
      }
    } catch (e) {
      debugPrint('Kart yükleme hatası: $e');
    }
    
    setState(() => isLoading = false);
  }

  Future<void> _saveCards() async {
    final cardsJson = jsonEncode(cards.map((c) => c.toJson()).toList());
    await storage.write(key: 'savedCards', value: cardsJson);
  }

  Future<void> _deleteCard(CardInfo card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kartı Sil'),
        content: Text('${card.cardName} isimli kartı silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        cards.removeWhere((c) => c.id == card.id);
      });
      await _saveCards();
      if (mounted) {
        showTemporarySnackBar(context, 'Kart silindi', type: SnackBarType.success);
      }
    }
  }

  void _editCard(CardInfo card) {
    Navigator.pushNamed(
      context,
      '/cart/addCreditCart',
      arguments: {
        'editMode': true,
        'cardId': card.id,
        'cardNumber': card.cardNumber,
        'lateUseDate': card.cardLateUseDate,
        'cvv': card.cardCvv,
        'cartUserName': card.cardUserName,
        'cartName': card.cardName,
      },
    ).then((_) => _loadCards());
  }

  Future<void> _setAsDefault(CardInfo selectedCard) async {
    setState(() {
      cards = cards.map((c) {
        return CardInfo(
          id: c.id,
          cardNumber: c.cardNumber,
          cardLateUseDate: c.cardLateUseDate,
          cardCvv: c.cardCvv,
          cardUserName: c.cardUserName,
          cardName: c.cardName,
          isDefault: c.id == selectedCard.id,
          customColors: c.customColors,
        );
      }).toList();
    });
    await _saveCards();
    if (mounted) {
      showTemporarySnackBar(context, 'Varsayılan kart güncellendi', type: SnackBarType.success);
    }
  }

  void _addNewCard() {
    Navigator.pushNamed(
      context,
      '/cart/addCreditCart',
      arguments: {'editMode': false},
    ).then((_) => _loadCards());
  }

  List<Color> _getCardColors(int index) {
    return cardColors[index % cardColors.length];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey[300],
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        title: customText(
          'Kartlarım',
          context,
          size: AppTextSizes.bodyLarge(context),
          weight: FontWeight.w600,
        ),
        leading: TurnBackTextIcon(),
        actions: [
          if (cards.isNotEmpty)
            IconButton(
              icon: Icon(Icons.add_card, color: AppColors.primary(context)),
              onPressed: _addNewCard,
              tooltip: 'Yeni Kart Ekle',
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cards.isEmpty
              ? _buildEmptyState(context)
              : _buildCardsList(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary(context).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.credit_card_off_outlined,
                size: 64,
                color: AppColors.primary(context).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz Kart Eklenmemiş',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface(context),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Hızlı ödeme yapmak için kartlarınızı\ngüvenle kaydedin.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.onSurface(context).withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _addNewCard,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_card),
              label: const Text(
                'İlk Kartınızı Ekleyin',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        final colors = _getCardColors(index);

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kart ismi ve Varsayılan Kontrolü
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: 16,
                      color: AppColors.onSurface(context).withOpacity(0.5),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        card.cardName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface(context).withOpacity(0.7),
                        ),
                      ),
                    ),
                    // Varsayılan Seçim Butonu
                    GestureDetector(
                      onTap: () => _setAsDefault(card),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: card.isDefault 
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: card.isDefault 
                                ? Colors.green.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.3)
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              card.isDefault ? Icons.check_circle : Icons.circle_outlined, 
                              size: 14, 
                              color: card.isDefault ? Colors.green : Colors.grey
                            ),
                            const SizedBox(width: 4),
                            Text(
                              card.isDefault ? 'Varsayılan' : 'Varsayılan Yap',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: card.isDefault ? Colors.green : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Kart widget
              CreditCartWidget(
                cardUserName: card.cardUserName,
                cardNumber: card.cardNumber,
                cardLateUseDate: card.cardLateUseDate,
                cardCvv: card.cardCvv,
                cardName: card.cardName,
                topLeftColor: colors[0],
                bottomRightColor: colors[1],
                showActions: true,
                onEdit: () => _editCard(card),
                onDelete: () => _deleteCard(card),
              ),
            ],
          ),
        );
      },
    );
  }
}
