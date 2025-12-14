// lib/screens/profil/support/support_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/contact_info_card.dart';
import 'widgets/contact_form_card.dart';
import 'widgets/faq_card.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

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
          'Müşteri Hizmetleri',
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3142),
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/profil/support/tickets');
            },
            icon: const Icon(
              Icons.receipt_long,
              color: Color(0xFF4ECDC4),
              size: 20,
            ),
            label: Text(
              'Taleplerim',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4ECDC4),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: isSmallScreen ? 4 : 8),
              const ContactInfoCard(),
              const ContactFormCard(),
              const FaqCard(),
              SizedBox(height: isSmallScreen ? 16 : 24),
            ],
          ),
        ),
      ),
    );
  }
}
