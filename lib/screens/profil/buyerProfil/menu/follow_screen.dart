part of '../buyer_profil_screen.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({Key? key}) : super(key: key);

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takip Ettiklerim'),
      ),
      body: Center(
        child: Text('Takip edilenler burada listelenecek.'),
      ),
    );
  }
}
