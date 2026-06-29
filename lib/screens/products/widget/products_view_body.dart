
part of '../products_screen.dart';

/// Ana ürün listesi body widget'ı — Web products.jsx'in mobil karşılığı.
/// Infinite scroll, filtre, sıralama, shimmer loading, empty state destekler.
class ProductsScreenBodyView extends ConsumerStatefulWidget {
  final String? initialSearch;
  final String? initialCategory;

  const ProductsScreenBodyView({
    super.key,
    this.initialSearch,
    this.initialCategory,
  });

  @override
  ConsumerState<ProductsScreenBodyView> createState() =>
      _ProductsScreenBodyViewState();
}

class _ProductsScreenBodyViewState extends ConsumerState<ProductsScreenBodyView>
    with AutomaticKeepAliveClientMixin, RouteAware {
  final ScrollController _scrollController = ScrollController();
  bool isLoggedIn = false;
  bool _isShowingSessionDialog = false;
  List<int> favoriteProductIds = [];
  Map<int, int> productIdToFavoriteId = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _checkLogin().then((_) {
      _fetchFavorites();
    });

    // Provider'ı başlat — ilk yükleme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productListProvider.notifier).initialize(
            search: widget.initialSearch,
            category: widget.initialCategory,
          );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Başka ekrandan geri dönüldüğünde favorileri yenile
    _fetchFavorites();
  }

  @override
  bool get wantKeepAlive => true;

  // ── Infinite Scroll ──
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(productListProvider.notifier).loadMore();
    }
  }

  // ── Auth & Favorites ──
  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accesToken') ?? '';
    if (mounted) {
      setState(() {
        isLoggedIn = token.isNotEmpty;
      });
    }
  }

  Future<void> _fetchFavorites() async {
    try {
      if (!isLoggedIn) {
        favoriteProductIds = [];
        productIdToFavoriteId = {};
        return;
      }
      final favorites =
          await ApiService.fetchUserFavorites(null, null, null, null);
      if (mounted) {
        setState(() {
          favoriteProductIds =
              (favorites as List).map<int>((item) => item['urun'] as int).toList();
          productIdToFavoriteId = {
            for (var item in favorites) item['urun'] as int: item['id'] as int,
          };
        });
      }
    } catch (e) {
      debugPrint('Favoriler alınırken hata: $e');
      favoriteProductIds = [];
      productIdToFavoriteId = {};
    }
  }

  Future<void> _handleFavoriteToggle(int productId) async {
    if (!isLoggedIn) {
      showTemporarySnackBar(
        context,
        'Lütfen giriş yapınız',
        type: SnackBarType.info,
      );
      return;
    }

    var user = ref.read(userProvider);
    if (user == null) {
      await ref.read(userProvider.notifier).fetchUserMe();
      user = ref.read(userProvider);
    }

    if (user == null) {
      showTemporarySnackBar(context, 'Lütfen giriş yapınız',
          type: SnackBarType.info);
      return;
    }

    final isFav = favoriteProductIds.contains(productId);

    try {
      if (isFav) {
        final favoriteId = productIdToFavoriteId[productId];
        if (favoriteId != null) {
          await ApiService.fetchUserFavorites(null, null, null, favoriteId);
          showTemporarySnackBar(context, 'Favoriden çıkarıldı',
              type: SnackBarType.success);
        }
      } else {
        await ApiService.fetchUserFavorites(null, user.id, productId, null);
        showTemporarySnackBar(context, 'Favoriye eklendi',
            type: SnackBarType.success);
      }
    } catch (e) {
      showTemporarySnackBar(context, 'Hata: $e', type: SnackBarType.error);
    } finally {
      await _fetchFavorites();
      if (mounted) setState(() {});
    }
  }

  // ── Refresh ──
  Future<void> _onRefresh() async {
    await _checkLogin();
    await _fetchFavorites();
    await ref.read(productListProvider.notifier).fetchProducts(isRefresh: true);
  }

  void _handleSessionExpiry() {
    if (!_isShowingSessionDialog) {
      _isShowingSessionDialog = true;
      setState(() {
        isLoggedIn = false;
        favoriteProductIds = [];
        productIdToFavoriteId = {};
      });
      // Optionally logout via provider if method exists, or just show dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Oturum Sona Erdi'),
          content: const Text('Oturum süreniz doldu, lütfen tekrar giriş yapın.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // Yönlendirme (auth dinleyicisi veya router tarafından da yapılabilir)
              },
              child: const Text('Giriş Sayfasına Git'),
            ),
          ],
        ),
      ).then((_) => _isShowingSessionDialog = false);
    }
  }

  // ── Filter Sheet ──
  void _openFilterSheet() {
    final state = ref.read(productListProvider);
    ProductsFilterSheet.show(
      context,
      filters: state.filters,
      dynamicFilters: state.dynamicFilters,
      onApply: (newFilters) {
        ref.read(productListProvider.notifier).updateFilters(newFilters);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Logout/login dinle
    ref.listen(userProvider, (previous, next) async {
      if (!mounted) return;
      if (next == null) {
        setState(() {
          isLoggedIn = false;
          favoriteProductIds = [];
          productIdToFavoriteId = {};
        });
        return;
      }
      await _checkLogin();
      await _fetchFavorites();
    });

    // 401 Session Expiry dinle
    ref.listen<ProductListState>(productListProvider, (previous, next) {
      if (!mounted) return;
      if (next.errorMessage != null && next.errorMessage!.contains('401')) {
        _handleSessionExpiry();
      }
    });

    final state = ref.watch(productListProvider);

    return Semantics(
      label: "Ürün listeleme ekranı",
      child: RefreshIndicator(
        color: AppColors.primary(context),
        backgroundColor: Colors.white,
        onRefresh: _onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── Sort Bar ──
          SliverToBoxAdapter(
            child: ProductsSortBar(
              total: state.totalItems,
              sort: state.filters.sort,
              onSortChange: (sort) {
                ref.read(productListProvider.notifier).updateSort(sort);
              },
              onFilterOpen: _openFilterSheet,
            ),
          ),

          // ── Active Filters ──
          if (state.filters.hasActiveFilters)
            SliverToBoxAdapter(
              child: ProductsActiveFilters(
                filters: state.filters,
                onFiltersChanged: (newFilters) {
                  ref
                      .read(productListProvider.notifier)
                      .updateFilters(newFilters);
                },
              ),
            ),

          // ── Content ──
          if (state.isLoading && state.products.isEmpty)
            // İlk yükleme — shimmer skeleton
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              sliver: ProductsSkeletonGrid(itemCount: 6),
            )
          else if (state.errorMessage != null && state.products.isEmpty)
            // Hata Durumu
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildErrorState(context, state),
            )
          else if (state.products.isEmpty && !state.isLoading)
            // Boş durum
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(context, state),
            )
          else ...[
            // Ürün grid'i
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.55,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = state.products[index];
                    final productId = product.urunId ?? 0;
                    final isFav = favoriteProductIds.contains(productId);

                    return ProductsCard3(
                      data: product,
                      isFavorite: isFav,
                      onFavoriteToggle: (id) => _handleFavoriteToggle(id),
                    );
                  },
                  childCount: state.products.length,
                ),
              ),
            ),

            // Daha fazla yükleniyor — shimmer
            if (state.isLoadingMore)
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.58,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const ProductsSkeletonCard(),
                    childCount: 4,
                  ),
                ),
              ),

            // Tüm sonuçlar yüklendi mesajı
            if (!state.hasMore && state.products.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'Tüm ürünler gösterildi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              ),
          ],

          // Alt boşluk
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),)
    );
  }

  // ── Error State ──
  Widget _buildErrorState(BuildContext context, ProductListState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bir Hata Oluştu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? 'Ürünler yüklenirken hata oluştu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: "Tekrar dene",
              child: GestureDetector(
                onTap: () {
                  ref.read(productListProvider.notifier).fetchProducts(isRefresh: true);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary(context),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary(context).withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Tekrar Dene',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ──
  Widget _buildEmptyState(BuildContext context, ProductListState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 40,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sonuç Bulunamadı',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Filtrelerinizi değiştirerek tekrar deneyebilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: "Tüm filtreleri temizle",
              child: GestureDetector(
                onTap: () {
                  ref.read(productListProvider.notifier).resetFilters();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary(context),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary(context).withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Tüm Filtreleri Temizle',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
