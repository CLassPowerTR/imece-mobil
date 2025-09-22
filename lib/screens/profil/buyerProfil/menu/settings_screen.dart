part of '../buyer_profil_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.surface(context),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.grey[300],
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        leading: TurnBackTextIcon(),
        title: customText('Ayarlar', context,
            size: AppTextSizes.bodyLarge(context), weight: FontWeight.w600),
      ),
      body: ListView(
        padding: AppPaddings.all12,
        children: [
          _infoCard(
            context,
            icon: Icons.notifications_none,
            title: 'Bildirimler',
            subtitle: 'Bildirim ayarlarını yöneltin',
            onTap: () {},
          ),
          _infoCard(
            context,
            icon: Icons.shopping_bag_outlined,
            title: 'Alışveriş Tercihleri',
            subtitle: 'Alışveriş ayarlarınızı düzeltin',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      color: Colors.grey[100],
      margin: AppPaddings.b12,
      shadowColor: AppColors.outline(context),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.r12),
      child: InkWell(
        borderRadius: AppRadius.r12,
        onTap: onTap,
        child: Padding(
          padding: AppPaddings.all12,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: HomeStyle(context: context).secondary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    Text(title,
                        style: TextStyle(
                          fontSize: 16,
                          color: HomeStyle(context: context).primary,
                          fontWeight: FontWeight.w600,
                        )),
                    Text(subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
