part of '../seller_profil_screen.dart';

AppBar _sellerProfilAppBar(BuildContext context, bool myProfile) {
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
          children: [shareIconButton(context), _sellerSettingsMenu(context, myProfile)],
        ),
      ),
    ],
  );
}

PopupMenuButton<String> _sellerSettingsMenu(BuildContext context, bool myProfile) {
  return PopupMenuButton<String>(
    icon: const Icon(Icons.settings_outlined),
    onSelected: (value) async {
      if (value == 'logout') {
        final bool? confirm = await _confirmLogoutDialog(context, myProfile);
        if (confirm != true) return;
        await _handleLogout(context);
      } else if (value == 'whoWeAre') {
        // Biz Kimiz sayfasına yönlendir
        // Navigator.pushNamed(context, '/whoWeAre');
      } else if (value == 'contact') {
        // İletişim sayfasına yönlendir
        // Navigator.pushNamed(context, '/contact');
      }
    },
    itemBuilder: (ctx) => [
      // Herkes için görünen seçenekler
      PopupMenuItem(value: 'whoWeAre', child: Text('Biz Kimiz')),
      PopupMenuItem(value: 'contact', child: Text('Bizimle İletişime Geç')),
      // Sadece kendi profili için çıkış yap
      if (myProfile)
        PopupMenuItem(value: 'logout', child: Text('Çıkış Yap')),
    ],
  );
}

Future<bool?> _confirmLogoutDialog(BuildContext context, bool myProfile) async {
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
    showTemporarySnackBar(context, result, type: SnackBarType.success);
  } catch (e) {
    showTemporarySnackBar(context, e.toString(), type: SnackBarType.error);
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
