part of '../buyer_profil_screen.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({Key? key}) : super(key: key);

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuponlarım'),
      ),
      body: Center(
        child: Text('Kuponlar burada listelenecek.'),
      ),
    );
  }
}
