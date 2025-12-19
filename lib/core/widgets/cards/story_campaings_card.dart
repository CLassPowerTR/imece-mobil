import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imecehub/api/api_config.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/constants/app_paddings.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/core/widgets/container.dart';
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

  Future<void> _showFullScreenStories(List<Story> stories, int initialIndex) async {
    await showGeneralDialog(
      context: context,
      barrierColor: Colors.black,
      barrierDismissible: false,
      pageBuilder: (context, anim1, anim2) {
        return _StoryViewer(
          stories: stories,
          initialIndex: initialIndex,
          onStoryViewed: (storyId) {
            ref.read(viewedStoriesProvider.notifier).update((state) => {...state, storyId});
          },
        );
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

        return container(
          context,
          margin: AppPaddings.h6,
          color: const Color(0xFFF9FAFB), // Surface'in hafif gri tonu
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.surface(context), // Dış çerçeve surface rengi
            width: 4,
          ),
          boxShadowColor: Colors.black.withOpacity(0.2),
          blurRadius: 6,
          //padding: const EdgeInsets.all(12),
          //margin: widget.margin ?? AppPaddings.h10,
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
    return container(
      context,
      color: const Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(10),
      //boxShadowColor: Colors.black.withOpacity(0.02),
      margin: EdgeInsets.all(6),
      blurRadius: 4,
      border: Border.all(color: AppColors.surface(context), width: 4),
      offset: const Offset(0, 2),
      //padding: const EdgeInsets.all(4),
      child: TabBar(
        controller: _tabController,
        labelPadding: EdgeInsets.zero,
        indicatorPadding: const EdgeInsets.all(2),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              AppColors.secondary(context).withOpacity(0.1),
              AppColors.secondary(context).withOpacity(0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.surface(context), width: 2),
        ),
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF1F2937),
        unselectedLabelColor: const Color(0xFF6B7280),
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
      padding: EdgeInsets.zero, // Fazlalık paddingler kaldırıldı
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (context, _) => const SizedBox(width: 12),
      itemBuilder: (context, index) => _storyItem(theme, items, index),
    );
  }

  Widget _storyItem(HomeStyle theme, List<Story> stories, int index) {
    final story = stories[index];
    final viewedStories = ref.watch(viewedStoriesProvider);
    final isViewed = viewedStories.contains(story.id);
    
    String imageUrl = story.photo.isEmpty ? story.banner : story.photo;
    final photoUrl = _buildImageUrl('${ApiConfig().baseUrl}$imageUrl');
    return SizedBox(
      width: 85, // Biraz daha genişleterek ferahlık sağladık
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start, // Üstten hizalama sabitlendi
        children: [
          GestureDetector(
            onTap: () => _showFullScreenStories(stories, index),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: !isViewed
                      ? const Color(0xFF4ECDC4).withOpacity(0.8) // Yeni/Aktif: Turkuaz
                      : const Color(0xFF9CA3AF).withOpacity(0.4), // İzlenmiş: Gri
                  width: 2.5,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                radius: 32,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            story.description,
            textAlign: TextAlign.center,
            maxLines: 2, // 2 satır desteği
            //minLines: 2, // Yükseklik sabitliği için 2 satır yer kaplasın
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
              height: 1.2,
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

class _StoryViewer extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;
  final Function(int) onStoryViewed;

  const _StoryViewer({
    required this.stories,
    required this.initialIndex,
    required this.onStoryViewed,
  });

  @override
  State<_StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<_StoryViewer> {
  late int _currentIndex;
  Timer? _timer;
  double _progress = 0.0;
  static const int _durationSeconds = 10;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _progress = 0.0;
    widget.onStoryViewed(widget.stories[_currentIndex].id);
    
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 0.1 / _durationSeconds;
        if (_progress >= 1.0) {
          _nextStory();
        }
      });
    });
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
        _startTimer();
      });
    } else {
      _timer?.cancel();
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _startTimer();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
    final normalizedBase = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final normalizedPath = rawPath.startsWith('/') ? rawPath : '/$rawPath';
    return '$normalizedBase$normalizedPath';
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];
    String imageUrl = story.photo.isEmpty ? story.banner : story.photo;
    final photoUrl = _buildImageUrl('${ApiConfig().baseUrl}$imageUrl');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Center(
            child: InteractiveViewer(
              child: Image.network(
                photoUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                },
              ),
            ),
          ),

          // Progress Bars
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Row(
              children: widget.stories.asMap().entries.map((entry) {
                int idx = entry.key;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: LinearProgressIndicator(
                      value: idx < _currentIndex
                          ? 1.0
                          : (idx == _currentIndex ? _progress : 0.0),
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 2,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Navigation Taps
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _previousStory,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.expand(),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: _nextStory,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),

          // Close Button and Info
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(photoUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        story.title.isNotEmpty ? story.title : "Kampanya",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        story.type,
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

