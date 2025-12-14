// lib/screens/profil/support/widgets/contact_form_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'neumorphic_container.dart';
import '../../../../providers/supports_provider.dart';

class ContactFormCard extends ConsumerStatefulWidget {
  const ContactFormCard({Key? key}) : super(key: key);

  @override
  ConsumerState<ContactFormCard> createState() => _ContactFormCardState();
}

class _ContactFormCardState extends ConsumerState<ContactFormCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedSubject = 'Diğer';
  PlatformFile? _selectedFile;
  bool _isUploading = false;

  final List<String> _subjects = [
    'Sipariş Sorunu',
    'Ürün Hakkında Soru',
    'Ödeme Sorunu',
    'Hesap Sorunu',
    'Teknik Destek',
    'İade/İptal',
    'Diğer',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      showTemporarySnackBar(
        context,
        'Dosya seçilirken bir hata oluştu: $e',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Dosya varsa multipart file'a çevir
      http.MultipartFile? attachment;
      if (_selectedFile != null && _selectedFile!.bytes != null) {
        attachment = http.MultipartFile.fromBytes(
          'attachment',
          _selectedFile!.bytes!,
          filename: _selectedFile!.name,
        );
      }

      // Telefon numarasını formatla - sadece rakamları al ve +90 ekle
      String? phoneNumber;
      if (_phoneController.text.trim().isNotEmpty) {
        String digits = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.isNotEmpty) {
          phoneNumber = '+90$digits';
        }
      }

      await ref
          .read(supportsProvider.notifier)
          .createSupportTicket(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: phoneNumber,
            subject: _selectedSubject,
            message: _messageController.text.trim(),
            attachment: attachment,
          );

      showTemporarySnackBar(
        context,
        'Destek talebiniz başarıyla oluşturuldu!',
        type: SnackBarType.success,
      );
      _clearForm();
    } catch (e) {
      showTemporarySnackBar(
        context,
        'Bir hata oluştu: ${e.toString()}',
        type: SnackBarType.error,
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _messageController.clear();
    setState(() {
      _selectedSubject = 'Diğer';
      _selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth < 400;

    return NeumorphicContainer(
      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bize Ulaşın',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 18 : 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3142),
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              'Sorularınız için formu doldurun, size en kısa sürede dönüş yapalım.',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 11 : 12,
                color: const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            // Ad Soyad ve E-posta - Küçük ekranlarda alt alta
            if (isSmallScreen) ...[
              _NeumorphicTextField(
                controller: _nameController,
                hintText: 'Ad Soyad',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Zorunlu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _NeumorphicTextField(
                controller: _emailController,
                hintText: 'E-posta',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Zorunlu';
                  }
                  if (!value.contains('@')) {
                    return 'Geçersiz';
                  }
                  return null;
                },
              ),
            ] else
              Row(
                children: [
                  Expanded(
                    child: _NeumorphicTextField(
                      controller: _nameController,
                      hintText: 'Ad Soyad',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Zorunlu';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: isMediumScreen ? 12 : 16),
                  Expanded(
                    child: _NeumorphicTextField(
                      controller: _emailController,
                      hintText: 'E-posta',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Zorunlu';
                        }
                        if (!value.contains('@')) {
                          return 'Geçersiz';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            // Telefon ve Konu - Küçük ekranlarda alt alta
            if (isSmallScreen) ...[
              _NeumorphicTextField(
                controller: _phoneController,
                hintText: '(555) 123 45 67',
                keyboardType: TextInputType.phone,
                prefixText: '+90 ',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneInputFormatter(),
                ],
              ),
              const SizedBox(height: 12),
              _NeumorphicDropdown(
                value: _selectedSubject,
                items: _subjects,
                onChanged: (value) {
                  setState(() => _selectedSubject = value);
                },
              ),
            ] else
              Row(
                children: [
                  Expanded(
                    child: _NeumorphicTextField(
                      controller: _phoneController,
                      hintText: '(555) 123 45 67',
                      keyboardType: TextInputType.phone,
                      prefixText: '+90 ',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PhoneInputFormatter(),
                      ],
                    ),
                  ),
                  SizedBox(width: isMediumScreen ? 12 : 16),
                  Expanded(
                    child: _NeumorphicDropdown(
                      value: _selectedSubject,
                      items: _subjects,
                      onChanged: (value) {
                        setState(() => _selectedSubject = value);
                      },
                    ),
                  ),
                ],
              ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            _NeumorphicTextField(
              controller: _messageController,
              hintText: 'Mesajınız',
              maxLines: isSmallScreen ? 4 : 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen mesajınızı yazın';
                }
                return null;
              },
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            _FileUploadBar(
              selectedFile: _selectedFile,
              onTap: _pickFile,
              onRemove: () => setState(() => _selectedFile = null),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            SizedBox(
              width: double.infinity,
              child: NeumorphicButton(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFC06C84)],
                ),
                onPressed: _isUploading ? null : _submitForm,
                child: _isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Gönder',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NeumorphicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;

  const _NeumorphicTextField({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
    this.prefixText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return NeumorphicContainer(
      isPressed: true,
      borderRadius: isSmallScreen ? 12 : 16,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 4,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters,
        style: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 12 : 14,
          color: const Color(0xFF2D3142),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 12 : 14,
            color: const Color(0xFF9CA3AF),
          ),
          prefixText: prefixText,
          prefixStyle: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 12 : 14,
            color: const Color(0xFF2D3142),
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 10 : 12,
          ),
          isDense: isSmallScreen,
        ),
      ),
    );
  }
}

class _NeumorphicDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _NeumorphicDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return NeumorphicContainer(
      isPressed: true,
      borderRadius: isSmallScreen ? 12 : 16,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 4,
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.poppins(fontSize: isSmallScreen ? 12 : 14),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (val) => onChanged(val!),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 10 : 12,
          ),
          isDense: isSmallScreen,
        ),
        style: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 12 : 14,
          color: const Color(0xFF2D3142),
        ),
        dropdownColor: const Color(0xFFE0E5EC),
        icon: Icon(
          Icons.arrow_drop_down,
          color: const Color(0xFF6B7280),
          size: isSmallScreen ? 20 : 24,
        ),
        isExpanded: true,
      ),
    );
  }
}

