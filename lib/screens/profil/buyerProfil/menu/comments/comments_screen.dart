import 'package:flutter/material.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'package:imecehub/core/widgets/turnBackTextIcon.dart';
import 'package:imecehub/models/users.dart';
import 'package:imecehub/providers/auth_provider.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'seller_comments_screen.dart';
part 'products_comments_screen.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey[300],
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        leading: TurnBackTextIcon(),
        title: customText('Değerlendirmelerim', context,
            size: HomeStyle(context: context).bodyLarge.fontSize,
            weight: FontWeight.w600),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            labelColor: secondary,
            unselectedLabelColor: theme.textTheme.bodyLarge?.color,
            indicator: BoxDecoration(
              color: secondary.withOpacity(0.15),
              border: Border(
                bottom: BorderSide(color: secondary, width: 2),
              ),
            ),
            tabs: const [
              Tab(text: 'Ürün Değerlendirmelerim'),
              Tab(text: 'Mağaza Değerlendirmelerim'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Ürün Değerlendirmelerim
          ProductsCommentsScreen(user: user),
          // Mağaza Değerlendirmelerim
          SellerCommentsScreen(user: user),
        ],
      ),
    );
  }
}
