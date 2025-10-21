import 'package:flutter/material.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/services/api_service.dart';

Widget settingsIconButton(BuildContext context) {
  return PopupMenuButton<String>(
    icon: const Icon(Icons.settings_outlined),
    onSelected: (value) async {
      if (value == 'logout') {
        final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Onay'),
            content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Hayır'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Evet'),
              ),
            ],
          ),
        );
        if (confirm != true) return;

        try {
          final result = await ApiService.fetchUserLogout();
          showTemporarySnackBar(context, result);
        } catch (e) {
          showTemporarySnackBar(context, e.toString());
        } finally {
          if (context.mounted) {
            // Ekranı yenilemek için ana sayfaya geri dön
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
              arguments: {'refresh': true},
            );
          }
        }
      }
    },
    itemBuilder: (ctx) => [
      const PopupMenuItem(value: 'logout', child: Text('Çıkış Yap')),
    ],
  );
}

IconButton shareIconButton(BuildContext context) {
  return IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined));
}

IconButton shopIconButton(BuildContext context) {
  return IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart_outlined));
}

IconButton favoriIconButton(
  BuildContext context,
  Function()? onPressed, {
  bool selected = false,
}) {
  return IconButton(
    onPressed: onPressed,
    icon: Icon(
      selected ? Icons.favorite : Icons.favorite_border,
      color: Colors.red,
    ),
  );
}
