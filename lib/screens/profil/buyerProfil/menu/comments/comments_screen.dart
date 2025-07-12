import 'package:flutter/material.dart';
import 'package:imecehub/core/widgets/buildLoadingBar.dart';
import 'package:imecehub/services/api_service.dart';

part 'seller_comments_screen.dart';
part 'products_comments_screen.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen>
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
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Değerlendirmelerim'),
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
          ProductsCommentsScreen(),
          // Mağaza Değerlendirmelerim
          SellerCommentsScreen(),
        ],
      ),
    );
  }
}
