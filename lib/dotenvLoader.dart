import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';

class DotenvLoaderApp extends StatelessWidget {
  final Widget child;
  const DotenvLoaderApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dotenv.load(fileName: ".env"),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            home: Scaffold(
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildLoadingBar(context),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        }
        return child;
      },
    );
  }
}
