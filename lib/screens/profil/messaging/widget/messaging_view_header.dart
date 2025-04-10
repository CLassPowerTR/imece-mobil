part of '../messaging_view.dart';

class _MessagingViewHeaderAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _MessagingViewHeaderAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: MediaQuery.of(context).size.width * 0.4,
      toolbarHeight: MediaQuery.of(context).size.height *
          0.06, //AppBar yüksekliği ekran boyutununa oranı

      bottom: PreferredSize(
        preferredSize: preferredSize,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            label: customText('Profile Geri Dön', context,
                color: HomeStyle(context: context).secondary,
                size: HomeStyle(context: context).bodyLarge.fontSize),
            icon: Icon(
              Icons.keyboard_backspace,
              color: HomeStyle(context: context).secondary,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10.0);
}
