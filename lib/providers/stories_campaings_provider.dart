import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/models/stories.dart';
import 'package:imecehub/services/api_service.dart';

class StoriesCampaignsState {
  final List<Story> campaigns;
  final List<Story> stories;

  const StoriesCampaignsState({required this.campaigns, required this.stories});

  bool get hasContent => campaigns.isNotEmpty || stories.isNotEmpty;

  StoriesCampaignsState filteredByPublisher(int sellerId) {
    return StoriesCampaignsState(
      campaigns: campaigns
          .where((story) => story.publishedBy == sellerId)
          .toList(),
      stories: stories.where((story) => story.publishedBy == sellerId).toList(),
    );
  }
}

final storiesCampaignsProvider = FutureProvider<StoriesCampaignsState>((
  ref,
) async {
  final results = await Future.wait([
    ApiService.fetchCampaignsStories(),
    ApiService.fetchStories(),
  ]);
  return StoriesCampaignsState(
    campaigns: results[0].data,
    stories: results[1].data,
  );
});

final storiesCampaignsBySellerProvider =
    FutureProvider.family<StoriesCampaignsState, int>((ref, sellerId) async {
      final data = await ref.watch(storiesCampaignsProvider.future);
      return data.filteredByPublisher(sellerId);
    });

/// Uygulama açılışından kapanışına kadar izlenen hikayelerin ID'lerini tutan provider.
final viewedStoriesProvider = StateProvider<Set<int>>((ref) => {});
