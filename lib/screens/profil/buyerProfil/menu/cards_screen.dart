part of '../buyer_profil_screen.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final storage = FlutterSecureStorage();
  String? cardNumber;
  String? cardLateUseDate;
  String? cardCvv;
  String? cardUserName;
  String? cardName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCardInfo();
  }

  Future<void> _loadCardInfo() async {
    final storedCardNumber = await storage.read(key: 'cardNumber');
    final storedLateDate = await storage.read(key: 'lateDate');
    final storedCvv = await storage.read(key: 'cvv');
    final storedCartUserName = await storage.read(key: 'cartUserName');
    final storedCartName = await storage.read(key: 'cartName');
    setState(() {
      cardNumber = storedCardNumber;
      cardLateUseDate = storedLateDate;
      cardCvv = storedCvv;
      cardUserName = storedCartUserName;
      cardName = storedCartName;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = HomeStyle(context: context);
    final _cardNumberController = TextEditingController();
    final _lateUseDateController = TextEditingController();
    final _cvvController = TextEditingController();
    final _cartUserNameController = TextEditingController();
    final _cartNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey[300],
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        title: const Text('Kartlarım'),
        leading: TextButton.icon(
          style: TextButton.styleFrom(
            minimumSize: const Size(0, kToolbarHeight),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 20,
            color: HomeStyle(context: context).secondary,
          ),
          label: customText(
            'Geri Dön',
            context,
            weight: FontWeight.w600,
            color: HomeStyle(context: context).secondary,
            size: 14,
          ),
        ),
      ),
      body: isLoading
          ? const Stack(
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            )
          : cardNumber == null || cardNumber!.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 16,
                      children: [
                        const Text('Kayıtlı kart bulunamadı.'),
                        textButton(
                          context,
                          'Kart Ekle',
                          elevation: 6,
                          fontSize: themeData.bodyLarge.fontSize,
                          weight: FontWeight.bold,
                          shadowColor: themeData.secondary,
                          onPressed: () {
                            setState(() {
                              showTemporarySnackBar(
                                  context, 'Kart Ekle Buton (){onPressed}');
                              Navigator.pushNamed(
                                context,
                                '/cart/addCreditCart',
                                arguments: {
                                  'cardNumber': _cardNumberController.text,
                                  'lateUseDate': _lateUseDateController.text,
                                  'cvv': _cvvController.text,
                                  'cartUserName': _cartUserNameController.text,
                                  'cartName': _cartNameController.text,
                                },
                              );
                            });
                          },
                        )
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: [
                      CreditCartWidget(
                        cardUserName: cardUserName ?? '',
                        cardNumber: cardNumber ?? '',
                        cardLateUseDate: cardLateUseDate ?? '',
                        cardCvv: cardCvv ?? '',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        cardName != null && cardName!.isNotEmpty
                            ? 'Kart İsmi: $cardName'
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
    );
  }
}
