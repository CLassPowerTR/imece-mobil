
part of '../home_screen.dart';

class HomeHeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeaderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface(context),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: AppColors.primary(context)),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.only(top: 5),
        child: homeTextFieldBar(context),
      ),
      actions: [
        Badge(
          label: const Text('2'),
          backgroundColor: Colors.red,
          alignment: Alignment.topRight,
          offset: const Offset(-4, 4),
          child: IconButton(
            icon: Icon(Icons.mail_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ),
        Badge(
          label: const Text('5'),
          backgroundColor: Colors.red,
          alignment: Alignment.topRight,
          offset: const Offset(-4, 4),
          child: IconButton(
            icon: Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 5.0);
}
