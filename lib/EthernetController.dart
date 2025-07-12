import 'package:flutter/material.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'dart:io';
import 'main.dart';

class EthernetController extends StatefulWidget {
  const EthernetController({super.key});

  @override
  State<EthernetController> createState() => _EthernetControllerState();
}

class _EthernetControllerState extends State<EthernetController> {
  bool _hasConnection = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _loading = true;
    });
    try {
      // Basit bir internet kontrolü için Google'a ping atılabilir
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _hasConnection = true;
          _loading = false;
        });
      } else {
        setState(() {
          _hasConnection = false;
          _loading = false;
        });
      }
    } catch (_) {
      setState(() {
        _hasConnection = false;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: buildLoadingBar(context)),
        ),
      );
    }
    if (!_hasConnection) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'İnternet Bağlantınızı Kontrol Edin',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _checkConnection,
                  child: const Text('Tekrar Deneyin'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const MyApp();
  }
}
