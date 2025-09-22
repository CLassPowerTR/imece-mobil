part of '../../buyer_profil_screen.dart';

class MyProfileEditScreen extends StatefulWidget {
  const MyProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileEditScreen> createState() => _MyProfileEditScreenState();
}

class _MyProfileEditScreenState extends State<MyProfileEditScreen> {
  late final TextEditingController _controller;
  late final String _field;

  @override
  void initState() {
    super.initState();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _field = (args['field'] as String?) ?? '';
    _controller = TextEditingController(text: (args['value'] as String?) ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey[300],
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        leading: TurnBackTextIcon(),
        title: customText('Bilgi Düzenle', context,
            size: HomeStyle(context: context).bodyLarge.fontSize,
            weight: FontWeight.w600),
        actions: [
          TextButton(
            onPressed: () async {
              // TODO: API'ye patch atılacak (field -> value)
              Navigator.pop(
                  context, {'field': _field, 'value': _controller.text});
            },
            child: customText('Kaydet', context,
                color: HomeStyle(context: context).secondary,
                weight: FontWeight.w600,
                size: 16),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText('Alan', context,
                size: 12, color: Colors.grey[600]!, weight: FontWeight.w500),
            const SizedBox(height: 6),
            Text(_field, style: TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 16),
            customText('Değer', context,
                size: 12, color: Colors.grey[600]!, weight: FontWeight.w500),
            const SizedBox(height: 6),
            textField(
              context,
              controller: _controller,
              hintText: 'Yeni değeri girin',
            ),
          ],
        ),
      ),
    );
  }
}
