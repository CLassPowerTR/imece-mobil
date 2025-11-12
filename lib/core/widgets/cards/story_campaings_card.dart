import 'package:flutter/material.dart';
import 'package:imecehub/api/api_config.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/widgets/shadow.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/models/stories.dart';

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

    return FutureBuilder<List<Stories>>(
      future: Future.wait([
        ApiService.fetchCampaignsStories(),
        ApiService.fetchStories(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return SizedBox.shrink();
        }
        if (snapshot.hasData) {
          final campaignsData = snapshot.data![0];
          final storiesData = snapshot.data![1];
          final campaignsItems = campaignsData.data;
          final storiesItems = storiesData.data;

          // Her iki liste de boşsa hiçbir şey gösterme
          if (campaignsItems.isEmpty && storiesItems.isEmpty) {
            return SizedBox.shrink();
          }

          // En az birinde veri varsa Container'ı göster
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
                    children: [
                      _buildCampaigns(theme, campaignsItems),
                      _buildStories(theme, storiesItems),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
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

  Widget _buildCampaigns(HomeStyle theme, List<Story> items) {
    if (items.isEmpty) {
      return Center(
        child: customText('Kampanya bulunamadı', context, color: theme.outline),
      );
    }
    return _storiesList(theme, items);
  }

  Widget _buildStories(HomeStyle theme, List<Story> items) {
    if (items.isEmpty) {
      return Center(
        child: customText('Hikaye bulunamadı', context, color: theme.outline),
      );
    }
    return _storiesList(theme, items);
  }

  Widget _storiesList(HomeStyle theme, List<Story> items) {
    return ListView.separated(
      padding: AppPaddings.all12,
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(width: 12),
      itemBuilder: (context, index) => _storyItem(theme, items[index]),
    );
  }

  Widget _storyItem(HomeStyle theme, Story story) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () =>
                _showFullScreenImage('${ApiConfig().baseUrl}${story.photo}'),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: story.isActive ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  '${ApiConfig().baseUrl}${story.photo}',
                ),
                radius: 36,
              ),
            ),
          ),
          SizedBox(height: 8),
          customText(
            story.description,
            context,
            color: theme.primary,
            weight: FontWeight.bold,
            maxLines: 1,
          ),
          customText(story.type, context, color: theme.outline, maxLines: 1),
        ],
      ),
    );
  }
}
