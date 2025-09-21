import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/widgets/shadow.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/models/campaigns.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

class StoryCampaingsCard extends StatefulWidget {
  final double width;
  final double height;
  const StoryCampaingsCard({super.key, required this.width, required this.height});

  @override
  State<StoryCampaingsCard> createState() => _StoryCampaingsCardState();
}

class _StoryCampaingsCardState extends State<StoryCampaingsCard>
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
    final theme = HomeStyle(context: context);

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: AppRadius.r12,
        boxShadow: [boxShadow(context)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppPaddings.all12,
            child: _buildTabs(theme),
          ),
          Divider(height: 1, color: theme.outlineVariant),
          SizedBox(
            height: widget.height * 0.22,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCampaigns(theme),
                _buildStories(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(HomeStyle theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: AppRadius.r12,
      ),
      child: TabBar(
        controller: _tabController,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          color: theme.primary.withOpacity(0.12),
          borderRadius: AppRadius.r12,
        ),
        labelColor: theme.primary,
        unselectedLabelColor: theme.outline,
        tabs: [
          Tab(child: Center(child: customText('Kampanyalar', context, color: theme.primary))),
          Tab(child: Center(child: customText('Hikayeler', context, color: theme.primary))),
        ],
      ),
    );
  }

  Widget _buildCampaigns(HomeStyle theme) {
    return FutureBuilder<Campaigns>(
      future: ApiService.fetchProductsCampaings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: theme.primary));
        }
        if (snapshot.hasError) {
          return Center(child: customText('Hata: ${snapshot.error}', context, color: theme.error));
        }
        final data = snapshot.data;
        final items = data?.data ?? [];
        if (items.isEmpty) {
          return Center(child: customText('Kampanya bulunamadı', context, color: theme.outline));
        }
        return ListView.separated(
          padding: AppPaddings.all12,
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: 8),
          itemBuilder: (context, index) {
            final c = items[index];
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customText(c.title, context, color: theme.primary, weight: FontWeight.bold),
                      customText(c.subtitle, context, color: theme.onSurfaceVariant),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: theme.outline),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStories(HomeStyle theme) {
    return FutureBuilder<List<dynamic>>(
      future: ApiService.fetchStories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: theme.primary));
        }
        if (snapshot.hasError) {
          return Center(child: customText('Hata: ${snapshot.error}', context, color: theme.error));
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Center(child: customText('Hikaye bulunamadı', context, color: theme.outline));
        }
        return ListView.separated(
          padding: AppPaddings.all12,
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: 8),
          itemBuilder: (context, index) {
            final s = items[index];
            return Row(
              children: [
                Expanded(
                  child: customText(s.toString(), context, color: theme.primary),
                ),
                Icon(Icons.chevron_right, color: theme.outline),
              ],
            );
          },
        );
      },
    );
  }
}


