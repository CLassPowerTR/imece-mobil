// lib/core/widgets/offline_banner.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfflineBanner extends StatelessWidget {
  final VoidCallback? onRetry;

  const OfflineBanner({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 360;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red[700],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 8 : 10,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: Colors.white,
              size: isSmallScreen ? 16 : 18,
            ),
            SizedBox(width: isSmallScreen ? 8 : 10),
            Flexible(
              child: Text(
                'İnternet bağlantısı yok',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 12 : 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(width: isSmallScreen ? 8 : 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onRetry,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 10,
                      vertical: isSmallScreen ? 4 : 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Yenile',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 11 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

