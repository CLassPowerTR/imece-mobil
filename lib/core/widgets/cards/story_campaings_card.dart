import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/api/api_config.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/constants/app_radius.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/core/widgets/shadow.dart';
import 'package:imecehub/core/widgets/shimmer/campaigns_stories_shimmer.dart'
    as shimmer;
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/models/stories.dart';
import 'package:imecehub/providers/stories_campaings_provider.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';

class StoryCampaingsCard extends ConsumerStatefulWidget {
  final double width;
  final double height;
  final int? sellerId;
  final EdgeInsetsGeometry? margin;
  const StoryCampaingsCard({
    super.key,
    required this.width,
    required this.height,
    this.sellerId,
    this.margin,
  });

  @override
  ConsumerState<StoryCampaingsCard> createState() => _StoryCampaingsCardState();
}

class _StoryCampaingsCardState extends ConsumerState<StoryCampaingsCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  Future<void> _showFullScreenImage(String url) async {
    final navigator = Navigator.of(context);
    await showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      barrierDismissible: true,
      barrierLabel: 'story-image',
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.black),
            Center(
              child: InteractiveViewer(
                child: Image.network(url, fit: BoxFit.cover),
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
    ).timeout(
      const Duration(minutes: 5),
      onTimeout: () {
        if (navigator.canPop()) {
          navigator.pop();
        }
        return;
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HomeStyle(context: context);
    final dataAsync = widget.sellerId == null
        ? ref.watch(storiesCampaignsProvider)
        : ref.watch(storiesCampaignsBySellerProvider(widget.sellerId!));

    return dataAsync.when(
      loading: () =>
          shimmer.CampaignsStoriesShimmer(height: widget.height * 0.22),
      error: (error, _) {
        debugPrint('$error');
        return Text(error.toString());
      },
      data: (data) {
        final campaignsItems = data.campaigns;
        final storiesItems = data.stories;

        if (!data.hasContent) {
          return SizedBox.shrink();
        }

        return Container(
          padding: AppPaddings.all4,
          margin: widget.margin ?? AppPaddings.h10,
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
      separatorBuilder: (context, _) => SizedBox(width: 12),
      itemBuilder: (context, index) => _storyItem(theme, items[index]),
    );
  }

  Widget _storyItem(HomeStyle theme, Story story) {
    String imageUrl = story.photo.isEmpty ? story.banner : story.photo;
    final photoUrl = _buildImageUrl('${ApiConfig().baseUrl}$imageUrl');
    return SizedBox(
      width: 100,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _showFullScreenImage(photoUrl),
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
                backgroundImage: NetworkImage(photoUrl),
                radius: 36,
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: customText(
              story.description,
              context,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              color: theme.primary,
              weight: FontWeight.bold,
              maxLines: 2,
            ),
          ),
          Expanded(
            child: customText(
              story.type,
              context,
              color: theme.outline,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _buildImageUrl(String rawPath) {
    if (rawPath.isEmpty) {
      return NotFound.defaultBannerImageUrl;
    }
    final uri = Uri.tryParse(rawPath);
    if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
      return rawPath;
    }
    final base = ApiConfig().baseUrl;
    if (base.isEmpty) {
      return NotFound.defaultBannerImageUrl;
    }
    final normalizedBase = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;
    final normalizedPath = rawPath.startsWith('/') ? rawPath : '/$rawPath';
    return '$normalizedBase$normalizedPath';
  }
}
