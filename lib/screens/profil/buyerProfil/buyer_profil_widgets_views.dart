
part of 'buyer_profil_screen.dart';

class _topProfile extends StatelessWidget {
  final User buyerProfil;
  final double height;
  final double width;
  const _topProfile({
    required this.buyerProfil,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = width < 360;

    final String profileImageUrl =
        (buyerProfil.profilFotograf == null ||
            (buyerProfil.profilFotograf?.isEmpty ?? true))
        ? NotFound.defaultProfileImageUrl
        : buyerProfil.profilFotograf!;

    final displayName =
        (buyerProfil.firstName == '' && buyerProfil.lastName == '')
        ? buyerProfil.username
        : '${buyerProfil.firstName} ${buyerProfil.lastName}';

    final roleText = buyerProfil.rol == 'alici' ? 'Üye' : (buyerProfil.rol == 'satici' ? 'Satıcı' : '');

    return Container(
      height: isSmallScreen ? height * 0.25 : height * 0.28,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary(context).withOpacity(0.8),
            AppColors.secondary(context).withOpacity(0.9),
            AppColors.secondary(context),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 20,
            vertical: isSmallScreen ? 12 : 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profil Fotoğrafı
              Hero(
                tag: 'profile_photo_${buyerProfil.id}',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipOval(
                    child:
                        (buyerProfil.profilFotograf == null ||
                            (buyerProfil.profilFotograf?.isEmpty ?? true))
                        ? Container(
                            width: isSmallScreen ? 80 : 100,
                            height: isSmallScreen ? 80 : 100,
                            color: Colors.white,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/vectors/profil.svg',
                                width: isSmallScreen ? 50 : 60,
                                height: isSmallScreen ? 50 : 60,
                                colorFilter: ColorFilter.mode(
                                  AppColors.primary(context),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: profileImageUrl,
                            width: isSmallScreen ? 80 : 100,
                            height: isSmallScreen ? 80 : 100,
                            fit: BoxFit.cover,
                            memCacheWidth: 300,
                            fadeInDuration: const Duration(milliseconds: 200),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(color: Colors.white),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.white,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/vectors/profil.svg',
                                  width: isSmallScreen ? 50 : 60,
                                  height: isSmallScreen ? 50 : 60,
                                  colorFilter: ColorFilter.mode(
                                    Colors.grey[400]!,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 10 : 12),

              // İsim
              Text(
                displayName,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 18 : 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              // Rol Badge
              if (roleText.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
                    vertical: isSmallScreen ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    roleText,
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 11 : 12,
                      fontWeight: FontWeight.w500,
                    color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tasarruf Karnesi - Yatay kaydırılabilir bilgi kartları
class _savingsCards extends StatelessWidget {
  final User buyerProfil;

  const _savingsCards({required this.buyerProfil});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    final blockedBakiye = buyerProfil.aliciProfili?.blockedBakiye ?? 0.0;
    final bakiye = double.tryParse(buyerProfil.bakiye) ?? 0.0;

    final cards = [
      _SavingsCardData(
        title: 'Bakiye',
        value: '₺${bakiye.toStringAsFixed(2)}',
        icon: Icons.account_balance_wallet_outlined,
        color: colorScheme.primary,
      ),
      _SavingsCardData(
        title: 'Bloke Bakiye',
        value: '₺${blockedBakiye.toStringAsFixed(2)}',
        icon: Icons.lock_outline,
        color: colorScheme.tertiary,
      ),
      _SavingsCardData(
        title: 'Durum',
        value: buyerProfil.isActive ? 'Aktif' : 'Pasif',
        icon: Icons.verified_outlined,
        color: AppColors.succesful(context),
      ),
    ];

    return SizedBox(
      height: isSmallScreen ? 100 : 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            width: isSmallScreen ? 140 : 155,
            padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
            decoration: BoxDecoration(
              color: card.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: card.color.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: card.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        card.icon,
                        size: isSmallScreen ? 16 : 18,
                        color: card.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        card.title,
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 11 : 12,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  card.value,
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.w700,
                    color: card.color,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SavingsCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SavingsCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _userMenu extends StatelessWidget {
  final User buyerProfil;

  const _userMenu({required this.buyerProfil});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    final menuItems = [
      _MenuItem(
        icon: Icons.person_outline,
        title: 'Profilim',
        onTap: () => Navigator.pushNamed(
          context,
          '/profil/myProfile',
          arguments: buyerProfil,
        ),
      ),
      _MenuItem(
        icon: Icons.receipt_long_outlined,
        title: 'Siparişlerim',
        onTap: () => Navigator.pushNamed(
          context,
          '/profil/orders',
          arguments: buyerProfil,
        ),
      ),
      _MenuItem(
        icon: Icons.favorite_border,
        title: 'Favorilerim',
        onTap: () => Navigator.pushNamed(
          context,
          '/profil/favorite',
          arguments: buyerProfil,
        ),
      ),
      _MenuItem(
        icon: Icons.star_border,
        title: 'Değerlendirmelerim',
        onTap: () => Navigator.pushNamed(
          context,
          '/profil/comments',
          arguments: buyerProfil,
        ),
      ),
      _MenuItem(
        icon: Icons.group_outlined,
        title: 'Dahil Olduğum Gruplar',
        onTap: () => Navigator.pushNamed(
          context,
          '/profil/groups',
          arguments: buyerProfil,
        ),
      ),
      _MenuItem(
        icon: Icons.people_outline,
        title: 'Takip Ettiklerim',
        onTap: () => Navigator.pushNamed(
          context,
          '/profil/follow',
          arguments: buyerProfil,
        ),
      ),
      _MenuItem(
        icon: Icons.location_on_outlined,
        title: 'Adreslerim',
        onTap: () => Navigator.pushNamed(
          context,
          '/profil/adress',
          arguments: {'buyerProfil': buyerProfil},
        ),
      ),
      _MenuItem(
        icon: Icons.credit_card_outlined,
        title: 'Kartlarım',
        onTap: () => Navigator.pushNamed(
          context,
          '/profil/cards',
          arguments: buyerProfil,
        ),
      ),
      _MenuItem(
        icon: Icons.support_agent_outlined,
        title: 'Destek',
        onTap: () => Navigator.pushNamed(context, '/profil/support'),
      ),
      _MenuItem(
        icon: Icons.settings_outlined,
        title: 'Ayarlar',
        onTap: () => Navigator.pushNamed(
          context,
          '/profil/settings',
          arguments: buyerProfil,
        ),
      ),
    ];

    return Column(
      children: menuItems.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: isSmallScreen ? 6 : 8),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.outline(context).withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow(context).withOpacity(0.04),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 14 : 16,
                  vertical: isSmallScreen ? 14 : 16,
                ),
                child: Row(
                  children: [
                    Container(
                      width: isSmallScreen ? 40 : 44,
                      height: isSmallScreen ? 40 : 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary(context).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.primary(context),
                        size: isSmallScreen ? 20 : 22,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 14 : 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: isSmallScreen ? 20 : 22,
                      color: AppColors.onSurfaceVariant(context).withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

class _logoutButton extends ConsumerWidget {
  final VoidCallback onLogout;

  const _logoutButton({required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // Logout confirmation dialog
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  'Çıkış Yap',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                content: Text(
                  'Çıkış yapmak istediğinizden emin misiniz?',
                  style: GoogleFonts.poppins(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'İptal',
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Çıkış Yap',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );

            if (shouldLogout == true) {
              try {
                await ref.read(userProvider.notifier).logout();
                if (context.mounted) {
                  onLogout();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Çıkış yapılamadı: $e'),
                      backgroundColor: AppColors.error(context),
                    ),
                  );
                }
              }
            }
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 14 : 16,
              vertical: isSmallScreen ? 14 : 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.error(context).withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.error(context).withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: AppColors.error(context),
                  size: isSmallScreen ? 20 : 22,
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Text(
                  'Çıkış Yap',
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 14 : 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
