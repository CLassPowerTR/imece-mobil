part of '../../buyer_profil_screen.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  String _formatDate(DateTime dt) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}-${two(dt.minute)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey[300],
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        leading: TurnBackTextIcon(),
        title: customText('Profilim', context,
            size: AppTextSizes.bodyLarge(context), weight: FontWeight.w600),
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
                  value: user.username,
                  onEdit: null, //TODO: DÜZENLEME EKLENECEK,
                ),
                _infoCard(
                  context,
                  title: 'Ad Soyad',
                  icon: Icons.person_outline_sharp,
                  value:
                      ((user.firstName).trim() + ' ' + (user.lastName).trim())
                          .trim(),
                  onEdit: null, //TODO: DÜZENLEME EKLENECEK,
                ),
                _infoCard(
                  context,
                  title: 'E-posta',
                  icon: Icons.email_outlined,
                  value: user.email,
                  onEdit: null, //TODO: DÜZENLEME EKLENECEK,
                ),
                _infoCard(
                  context,
                  title: 'Telefon',
                  icon: Icons.phone_outlined,
                  value: user.telno ?? '-',
                  onEdit: null, //TODO: DÜZENLEME EKLENECEK,
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

  Widget _infoCard(BuildContext context,
      {required String title,
      required String value,
      VoidCallback? onEdit,
      IconData? icon}) {
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
                  Text(title,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      )),
                  Text(value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: HomeStyle(context: context).primary,
                        fontWeight: FontWeight.w600,
                      )),
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
}
