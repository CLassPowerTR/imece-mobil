import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/widgets/cards/campaings_card.dart';
import 'package:imecehub/core/widgets/shimmer/campaigns_shimmer.dart';
import 'package:imecehub/models/campaigns.dart';
import 'package:imecehub/providers/products_provider.dart';

class CampaignsItemsCard extends ConsumerStatefulWidget {
  final double width;
  final double height;

  const CampaignsItemsCard({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  ConsumerState<CampaignsItemsCard> createState() =>
      _CampaignsItemsCardState();
}

class _CampaignsItemsCardState extends ConsumerState<CampaignsItemsCard> {
  Campaigns? _campaigns;

  @override
  Widget build(BuildContext context) {
    // Provider'ı watch ile izle
    final campaignsAsync = ref.watch(campaignsProvider);

    // Listen ile güncellemeleri dinle
    ref.listen<AsyncValue<Campaigns>>(
      campaignsProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (mounted) {
              setState(() {
                _campaigns = data;
              });
            }
          },
          loading: () {
            if (mounted) {
              setState(() {
                _campaigns = null;
              });
            }
          },
          error: (error, stackTrace) {
            if (mounted) {
              setState(() {
                _campaigns = null;
              });
            }
          },
        );
      },
    );

    // Önce listen ile güncellenmiş veriyi kontrol et, yoksa watch'tan al
    final campaigns = _campaigns ??
        (campaignsAsync.hasValue ? campaignsAsync.value : null);

    if (campaignsAsync.isLoading || campaigns == null) {
      return SizedBox(
        height: 200,
        child: CampaignsShimmer(height: 200),
      );
    }

    if (campaignsAsync.hasError) {
      return Center(
        child: Text("Hata oluştu: ${campaignsAsync.error}"),
      );
    }

    if (campaigns.data.isEmpty) {
      return SizedBox.shrink();
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: campaigns.data.length,
        itemBuilder: (context, index) {
          final item = campaigns.data[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == campaigns.data.length - 1 ? 0 : 8,
            ),
            child: CampaingsCard(
              item: item,
              width: widget.width,
              height: widget.height,
            ),
          );
        },
      ),
    );
  }
}

