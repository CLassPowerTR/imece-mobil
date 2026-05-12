import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/widgets/cards/campaings_card.dart';
import 'package:imecehub/core/widgets/shimmer/campaigns_shimmer.dart';
import 'package:imecehub/core/constants/app_colors.dart';
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
  late final PageController _pageController;
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.95);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || _campaigns == null || _campaigns!.data.isEmpty) return;
      final nextPage = (_currentPage + 1) % _campaigns!.data.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: campaigns.data.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final item = campaigns.data[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CampaingsCard(
                  item: item,
                  width: widget.width,
                  height: widget.height,
                ),
              );
            },
          ),
        ),
        // Page indicators
        if (campaigns.data.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                campaigns.data.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentPage == index ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: _currentPage == index
                        ? AppColors.secondary(context)
                        : AppColors.outline(context).withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
