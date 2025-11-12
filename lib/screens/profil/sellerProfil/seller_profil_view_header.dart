part of 'seller_profil_screen.dart';

AppBar _sellerProfilAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 80,
    title: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: 42,
        child: profilTextField(context, hintText: 'Profil arat...'),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [shareIconButton(context), _sellerSettingsMenu(context)],
        ),
      ),
    ],
  );
}

PopupMenuButton<String> _sellerSettingsMenu(BuildContext context) {
  return PopupMenuButton<String>(
    icon: const Icon(Icons.settings_outlined),
    onSelected: (value) async {
      if (value == 'logout') {
        final bool? confirm = await _confirmLogoutDialog(context);
        if (confirm != true) return;
        await _handleLogout(context);
      }
    },
    itemBuilder: (ctx) => const [
      PopupMenuItem(value: 'logout', child: Text('Çıkış Yap')),
    ],
  );
}

Future<bool?> _confirmLogoutDialog(BuildContext context) async {
  return showDialog<bool>(
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
}

Future<void> _handleLogout(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  try {
    final result = await container.read(userProvider.notifier).logout();
    showTemporarySnackBar(context, result);
  } catch (e) {
    showTemporarySnackBar(context, e.toString());
  } finally {
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
        arguments: {'refresh': true},
      );
    }
  }
}
