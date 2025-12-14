// lib/screens/profil/support/widgets/contact_info_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'neumorphic_container.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final defaultPadding = isSmallScreen ? 12.0 : 16.0;

    return NeumorphicContainer(
      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Column(
        spacing: defaultPadding,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İletişim Bilgileri',
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3142),
            ),
          ),

          // İlk satır: Telefon ve Çalışma Saatleri
          _buildContactItem(
            icon: Icons.phone,
            title: 'Telefon',
            content: '+90 (212) 555 0123',
            isSmallScreen: isSmallScreen,
            iconColor: const Color(0xFF4ECDC4),
            isClickable: true,
            onTap: () => _makePhoneCall('+902125550123'),
            onLongPress: () => _copyToClipboard(
              context,
              '+90 (212) 555 0123',
              'Telefon numarası kopyalandı',
            ),
          ),
          _buildContactItem(
            icon: Icons.access_time_filled,
            title: 'Çalışma Saatleri',
            content: 'Pazartesi - Cuma\n09:00 - 18:00',
            isSmallScreen: isSmallScreen,
            iconColor: const Color(0xFFFF6B9D),
            isClickable: false,
          ),
          _buildContactItem(
            icon: Icons.email,
            title: 'E-posta',
            content: 'destek@imecehub.com',
            isSmallScreen: isSmallScreen,
            iconColor: const Color(0xFF9B59B6),
            isClickable: true,
            onTap: () => _sendEmail('destek@imecehub.com'),
            onLongPress: () => _copyToClipboard(
              context,
              'destek@imecehub.com',
              'E-posta adresi kopyalandı',
            ),
          ),
          _buildContactItem(
            icon: Icons.location_on,
            title: 'Adres',
            content: 'İstanbul, Türkiye',
            isSmallScreen: isSmallScreen,
            iconColor: const Color(0xFFF39C12),
            isClickable: true,
            onTap: () => _openMap('İstanbul, Türkiye'),
            onLongPress: () => _copyToClipboard(
              context,
              'İstanbul, Türkiye',
              'Adres kopyalandı',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
    required bool isSmallScreen,
    required Color iconColor,
    required bool isClickable,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    final item = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeumorphicContainer(
          borderRadius: 12,
          padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
          child: Icon(icon, color: iconColor, size: isSmallScreen ? 18 : 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 11 : 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3142),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isClickable) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.touch_app,
                      size: isSmallScreen ? 12 : 14,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 10 : 11,
                  color: isClickable
                      ? const Color(0xFF4ECDC4)
                      : const Color(0xFF6B7280),
                  height: 1.4,
                  decoration: isClickable ? TextDecoration.underline : null,
                  decorationColor: isClickable
                      ? const Color(0xFF4ECDC4).withOpacity(0.3)
                      : null,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    if (isClickable && (onTap != null || onLongPress != null)) {
      return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: item,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: item,
    );
  }

  // Telefon araması yapma
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  // Email gönderme
  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Destek Talebi',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  // Harita açma
  Future<void> _openMap(String address) async {
    final Uri mapUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    }
  }

  // Panoya kopyalama
  Future<void> _copyToClipboard(
    BuildContext context,
    String text,
    String message,
  ) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF4ECDC4),
        ),
      );
    }
  }
}
