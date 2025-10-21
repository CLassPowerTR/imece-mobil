import 'package:flutter/material.dart';
import 'package:imecehub/api/api_config.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/widgets/shadow.dart';
import 'package:imecehub/core/widgets/shimmer/campaigns_stories_shimmer.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/models/stories.dart';
import 'package:shimmer/shimmer.dart';

class StoryCampaingsCard extends StatefulWidget {
  final double width;
  final double height;
  const StoryCampaingsCard({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<StoryCampaingsCard> createState() => _StoryCampaingsCardState();
}

class _StoryCampaingsCardState extends State<StoryCampaingsCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _showFullScreenImage(String url) {
    if (_dialogOpen) return;
    _dialogOpen = true;
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      barrierDismissible: false,
      barrierLabel: 'story-image',
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.black),
            Center(
              child: InteractiveViewer(
                child: Image.network(url, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      // Diyalog kapandıktan sonra state'i sıfırla
      if (mounted) {
        setState(() {
          _dialogOpen = false;
        });
      } else {
        _dialogOpen = false;
      }
    });
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
      padding: AppPaddings.all4,
      margin: AppPaddings.h10,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: AppRadius.r12,
        boxShadow: [boxShadow(context)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: AppPaddings.all12, child: _buildTabs(theme)),
          SizedBox(
            height: widget.height * 0.22,
            child: TabBarView(
              controller: _tabController,
              children: [_buildCampaigns(theme), _buildStories(theme)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(HomeStyle theme) {
    return Container(
      padding: AppPaddings.all4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: AppRadius.r8,
        boxShadow: [boxShadow(context)],
      ),
      child: TabBar(
        controller: _tabController,
        labelPadding: EdgeInsets.zero,
        indicator: BoxDecoration(
          color: theme.surface,
          borderRadius: AppRadius.r12,
        ),
        dividerColor: Colors.transparent,
        labelColor: theme.secondary,
        labelStyle: TextStyle(
          fontSize: theme.bodyMedium.fontSize,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelColor: theme.primary,
        tabs: [
          Tab(child: Center(child: Text('Kampanyalar'))),
          Tab(child: Center(child: Text('Hikayeler'))),
        ],
      ),
    );
  }

  Widget _buildCampaigns(HomeStyle theme) {
    return FutureBuilder<Stories>(
      future: ApiService.fetchCampaignsStories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CampaignsStoriesShimmer();
        }
        if (snapshot.hasError) {
          return Center(
            child: customText(
              'Hata: ${snapshot.error}',
              context,
              color: theme.error,
            ),
          );
        }
        final data = snapshot.data;
        final items = data?.data ?? [];
        if (items.isEmpty) {
          return Center(
            child: customText(
              'Kampanya bulunamadı',
              context,
              color: theme.outline,
            ),
          );
        }
        return ListView.separated(
          padding: AppPaddings.all12,
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(width: 12),
          itemBuilder: (context, index) {
            final Story c = items[index];
            return SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _showFullScreenImage(
                      '${ApiConfig().baseUrl}${c.photo}',
                    ),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: c.isActive ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          '${ApiConfig().baseUrl}${c.photo}',
                        ),
                        radius: 36,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  customText(
                    c.description,
                    context,
                    color: theme.primary,
                    weight: FontWeight.bold,
                    maxLines: 1,
                  ),
                  customText(
                    c.type,
                    context,
                    color: theme.outline,
                    maxLines: 1,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStories(HomeStyle theme) {
    return FutureBuilder<Stories>(
      future: ApiService.fetchStories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CampaignsStoriesShimmer(subtitle: 'Hikayeler');
        }
        if (snapshot.hasError) {
          return Center(
            child: customText(
              'Hata: ${snapshot.error}',
              context,
              color: theme.error,
            ),
          );
        }
        final data = snapshot.data;
        final items = data?.data ?? [];
        if (items.isEmpty) {
          return Center(
            child: customText(
              'Hikaye bulunamadı',
              context,
              color: theme.outline,
            ),
          );
        }
        return ListView.separated(
          padding: AppPaddings.all12,
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(width: 12),
          itemBuilder: (context, index) {
            final Story s = items[index];
            return SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _showFullScreenImage(
                      '${ApiConfig().baseUrl}${s.photo}',
                    ),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: s.isActive ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          '${ApiConfig().baseUrl}${s.photo}',
                        ),
                        radius: 36,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  customText(
                    s.description,
                    context,
                    color: theme.primary,
                    weight: FontWeight.bold,
                    maxLines: 1,
                  ),
                  customText(
                    s.type,
                    context,
                    color: theme.outline,
                    maxLines: 1,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