class _FileUploadBar extends StatelessWidget {
  final PlatformFile? selectedFile;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FileUploadBar({
    required this.selectedFile,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return NeumorphicContainer(
      isPressed: true,
      borderRadius: isSmallScreen ? 12 : 16,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 10 : 12,
      ),
      child: Row(
        children: [
          Icon(
            selectedFile != null ? Icons.insert_drive_file : Icons.attach_file,
            color: const Color(0xFF6B7280),
            size: isSmallScreen ? 18 : 20,
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Text(
              selectedFile?.name ?? 'Dosya (Opsiyonel)',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 12 : 14,
                color: selectedFile != null
                    ? const Color(0xFF2D3142)
                    : const Color(0xFF9CA3AF),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (selectedFile != null)
            IconButton(
              icon: Icon(Icons.close, size: isSmallScreen ? 18 : 20),
              color: const Color(0xFF6B7280),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 8 : 12,
                  vertical: 4,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Seç',
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 11 : 12,
                  color: const Color(0xFF4ECDC4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Telefon formatı için TextInputFormatter
// Format: (555) 123 45 67 (+90 prefix'i ayrı olarak eklenecek)
// 3 rakam + boşluk + 3 rakam + boşluk + 2 rakam + boşluk + 2 rakam
// Toplam: 10 haneli numara
class PhoneInputFormatter extends TextInputFormatter {
  static const int maxDigits = 10; // Maksimum 10 rakam

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Sadece rakamları al
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Maksimum 10 rakam sınırı
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Format: (XXX) XXX XX XX
    String formatted;
    if (digits.length <= 3) {
      formatted = '($digits';
    } else if (digits.length <= 6) {
      formatted = '(${digits.substring(0, 3)}) ${digits.substring(3)}';
    } else if (digits.length <= 8) {
      formatted =
          '(${digits.substring(0, 3)}) ${digits.substring(3, 6)} ${digits.substring(6)}';
    } else {
      formatted =
          '(${digits.substring(0, 3)}) ${digits.substring(3, 6)} ${digits.substring(6, 8)} ${digits.substring(8)}';
    }

    // Cursor pozisyonunu hesapla
    int cursorPosition = formatted.length;

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
