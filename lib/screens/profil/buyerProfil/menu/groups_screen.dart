
part of '../buyer_profil_screen.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends ConsumerState<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(groupsProvider.notifier).fetchJoinedGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupsState = ref.watch(groupsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 100,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: TurnBackTextIcon(),
        ),
        title: Text(
          "Gruplarım",
          style: TextStyle(
            color: AppColors.onSurface(context),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: _buildBody(groupsState),
    );
  }

  Widget _buildBody(GroupsState state) {
    if (state.isLoading) {
      return _buildGroupSkeleton();
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: AppColors.error(context).withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Bir hata oluştu',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${state.error}',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant(context),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => ref.read(groupsProvider.notifier).fetchJoinedGroups(),
                icon: const Icon(Icons.refresh),
                label: Text(
                  'Tekrar Dene',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                  foregroundColor: AppColors.onPrimary(context),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.joinedGroups.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.groups_outlined,
                size: 72,
                color: AppColors.primary(context).withOpacity(0.25),
              ),
              const SizedBox(height: 16),
              Text(
                'Henüz Bir Gruba Dahil Değilsiniz',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'İmece gruplarına katılarak toplu alışverişin avantajlarından yararlanın.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant(context),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                icon: const Icon(Icons.explore_outlined),
                label: Text(
                  'Ürünleri Keşfet',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                  foregroundColor: AppColors.onPrimary(context),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary(context),
      backgroundColor: AppColors.surface(context),
      onRefresh: () async {
        ref.read(groupsProvider.notifier).fetchJoinedGroups();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.joinedGroups.length,
        itemBuilder: (context, index) {
          return _buildGroupCard(state.joinedGroups[index]);
        },
      ),
    );
  }

  Widget _buildGroupSkeleton( ) {
    return Shimmer.fromColors(
      baseColor: AppColors.outline(context).withOpacity(0.12),
      highlightColor: AppColors.surface(context),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: 3,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard(GroupInfo group) {
    final progress = group.capacity > 0
        ? group.usersCount / group.capacity
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: AppColors.outline(context).withOpacity(0.15),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon + Name + Menu
            Row(
              children: [
                _buildHeaderIcon(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.groupName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface(context),
                          letterSpacing: -0.4,
                        ),
                      ),
                      if (group.productName != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            group.productName!,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.primary(context).withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                _buildActionMenu(group),
              ],
            ),

            const SizedBox(height: 16),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${group.usersCount} / ${group.capacity} Kişi',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface(context),
                      ),
                    ),
                    Text(
                      '%${(progress * 100).toInt()}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor:  AppColors.primary(context).withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1.0
                          ? AppColors.succesful(context)
                          : AppColors.primary(context),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Info chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildDataChip(
                
                  Icons.payments_rounded,
                  '₺${group.currentPrice.toStringAsFixed(2)}',
                ),
                if (group.groupCapacityLeft != null)
                  _buildDataChip(
                   
                    Icons.event_available_rounded,
                    '${group.groupCapacityLeft} Kontenjan',
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // Paylaşım butonları
            Row(
              children: [
                Expanded(
                  child: _buildShareButton(
              
                    icon: Icons.share_outlined,
                    label: 'Paylaş',
                    color: AppColors.primary(context),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // TODO: Paylaşım fonksiyonu
                      showTemporarySnackBar(
                        context,
                        'Paylaşım linki kopyalandı!',
                        type: SnackBarType.success,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildShareButton(
           
                    icon: Icons.copy_outlined,
                    label: 'Link Kopyala',
                    color: AppColors.secondary(context),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Clipboard.setData(ClipboardData(
                        text: 'https://imecehub.com/group/${group.groupId}',
                      ));
                      showTemporarySnackBar(
                        context,
                        'Referans linki kopyalandı!',
                        type: SnackBarType.success,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton(
     {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary(context).withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.group_work_rounded,
        color: AppColors.primary(context),
        size: 22,
      ),
    );
  }

  Widget _buildActionMenu(GroupInfo group) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_horiz_rounded, color: AppColors.onSurfaceVariant(context)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      offset: const Offset(0, 40),
      onSelected: (value) async {
        if (value == 'leave') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Gruptan Ayrıl',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              content: Text(
                'Bu gruptan ayrılmak istediğinizden emin misiniz?',
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'İptal',
                    style: GoogleFonts.poppins(color: AppColors.onSurfaceVariant(context)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'Ayrıl',
                    style: GoogleFonts.poppins(color: AppColors.error(context)),
                  ),
                ),
              ],
            ),
          );

          if (confirm == true) {
            try {
              await ref.read(groupsProvider.notifier).leaveGroup(groupId: group.groupId);
              showTemporarySnackBar(context, 'Gruptan ayrıldınız.', type: SnackBarType.success);
            } catch (e) {
              showTemporarySnackBar(context, 'Hata: $e', type: SnackBarType.error);
            }
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'details',
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 20, color: AppColors.primary(context)),
              const SizedBox(width: 12),
              Text(
                'Detaylar',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem(
          value: 'leave',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 20, color: AppColors.error(context)),
              const SizedBox(width: 12),
              Text(
                'Gruptan Ayrıl',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color:  AppColors.error(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer(context).withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.outline(context).withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.onSurfaceVariant(context)),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface(context),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
