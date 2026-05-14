import 'dart:async';
import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/core/widgets/cards/productsCard2.dart'; // This is actually ImeceCard

class NewImeceCampaigns extends StatefulWidget {
  final double width;
  final double height;

  const NewImeceCampaigns({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<NewImeceCampaigns> createState() => _NewImeceCampaignsState();
}

class _NewImeceCampaignsState extends State<NewImeceCampaigns> {
  List<Map<String, dynamic>> _campaigns = [];
  bool _isLoading = true;
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fetchCampaigns();
  }

  Future<void> _fetchCampaigns() async {
    try {
      final resData = await ApiService.fetchImeceCampaigns();
      List<Map<String, dynamic>> allVariantCards = [];

      for (var campaign in resData) {
        if (campaign['variants'] != null && (campaign['variants'] as List).isNotEmpty) {
          for (var variant in campaign['variants']) {
            final vName = variant['name'] ?? '';
            final cTitle = (campaign['title'] ?? '').toString().replaceAll(RegExp(r'^imece\s+', caseSensitive: false), '');
            final finalTitle = vName.isNotEmpty ? vName : cTitle;

            allVariantCards.add({
              ...campaign,
              'display_title': finalTitle,
              'display_max_price': variant['max_price'],
              'display_current_price': variant['current_price'],
              'display_min_price': variant['min_price'],
              'display_image': variant['image'] ?? campaign['image'],
              'target_variant_id': variant['id']
            });
          }
        } else {
          allVariantCards.add({
            ...campaign,
            'display_title': (campaign['title'] ?? '').toString().replaceAll(RegExp(r'^imece\s+', caseSensitive: false), ''),
            'display_max_price': campaign['max_price'],
            'display_current_price': campaign['min_price'] ?? campaign['current_price'], // React falls back to min_price
            'display_min_price': campaign['min_price'],
            'display_image': campaign['image'],
            'target_variant_id': null
          });
        }
      }

      if (mounted) {
        setState(() {
          _campaigns = allVariantCards.take(15).toList();
          _isLoading = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startAutoScroll();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        final itemWidth = widget.width * 0.45 + 12;

        if (currentScroll >= maxScroll - 10) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            currentScroll + itemWidth,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: widget.height * 0.4,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_campaigns.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "🔥 POPÜLER ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontStyle: FontStyle.italic,
                            letterSpacing: -0.5,
                          ),
                          children: [
                            TextSpan(
                              text: "İMECELER",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Kolektif alım gücüyle en iyi fiyata ulaşın",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/imece');
                  },
                  child: Row(
                    children: [
                      Text(
                        "TÜMÜNÜ GÖR",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.orange.shade600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 14, color: Colors.orange.shade600),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Slider
          SizedBox(
            height: widget.height * 0.45,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _campaigns.length,
              clipBehavior: Clip.none,
              itemBuilder: (context, index) {
                return Container(
                  width: widget.width * 0.5,
                  margin: EdgeInsets.only(right: 12, left: index == 0 ? 4 : 0),
                  child: ImeceCard(
                    campaign: _campaigns[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
