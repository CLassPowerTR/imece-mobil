part of '../home_screen.dart';

class HomeHeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeaderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: HomeStyle(context: context).surface,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: HomeStyle(context: context).primary),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: homeTextFieldBar(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.mail_outline, color: DesignTokens.textSecondary),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: DesignTokens.textSecondary),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 5.0);
}
