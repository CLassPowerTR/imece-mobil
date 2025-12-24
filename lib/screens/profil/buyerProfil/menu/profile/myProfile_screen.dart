part of '../../buyer_profil_screen.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  bool _initialized = false;
  bool _isSaving = false;
  late Map<String, String> _originalValues;
  late Map<String, String> _editedValues;

  @override
  void initState() {
    super.initState();
    _originalValues = {
      'username': '',
      'first_name': '',
      'last_name': '',
      'telno': '',
    };
    _editedValues = Map<String, String>.from(_originalValues);
  }

  bool get _hasChanges {
    return _editedValues.entries.any(
      (entry) =>
          _normalize(entry.value) != _normalize(_originalValues[entry.key]),
    );
  }

  String _formatDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}-${two(dt.minute)}';
  }

  void _syncUser(User user) {
    final nextOriginal = {
      'username': _normalize(user.username),
      'first_name': _normalize(user.firstName),
      'last_name': _normalize(user.lastName),
      'telno': _normalize(user.telno),
    };

    if (_initialized && _mapsEqual(_originalValues, nextOriginal)) {
      return;
    }

    setState(() {
      _originalValues = nextOriginal;
      _editedValues = Map<String, String>.from(nextOriginal);
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user != null) {
      _syncUser(user);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildEtherealAppBar(context),
      body: Stack(
        children: [
          // Ethereal cloudscape background
          _buildNebulousBackground(context),
          // Content
          SafeArea(
            child: user == null
                ? Center(
                    child: _buildStardustText(
                      'Kullanıcı bilgisi bulunamadı',
                      fontSize: 16,
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    children: [
                      _buildFloatingCard(
                        context,
                        index: 0,
                        title: 'Kullanıcı Adı',
                        icon: Icons.person,
                        value: _editedValues['username'] ?? '',
                        onEdit: () => _editUsername(context),
                      ),
                      _buildFloatingCard(
                        context,
                        index: 1,
                        title: 'Ad Soyad',
                        icon: Icons.person_outline_sharp,
                        value:
                            '${(_editedValues['first_name'] ?? '').trim()} ${(_editedValues['last_name'] ?? '').trim()}'
                                .trim(),
                        onEdit: () => _editName(context),
                      ),
                      _buildFloatingCard(
                        context,
                        index: 2,
                        title: 'E-posta',
                        icon: Icons.email_outlined,
                        value: user.email,
                      ),
                      _buildFloatingCard(
                        context,
                        index: 3,
                        title: 'Telefon',
                        icon: Icons.phone_outlined,
                        value: (_editedValues['telno'] ?? '').isEmpty
                            ? '-'
                            : (_editedValues['telno'] ?? ''),
                        onEdit: () => _editPhone(context),
                      ),
                      _buildFloatingCard(
                        context,
                        index: 4,
                        title: 'Rol',
                        icon: Icons.person_outline,
                        value: user.rol,
                      ),
                      _buildFloatingCard(
                        context,
                        index: 5,
                        title: 'Cinsiyet',
                        icon: Icons.person_outline,
                        value: user.aliciProfili?.cinsiyet ?? '-',
                      ),
                      _buildFloatingCard(
                        context,
                        index: 6,
                        title: 'Durum',
                        icon: Icons.check_circle_outline,
                        value: user.isActive ? 'Aktif' : 'Pasif',
                      ),
                      _buildFloatingCard(
                        context,
                        index: 7,
                        title: 'Bakiye',
                        icon: Icons.money_outlined,
                        value: user.bakiye,
                      ),

                      _buildFloatingCard(
                        context,
                        index: 9,
                        title: 'Üyelik Tarihi',
                        icon: Icons.date_range,
                        value: _formatDate(user.dateJoined),
                      ),
                      _buildFloatingCard(
                        context,
                        index: 10,
                        title: 'Son Giriş',
                        icon: Icons.date_range_outlined,
                        value: user.lastLogin != null
                            ? _formatDate(user.lastLogin!)
                            : '-',
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ============= ETHEREAL DESIGN METHODS =============

  /// Creates the nebulous cloudscape background with volumetric depth
  Widget _buildNebulousBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8D7FF), // Pastel amethyst
            Color(0xFFD7E8FF), // Soft sapphire
            Color(0xFFF5F5FF), // Moonstone white
            Color(0xFFFFE8F0), // Dawn pink
            Color(0xFFE0E8FF), // Light ethereal blue
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Cloud layer 1 - far background
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x30E8D7FF), Color(0x00E8D7FF)],
                ),
              ),
            ),
          ),
          // Cloud layer 2 - mid background
          Positioned(
            top: 200,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x25D7E8FF), Color(0x00D7E8FF)],
                ),
              ),
            ),
          ),
          // Cloud layer 3 - lower background
          Positioned(
            bottom: 100,
            right: 50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x20FFE8F0), Color(0x00FFE8F0)],
                ),
              ),
            ),
          ),
          // Stardust particle overlay (very subtle)
          Positioned.fill(child: CustomPaint(painter: _StardustPainter())),
        ],
      ),
    );
  }

  /// Creates the ethereal glassmorphic AppBar
  PreferredSizeWidget _buildEtherealAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0x30FFFFFF),
      centerTitle: true,
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x40FFFFFF), Color(0x20FFFFFF)],
              ),
              border: Border(
                bottom: BorderSide(color: Color(0x30FFFFFF), width: 1),
              ),
            ),
          ),
        ),
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0.3,
      leading: TurnBackTextIcon(),
      title: _buildStardustText(
        'Profilim',
        fontSize: AppTextSizes.bodyLarge(context)!.toDouble(),
        fontWeight: FontWeight.w600,
      ),
      actions: [
        if (_hasChanges)
          TextButton(
            onPressed: _isSaving ? null : () => _saveChanges(context),
            child: _isSaving
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF9B8FD9),
                      ),
                    ),
                  )
                : Text(
                    'Kaydet',
                    style: TextStyle(
                      color: Color(0xFF9B8FD9),
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(color: Color(0x30E8D7FF), blurRadius: 8),
                      ],
                    ),
                  ),
          ),
      ],
    );
  }

  /// Creates stardust-styled text with ethereal glow
  Widget _buildStardustText(
    String text, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Color(0xFF6B6B7F),
        shadows: [Shadow(color: Color(0x20FFFFFF), blurRadius: 4)],
      ),
    );
  }

  /// Creates a floating card with antigravity effects
  Widget _buildFloatingCard(
    BuildContext context, {
    required int index,
    required String title,
    required String value,
    VoidCallback? onEdit,
    IconData? icon,
  }) {
    // Calculate subtle rotation based on index for variety
    final rotation = (index % 3 - 1) * 0.008; // -0.008 to 0.008 radians
    final horizontalOffset = (index % 2 == 0) ? 4.0 : -4.0;

    return Transform.rotate(
      angle: rotation,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: horizontalOffset > 0 ? horizontalOffset : 0,
          right: horizontalOffset < 0 ? -horizontalOffset : 0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                // Crystallized cloud material
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0x50FFFFFF), Color(0x30FFFFFF)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0x50FFFFFF), width: 1.5),
                // Aurora light halo effect
                boxShadow: [
                  BoxShadow(
                    color: Color(0x15E8D7FF), // Amethyst glow
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(-4, -4),
                  ),
                  BoxShadow(
                    color: Color(0x15D7E8FF), // Sapphire glow
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Color(0x10FFE8F0), // Dawn pink glow
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0x30E8D7FF), Color(0x10E8D7FF)],
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 22,
                        color: Color(0xFF9B8FD9),
                        shadows: [
                          Shadow(color: Color(0x40E8D7FF), blurRadius: 8),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFB8B8C8), // Stardust grey
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(color: Color(0x20FFFFFF), blurRadius: 4),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          value.isEmpty ? '-' : value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B6B7F),
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(color: Color(0x30FFFFFF), blurRadius: 6),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onEdit != null)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0x20E8D7FF), Color(0x00E8D7FF)],
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit_outlined),
                        color: Color(0xFF9B8FD9),
                        onPressed: onEdit,
                        tooltip: 'Düzenle',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Kept for backwards compatibility, but now delegates to floating card
  Widget _infoCard(
    BuildContext context, {
    required String title,
    required String value,
    VoidCallback? onEdit,
    IconData? icon,
  }) {
    return _buildFloatingCard(
      context,
      index: 0,
      title: title,
      value: value,
      onEdit: onEdit,
      icon: icon,
    );
  }

  Future<void> _editUsername(BuildContext context) async {
    final controller = TextEditingController(
      text: _editedValues['username'] ?? '',
    );
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kullanıcı Adı'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Kullanıcı adı'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('İptal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text('Kaydet'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _editedValues['username'] = _normalize(result);
      });
    }
  }

  Future<void> _editName(BuildContext context) async {
    final firstController = TextEditingController(
      text: _editedValues['first_name'] ?? '',
    );
    final lastController = TextEditingController(
      text: _editedValues['last_name'] ?? '',
    );

    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ad Soyad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstController,
              decoration: const InputDecoration(labelText: 'Ad'),
            ),
            TextField(
              controller: lastController,
              decoration: const InputDecoration(labelText: 'Soyad'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('İptal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, {
              'first_name': firstController.text.trim(),
              'last_name': lastController.text.trim(),
            }),
            child: Text('Kaydet'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _editedValues['first_name'] = _normalize(result['first_name'] ?? '');
        _editedValues['last_name'] = _normalize(result['last_name'] ?? '');
      });
    }
  }

  Future<void> _editPhone(BuildContext context) async {
    final controller = TextEditingController(
      text: _editedValues['telno'] ?? '',
    );
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Telefon'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'Telefon'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('İptal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text('Kaydet'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _editedValues['telno'] = _normalize(result);
      });
    }
  }

  Future<void> _saveChanges(BuildContext context) async {
    final payload = <String, dynamic>{};
    _editedValues.forEach((key, value) {
      if (_normalize(_originalValues[key]) != _normalize(value)) {
        payload[key] = _normalize(value);
      }
    });

    if (payload.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      await ref.read(userProvider.notifier).updateUser(payload);
      setState(() {
        _originalValues = Map.from(_editedValues);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil bilgileri güncellendi.')),
        );
      }
    } catch (e) {
      if (mounted) {
        showTemporarySnackBar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _normalize(String? value) => value?.trim() ?? '';

  bool _mapsEqual(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (_normalize(a[key]) != _normalize(b[key])) return false;
    }
    return true;
  }
}

/// Custom painter for creating subtle stardust particle overlay
class _StardustPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0x08FFFFFF)
      ..style = PaintingStyle.fill;

    // Create subtle stardust particles
    final random = Random(42); // Fixed seed for consistent particles
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
