import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/api/api_config.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/core/variables/url.dart';
import 'package:imecehub/models/stories.dart';
import 'package:imecehub/providers/stories_campaings_provider.dart';

/// Instagram tarzı yatay hikaye bubbles bar
/// Header altında konumlandırılır ve tüm kampanya hikayelerini gösterir
class CampaignStoriesBar extends ConsumerStatefulWidget {
  const CampaignStoriesBar({super.key});

  @override
  ConsumerState<CampaignStoriesBar> createState() => _CampaignStoriesBarState();
}

class _CampaignStoriesBarState extends ConsumerState<CampaignStoriesBar> {
  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(storiesCampaignsProvider);

    return dataAsync.when(
      loading: () => _buildShimmer(),
      error: (_, __) => const SizedBox.shrink(),
      data: (data) {
        // Kampanya hikayeleri önce, ardından normal hikayeler
        final allStories = [...data.campaigns, ...data.stories];
        if (allStories.isEmpty) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            border: Border(
              bottom: BorderSide(
                color: AppColors.outline(context).withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: allStories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) => _StoryBubble(
                story: allStories[index],
                allStories: allStories,
                index: index,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, __) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 50,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryBubble extends ConsumerWidget {
  final Story story;
  final List<Story> allStories;
  final int index;

  const _StoryBubble({
    required this.story,
    required this.allStories,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewedStories = ref.watch(viewedStoriesProvider);
    final isViewed = viewedStories.contains(story.id);
    final photoUrl = _buildImageUrl(story.photo.isNotEmpty ? story.photo : story.banner);

    return GestureDetector(
      onTap: () => _openStoryViewer(context, ref),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gradient ring
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isViewed
                    ? null
                    : const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFFFF6B35),
                          Color(0xFFFF8E53),
                          Color(0xFFE91E63),
                        ],
                      ),
                border: isViewed
                    ? Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      )
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface(context),
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(photoUrl),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              story.title.isNotEmpty ? story.title : 'KAMPANYA',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primary(context).withOpacity(0.7),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openStoryViewer(BuildContext context, WidgetRef ref) {
    // Mark as viewed
    ref
        .read(viewedStoriesProvider.notifier)
        .update((state) => {...state, story.id});

    showGeneralDialog(
      context: context,
      barrierColor: Colors.black,
      barrierDismissible: false,
      pageBuilder: (context, _, __) {
        return _FullScreenStoryViewer(
          stories: allStories,
          initialIndex: index,
          onStoryViewed: (storyId) {
            ref
                .read(viewedStoriesProvider.notifier)
                .update((state) => {...state, storyId});
          },
        );
      },
    );
  }

  String _buildImageUrl(String rawPath) {
    if (rawPath.isEmpty) return NotFound.defaultBannerImageUrl;
    final uri = Uri.tryParse(rawPath);
    if (uri != null && uri.hasScheme && uri.host.isNotEmpty) return rawPath;
    final base = ApiConfig().baseUrl;
    if (base.isEmpty) return NotFound.defaultBannerImageUrl;
    final normalizedBase =
        base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final normalizedPath = rawPath.startsWith('/') ? rawPath : '/$rawPath';
    return '$normalizedBase$normalizedPath';
  }
}

/// Fullscreen story viewer with progress bars and swipe navigation
class _FullScreenStoryViewer extends StatefulWidget {
  final List<Story> stories;
  final int initialIndex;
  final Function(int) onStoryViewed;

  const _FullScreenStoryViewer({
    required this.stories,
    required this.initialIndex,
    required this.onStoryViewed,
  });

  @override
  State<_FullScreenStoryViewer> createState() => _FullScreenStoryViewerState();
}

class _FullScreenStoryViewerState extends State<_FullScreenStoryViewer> {
  late int _currentIndex;
  Timer? _timer;
  double _progress = 0.0;
  static const int _durationSeconds = 6;

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

    _timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!mounted) return;
      setState(() {
        _progress += 1.0 / (_durationSeconds * (1000 / 60));
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
    if (rawPath.isEmpty) return NotFound.defaultBannerImageUrl;
    final uri = Uri.tryParse(rawPath);
    if (uri != null && uri.hasScheme && uri.host.isNotEmpty) return rawPath;
    final base = ApiConfig().baseUrl;
    final normalizedBase =
        base.endsWith('/') ? base.substring(0, base.length - 1) : base;
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
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
              ),
            ),
          ),

          // Progress Bars
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 10,
            right: 10,
            child: Row(
              children: widget.stories.asMap().entries.map((entry) {
                int idx = entry.key;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: idx < _currentIndex
                            ? 1.0
                            : (idx == _currentIndex ? _progress : 0.0),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        minHeight: 2.5,
                      ),
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

          // Top bar — story info + close
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 16,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(photoUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        story.title.isNotEmpty ? story.title : 'Kampanya',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (story.type.isNotEmpty)
                        Text(
                          story.type,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Bottom gradient + description
          if (story.description.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                  top: 60,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black87,
                      Colors.black54,
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (story.subtitle.isNotEmpty)
                      Text(
                        story.subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      story.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
