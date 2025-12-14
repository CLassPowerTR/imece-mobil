// lib/screens/profil/support/widgets/faq_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'neumorphic_container.dart';

class FaqCard extends StatelessWidget {
  const FaqCard({Key? key}) : super(key: key);

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'Siparişimi nasıl takip edebilirim?',
      'answer':
          'Siparişlerinizi "Profilim > Siparişlerim" bölümünden takip edebilirsiniz.',
    },
    {
      'question': 'İade sürecim ne kadar sürer?',
      'answer':
          'İade işlemleri ortalama 5-7 iş günü içerisinde tamamlanmaktadır.',
    },
    {
      'question': 'Ödeme yöntemleri nelerdir?',
      'answer':
          'Kredi kartı, banka kartı ve havale/EFT ile ödeme yapabilirsiniz.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return NeumorphicContainer(
      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sık Sorulan Sorular',
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3142),
            ),
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          ..._faqs.map(
            (faq) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FaqItem(
                question: faq['question']!,
                answer: faq['answer']!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return NeumorphicButton(
      borderRadius: isSmallScreen ? 12 : 16,
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      margin: EdgeInsets.zero,
      onPressed: () {
        setState(() => _isExpanded = !_isExpanded);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.question,
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D3142),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_right,
                color: const Color(0xFF6B7280),
                size: isSmallScreen ? 20 : 24,
              ),
            ],
          ),
          if (_isExpanded) ...[
            SizedBox(height: isSmallScreen ? 10 : 12),
            Text(
              widget.answer,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 11 : 12,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
