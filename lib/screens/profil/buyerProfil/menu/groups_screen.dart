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
    final themeData = HomeStyle(context: context);

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
            color: const Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            fontFamily: themeData.bodyLarge.fontFamily,
          ),
        ),
      ),
      body: _buildBody(groupsState),
    );
  }

  Widget _buildBody(GroupsState state) {
    if (state.isLoading) {
      return Center(child: buildLoadingBar(context));
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text('Hata oluştu: ${state.error}', textAlign: TextAlign.center),
              TextButton(
                onPressed: () => ref.read(groupsProvider.notifier).fetchJoinedGroups(),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.joinedGroups.isEmpty) {
      return const Center(
        child: Text(
          'Herhangi bir gruba dahil değilsiniz.',
          style: TextStyle(color: Color(0xFF86868B), fontSize: 15),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: state.joinedGroups.length,
      itemBuilder: (context, index) {
        return _buildGroupCard(state.joinedGroups[index]);
      },
    );
  }

  Widget _buildGroupCard(GroupInfo group) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: const Color(0xFF007AFF).withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1D1F),
                          letterSpacing: -0.4,
                        ),
                      ),
                      if (group.productName != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            group.productName!,
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color(0xFF007AFF).withOpacity(0.8),
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
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _buildDataChip(Icons.people_alt_rounded, '${group.usersCount} / ${group.capacity} Kişi'),
                _buildDataChip(Icons.payments_rounded, '₺${group.currentPrice.toStringAsFixed(2)}'),
                if (group.groupCapacityLeft != null)
                  _buildDataChip(Icons.event_available_rounded, '${group.groupCapacityLeft} Kontenjan Kaldı'),
              ],
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
        color: const Color(0xFF007AFF).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007AFF).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.group_work_rounded,
        color: Color(0xFF007AFF),
        size: 22,
      ),
    );
  }

  Widget _buildActionMenu(GroupInfo group) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF86868B)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      offset: const Offset(0, 40),
      onSelected: (value) async {
        if (value == 'leave') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Gruptan Ayrıl'),
              content: const Text('Bu gruptan ayrılmak istediğinizden emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Ayrıl', style: TextStyle(color: Colors.redAccent)),
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
              Icon(Icons.info_outline_rounded, size: 20, color: Colors.blue[600]),
              const SizedBox(width: 12),
              const Text('Detaylar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        const PopupMenuItem(
          value: 'leave',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 20, color: Colors.redAccent),
              const SizedBox(width: 12),
              Text('Gruptan Ayrıl', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.redAccent)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8ED), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF86868B)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF424245),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
