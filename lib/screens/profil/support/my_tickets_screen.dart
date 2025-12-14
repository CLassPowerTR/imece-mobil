// lib/screens/profil/support/my_tickets_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/supports_provider.dart';
import 'widgets/neumorphic_container.dart';

class MyTicketsScreen extends ConsumerStatefulWidget {
  const MyTicketsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends ConsumerState<MyTicketsScreen> {
  String? _selectedFilter;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _searchQuery = '';
  String _sortBy = 'date_desc'; // date_desc, date_asc, status

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  bool _hasMoreData = true;

  List<Map<String, dynamic>> _allTickets = [];
  List<Map<String, dynamic>> _filteredTickets = [];

  final List<Map<String, String>> _filters = [
    {'value': '', 'label': 'Tümü'},
    {'value': 'pending', 'label': 'Beklemede'},
    {'value': 'in_progress', 'label': 'İşlemde'},
    {'value': 'resolved', 'label': 'Çözüldü'},
    {'value': 'closed', 'label': 'Kapatıldı'},
  ];

  @override
  void initState() {
    super.initState();
    // Widget build cycle sonrasında provider'ı modify et
    Future.microtask(() => _loadTickets());
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreTickets();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFiltersAndSort();
    });
  }

  Future<void> _loadTickets({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _allTickets.clear();
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(supportsProvider.notifier)
          .fetchTickets(
            status: _selectedFilter?.isEmpty ?? true ? null : _selectedFilter,
          );

      final supportsState = ref.read(supportsProvider);
      _allTickets = List<Map<String, dynamic>>.from(
        supportsState.tickets.map((e) => Map<String, dynamic>.from(e)),
      );

      _applyFiltersAndSort();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadMoreTickets() async {
    if (_isLoadingMore || !_hasMoreData || _isLoading) return;

    setState(() => _isLoadingMore = true);

    // Simüle edilmiş pagination - gerçek API'de page parametresi gönderilir
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _currentPage++;
      _isLoadingMore = false;
      // API'den daha fazla veri gelmezse
      if (_allTickets.length < _currentPage * _itemsPerPage) {
        _hasMoreData = false;
      }
    });
  }

  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_allTickets);

    // Arama filtresi
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((ticket) {
        final subject = ticket['subject']?.toString().toLowerCase() ?? '';
        final message = ticket['message']?.toString().toLowerCase() ?? '';
        return subject.contains(_searchQuery) || message.contains(_searchQuery);
      }).toList();
    }

    // Sıralama
    switch (_sortBy) {
      case 'date_desc':
        filtered.sort((a, b) {
          final dateA = DateTime.tryParse(a['created_at']?.toString() ?? '');
          final dateB = DateTime.tryParse(b['created_at']?.toString() ?? '');
          if (dateA == null || dateB == null) return 0;
          return dateB.compareTo(dateA);
        });
        break;
      case 'date_asc':
        filtered.sort((a, b) {
          final dateA = DateTime.tryParse(a['created_at']?.toString() ?? '');
          final dateB = DateTime.tryParse(b['created_at']?.toString() ?? '');
          if (dateA == null || dateB == null) return 0;
          return dateA.compareTo(dateB);
        });
        break;
      case 'status':
        final statusOrder = {
          'pending': 0,
          'in_progress': 1,
          'resolved': 2,
          'closed': 3,
        };
        filtered.sort((a, b) {
          final statusA = statusOrder[a['status']?.toString()] ?? 99;
          final statusB = statusOrder[b['status']?.toString()] ?? 99;
          return statusA.compareTo(statusB);
        });
        break;
    }

    setState(() {
      _filteredTickets = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E5EC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3142)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Taleplerim',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3142),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Arama ve Sıralama
            _buildSearchAndSort(isSmallScreen),

            // Filtre Chips
            _buildFilterChips(isSmallScreen),

            // Tickets List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredTickets.isEmpty
                  ? _buildEmptyState(isSmallScreen)
                  : RefreshIndicator(
                      onRefresh: () => _loadTickets(refresh: true),
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                        itemCount:
                            _filteredTickets.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _filteredTickets.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final ticket = _filteredTickets[index];
                          return _TicketItem(
                            ticket: ticket,
                            isSmallScreen: isSmallScreen,
                            onTap: () => _showTicketDetail(ticket),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndSort(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Row(
        children: [
          Expanded(
            child: NeumorphicContainer(
              isPressed: true,
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: const Color(0xFF2D3142),
                ),
                decoration: InputDecoration(
                  hintText: 'Ara...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 13 : 14,
                    color: const Color(0xFF9CA3AF),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          NeumorphicButton(
            borderRadius: 16,
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            onPressed: () => _showSortOptions(isSmallScreen),
            child: Icon(
              Icons.sort,
              color: const Color(0xFF4ECDC4),
              size: isSmallScreen ? 20 : 22,
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(bool isSmallScreen) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE0E5EC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sıralama',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption(
              'date_desc',
              'Tarihe Göre (Yeni → Eski)',
              Icons.arrow_downward,
              isSmallScreen,
            ),
            _buildSortOption(
              'date_asc',
              'Tarihe Göre (Eski → Yeni)',
              Icons.arrow_upward,
              isSmallScreen,
            ),
            _buildSortOption(
              'status',
              'Duruma Göre',
              Icons.label,
              isSmallScreen,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(
    String value,
    String label,
    IconData icon,
    bool isSmallScreen,
  ) {
    final isSelected = _sortBy == value;
    return NeumorphicButton(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      borderRadius: 12,
      backgroundColor: isSelected
          ? const Color(0xFF4ECDC4).withOpacity(0.1)
          : null,
      onPressed: () {
        setState(() {
          _sortBy = value;
          _applyFiltersAndSort();
        });
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xFF4ECDC4)
                : const Color(0xFF6B7280),
            size: isSmallScreen ? 20 : 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 13 : 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF4ECDC4)
                    : const Color(0xFF2D3142),
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check, color: Color(0xFF4ECDC4), size: 20),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 12,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(
                  filter['label']!,
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 12 : 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF2D3142),
                  ),
                ),
                backgroundColor: const Color(0xFFE0E5EC),
                selectedColor: const Color(0xFF4ECDC4),
                checkmarkColor: Colors.white,
                elevation: isSelected ? 4 : 2,
                shadowColor: Colors.black26,
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF4ECDC4)
                      : const Color(0xFFBDBDBD),
                  width: 1,
                ),
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = selected ? filter['value'] : null;
                  });
                  _loadTickets(refresh: true);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: isSmallScreen ? 60 : 80,
            color: const Color(0xFF9CA3AF),
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          Text(
            'Henüz destek talebiniz yok',
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3142),
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            'Yeni bir destek talebi oluşturabilirsiniz',
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 12 : 14,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  void _showTicketDetail(Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TicketDetailSheet(
        ticket: ticket,
        onUpdate: () {
          _loadTickets(refresh: true);
        },
      ),
    );
  }
}

class _TicketItem extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final bool isSmallScreen;
  final VoidCallback onTap;

  const _TicketItem({
    required this.ticket,
    required this.isSmallScreen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = ticket['status']?.toString() ?? 'pending';
    final statusInfo = _getStatusInfo(status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeumorphicContainer(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ticket['subject']?.toString() ?? 'Konu belirtilmemiş',
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3142),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusInfo['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: statusInfo['color'],
                          width: 1,
                        ),
                      ),
                      child: Text(
                        statusInfo['label'],
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 10 : 11,
                          fontWeight: FontWeight.w600,
                          color: statusInfo['color'],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ticket['message']?.toString() ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 12 : 13,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: isSmallScreen ? 12 : 14,
                      color: const Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(ticket['created_at']),
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 11 : 12,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: isSmallScreen ? 12 : 14,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {'label': 'Beklemede', 'color': const Color(0xFFF39C12)};
      case 'in_progress':
        return {'label': 'İşlemde', 'color': const Color(0xFF4ECDC4)};
      case 'resolved':
        return {'label': 'Çözüldü', 'color': const Color(0xFF27AE60)};
      case 'closed':
        return {'label': 'Kapatıldı', 'color': const Color(0xFF95A5A6)};
      default:
        return {'label': 'Bilinmiyor', 'color': const Color(0xFF6B7280)};
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Tarih belirtilmemiş';
    try {
      final dateTime = DateTime.parse(date.toString());
      return '${dateTime.day}.${dateTime.month}.${dateTime.year}';
    } catch (e) {
      return date.toString();
    }
  }
}

class _TicketDetailSheet extends StatefulWidget {
  final Map<String, dynamic> ticket;
  final VoidCallback onUpdate;

  const _TicketDetailSheet({required this.ticket, required this.onUpdate});

  @override
  State<_TicketDetailSheet> createState() => _TicketDetailSheetState();
}

class _TicketDetailSheetState extends State<_TicketDetailSheet> {
  final TextEditingController _noteController = TextEditingController();
  bool _isUpdating = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final status = widget.ticket['status']?.toString() ?? 'pending';
    final statusInfo = _getStatusInfo(status);
    final canUpdate = status != 'closed';

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFE0E5EC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF9CA3AF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Talep Detayları',
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 18 : 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2D3142),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusInfo['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: statusInfo['color'],
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            statusInfo['label'],
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 12 : 13,
                              fontWeight: FontWeight.w600,
                              color: statusInfo['color'],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailItem(
                      'Konu',
                      widget.ticket['subject']?.toString() ?? '-',
                      Icons.label,
                      isSmallScreen,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      'İsim',
                      widget.ticket['name']?.toString() ?? '-',
                      Icons.person,
                      isSmallScreen,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      'E-posta',
                      widget.ticket['email']?.toString() ?? '-',
                      Icons.email,
                      isSmallScreen,
                    ),
                    if (widget.ticket['phone'] != null) ...[
                      const SizedBox(height: 16),
                      _buildDetailItem(
                        'Telefon',
                        widget.ticket['phone']?.toString() ?? '-',
                        Icons.phone,
                        isSmallScreen,
                      ),
                    ],
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      'Tarih',
                      _formatDate(widget.ticket['created_at']),
                      Icons.calendar_today,
                      isSmallScreen,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Mesaj',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 13 : 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 8),
                    NeumorphicContainer(
                      isPressed: true,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.ticket['message']?.toString() ??
                            'Mesaj bulunamadı',
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 12 : 13,
                          color: const Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                    ),

                    // Mesaj Ekleme ve Kapatma Bölümü
                    if (canUpdate) ...[
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      Text(
                        'Not Ekle',
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 13 : 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 8),
                      NeumorphicContainer(
                        isPressed: true,
                        borderRadius: 16,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: TextField(
                          controller: _noteController,
                          maxLines: 3,
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 12 : 13,
                            color: const Color(0xFF2D3142),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Eklemek istediğiniz notu yazın...',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 12 : 13,
                              color: const Color(0xFF9CA3AF),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: NeumorphicButton(
                              borderRadius: 12,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                              ),
                              onPressed: _isUpdating ? null : _addNote,
                              child: _isUpdating
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Not Ekle',
                                      style: GoogleFonts.poppins(
                                        fontSize: isSmallScreen ? 13 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: NeumorphicButton(
                              borderRadius: 12,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
                              ),
                              onPressed: _isUpdating ? null : _closeTicket,
                              child: Text(
                                'Talebi Kapat',
                                style: GoogleFonts.poppins(
                                  fontSize: isSmallScreen ? 13 : 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF95A5A6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF95A5A6),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock,
                              color: Color(0xFF95A5A6),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Bu talep kapatılmıştır',
                                style: GoogleFonts.poppins(
                                  fontSize: isSmallScreen ? 12 : 13,
                                  color: const Color(0xFF95A5A6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    bool isSmallScreen,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: isSmallScreen ? 16 : 18,
          color: const Color(0xFF4ECDC4),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 11 : 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: const Color(0xFF2D3142),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {'label': 'Beklemede', 'color': const Color(0xFFF39C12)};
      case 'in_progress':
        return {'label': 'İşlemde', 'color': const Color(0xFF4ECDC4)};
      case 'resolved':
        return {'label': 'Çözüldü', 'color': const Color(0xFF27AE60)};
      case 'closed':
        return {'label': 'Kapatıldı', 'color': const Color(0xFF95A5A6)};
      default:
        return {'label': 'Bilinmiyor', 'color': const Color(0xFF6B7280)};
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Tarih belirtilmemiş';
    try {
      final dateTime = DateTime.parse(date.toString());
      return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return date.toString();
    }
  }

  Future<void> _addNote() async {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lütfen bir not yazın')));
      return;
    }

    setState(() => _isUpdating = true);

    try {
      // Provider'dan note güncelleme - API'ye bağlanınca yorum açılacak
      // await ref.read(supportsProvider.notifier).updateTicketNotes(
      //   ticketId: widget.ticket['id'],
      //   notes: _noteController.text.trim(),
      // );

      // Simülasyon
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not başarıyla eklendi'),
            backgroundColor: Color(0xFF4ECDC4),
          ),
        );
        _noteController.clear();
        widget.onUpdate();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  Future<void> _closeTicket() async {
    // Onay dialogu göster
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFE0E5EC),
        title: Text(
          'Talebi Kapat',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3142),
          ),
        ),
        content: Text(
          'Bu talebi kapatmak istediğinize emin misiniz?',
          style: GoogleFonts.poppins(color: const Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'İptal',
              style: GoogleFonts.poppins(color: const Color(0xFF6B7280)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Kapat',
              style: GoogleFonts.poppins(
                color: const Color(0xFFE74C3C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isUpdating = true);

    try {
      // Provider'dan durum güncelleme - API'ye bağlanınca yorum açılacak
      // await ref.read(supportsProvider.notifier).updateTicketStatus(
      //   ticketId: widget.ticket['id'],
      //   status: 'closed',
      // );

      // Simülasyon
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Talep başarıyla kapatıldı'),
            backgroundColor: Color(0xFF4ECDC4),
          ),
        );
        Navigator.pop(context);
        widget.onUpdate();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }
}
