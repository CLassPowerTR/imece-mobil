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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey[300],
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        leading: TurnBackTextIcon(),
        title: customText(
          'Profilim',
          context,
          size: AppTextSizes.bodyLarge(context),
          weight: FontWeight.w600,
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isSaving ? null : () => _saveChanges(context),
              child: _isSaving
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Kaydet',
                      style: TextStyle(
                        color: HomeStyle(context: context).secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
        ],
      ),
      body: user == null
          ? Center(child: customText('Kullanıcı bilgisi bulunamadı', context))
          : ListView(
              padding: AppPaddings.all12,
              children: [
                _infoCard(
                  context,
                  title: 'Kullanıcı Adı',
                  icon: Icons.person,
                  value: _editedValues['username'] ?? '',
                  onEdit: () => _editUsername(context),
                ),
                _infoCard(
                  context,
                  title: 'Ad Soyad',
                  icon: Icons.person_outline_sharp,
                  value:
                      '${(_editedValues['first_name'] ?? '').trim()} ${(_editedValues['last_name'] ?? '').trim()}'
                          .trim(),
                  onEdit: () => _editName(context),
                ),
                _infoCard(
                  context,
                  title: 'E-posta',
                  icon: Icons.email_outlined,
                  value: user.email,
                ),
                _infoCard(
                  context,
                  title: 'Telefon',
                  icon: Icons.phone_outlined,
                  value: (_editedValues['telno'] ?? '').isEmpty
                      ? '-'
                      : (_editedValues['telno'] ?? ''),
                  onEdit: () => _editPhone(context),
                ),
                _infoCard(
                  context,
                  title: 'Rol',
                  icon: Icons.person_outline,
                  value: user.rol,
                ),
                _infoCard(
                  context,
                  title: 'Cinsiyet',
                  icon: Icons.person_outline,
                  value: user.aliciProfili?.cinsiyet ?? '-',
                ),
                _infoCard(
                  context,
                  title: 'Durum',
                  icon: Icons.check_circle_outline,
                  value: user.isActive ? 'Aktif' : 'Pasif',
                ),
                _infoCard(
                  context,
                  title: 'Bakiye',
                  icon: Icons.money_outlined,
                  value: user.bakiye,
                ),
                _infoCard(
                  context,
                  title: 'Hata Yapma Oranı',
                  icon: Icons.error_outline,
                  value: user.hataYapmaOrani,
                ),
                _infoCard(
                  context,
                  title: 'Üyelik Tarihi',
                  icon: Icons.date_range,
                  value: _formatDate(user.dateJoined),
                ),
                _infoCard(
                  context,
                  title: 'Son Giriş',
                  icon: Icons.date_range_outlined,
                  value: user.lastLogin != null
                      ? _formatDate(user.lastLogin!)
                      : '-',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required String title,
    required String value,
    VoidCallback? onEdit,
    IconData? icon,
  }) {
    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.only(bottom: 12),
      shadowColor: AppColors.shadow(context),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.r12),
      child: Padding(
        padding: AppPaddings.all16,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12,
          children: [
            if (icon != null) Icon(icon, size: 22, color: Colors.grey[600]),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value.isEmpty ? '-' : value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: HomeStyle(context: context).primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                color: HomeStyle(context: context).secondary,
                onPressed: onEdit,
                tooltip: 'Düzenle',
              ),
          ],
        ),
      ),
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
