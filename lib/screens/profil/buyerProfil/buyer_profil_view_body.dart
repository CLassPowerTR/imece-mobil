part of 'buyer_profil_screen.dart';

class BuyerProfilViewBody extends ConsumerStatefulWidget {
  final User buyerProfil;

  const BuyerProfilViewBody({super.key, required this.buyerProfil});

  @override
  ConsumerState<BuyerProfilViewBody> createState() =>
      _BuyerProfilViewBodyState();
}

class _BuyerProfilViewBodyState extends ConsumerState<BuyerProfilViewBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final expandedHeight = height * 0.3;
    final isCollapsed = _scrollController.hasClients &&
        _scrollController.offset > (expandedHeight - kToolbarHeight);
    final titleColor = isCollapsed
        ? HomeStyle(context: context).primary
        : HomeStyle(context: context).onSecondary;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: expandedHeight,
          pinned: true,
          floating: false,
          snap: false,
          backgroundColor: Colors.white,
          title: customText('Hesabım', context,
              size: HomeStyle(context: context).bodyLarge.fontSize,
              color: titleColor,
              weight: FontWeight.w600),
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.grey[300],
          actions: [
            IconButton(
              icon: Icon(Icons.notification_add),
              onPressed: () {},
            ),
          ],
          actionsIconTheme: IconThemeData(color: titleColor),
          actionsPadding: EdgeInsets.only(right: 16),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: _topProfile(
              buyerProfil: widget.buyerProfil,
              height: height,
              width: width,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppPaddings.h16,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                _userMenu(
                  buyerProfil: widget.buyerProfil,
                ),
                SizedBox(height: 24),
                Divider(),
                _logoutButton(
                  onLogout: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 3;
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false,
                        arguments: {'refresh': true});
                  },
                ),
                SizedBox(height: height * 0.2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
