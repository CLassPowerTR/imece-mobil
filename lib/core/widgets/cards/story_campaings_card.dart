import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imecehub/api/api_config.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/variables/url.dart';
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
          padding: const EdgeInsets.all(12),
          margin: widget.margin ?? AppPaddings.h10,
          decoration: BoxDecoration(
            color: AppColors.surface(context), // bg-white
            borderRadius: BorderRadius.circular(24), // rounded-3xl
            border: Border.all(
              color: const Color(0xFFF3F4F6),
              width: 1,
            ), // border-gray-100
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTabs(theme),
              const SizedBox(height: 12),
              SizedBox(
                height: widget.height * 0.18,
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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6).withOpacity(0.8), // bg-gray-100/80
        borderRadius: BorderRadius.circular(16), // rounded-2xl
      ),
      child: TabBar(
        controller: _tabController,
        labelPadding: EdgeInsets.zero,
        indicatorPadding: const EdgeInsets.all(2), // Adds "border" effect around indicator
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondary(context).withOpacity(0.1), // Lightest
              AppColors.secondary(context), // Primary color
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary(context).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1, // Glowing effect
              offset: const Offset(0, 0),
            ),
          ],
        ),
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF1F2937), // text-gray-900
        unselectedLabelColor: const Color(0xFF6B7280), // text-gray-500
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Kampanyalar'),
          Tab(text: 'Hikayeler'),
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
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (context, _) => const SizedBox(width: 12),
      itemBuilder: (context, index) => _storyItem(theme, items[index]),
    );
  }

  Widget _storyItem(HomeStyle theme, Story story) {
    String imageUrl = story.photo.isEmpty ? story.banner : story.photo;
    final photoUrl = _buildImageUrl('${ApiConfig().baseUrl}$imageUrl');
    return SizedBox(
      width: 80, // Slightly smaller for better spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _showFullScreenImage(photoUrl),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: story.isActive
                      ? const Color(0xFF4ECDC4).withOpacity(0.8) // New/Active: Turquoise
                      : Colors.grey.withOpacity(0.4), // Viewed: Gray
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                radius: 32,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            story.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
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
