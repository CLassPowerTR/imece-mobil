import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imecehub/core/widgets/buttons/textButton.dart';
import 'package:imecehub/core/widgets/container.dart';
import 'package:imecehub/core/widgets/dropdownBox.dart';
import 'package:imecehub/core/widgets/richText.dart';
import 'package:imecehub/core/widgets/showTemporarySnackBar.dart';
import 'package:imecehub/core/widgets/text.dart';
import 'package:imecehub/core/widgets/textField.dart';
import 'package:imecehub/services/api_service.dart';
import 'package:imecehub/screens/home/style/home_screen_style.dart';
import 'package:imecehub/screens/profil/sellerProfil/seller_profil_screen_library.dart';

part 'widget/add_post_view_body.dart';
part 'widget/add_post_view_header.dart';

class AddPost extends StatefulWidget implements PreferredSizeWidget {
  final User sellerProfil;
  final bool isStory;
  const AddPost({super.key, required this.sellerProfil, required this.isStory});

  @override
  State<AddPost> createState() => _AddPostState();
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerSubtitle = TextEditingController();
  final TextEditingController _controllerAciklama = TextEditingController();
  bool isShareButton = false;
  late String _selectedPostType;
  Uint8List? _selectedImagePreview;
  Uint8List? _selectedImageData;
  String? _selectedImageName;
  bool _isSubmitting = false;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _selectedPostType = widget.isStory ? 'Hikaye' : 'Kampanya Hikayesi';
    _controllerTitle.addListener(_validateForm);
    _controllerSubtitle.addListener(_validateForm);
    _controllerAciklama.addListener(_validateForm);
  }

  void _validateForm() {
    final isStory = _selectedPostType == 'Hikaye';
    final hasDescription = _controllerAciklama.text.trim().length >= 4;
    final hasTitle = _controllerTitle.text.trim().length >= 3;
    final hasSubtitle = _controllerSubtitle.text.trim().length >= 3;
    final hasImage = _selectedImageData != null;

    String? message;
    if (!hasImage) {
      message = 'Lütfen görsel seçin.';
    } else if (!hasDescription) {
      message = 'Açıklama en az 4 karakter olmalıdır.';
    } else if (!isStory && !hasTitle) {
      message = 'Başlık en az 3 karakter olmalıdır.';
    } else if (!isStory && !hasSubtitle) {
      message = 'Alt başlık en az 3 karakter olmalıdır.';
    }

    final bool shouldEnable = message == null;

    if (shouldEnable != isShareButton || message != _validationMessage) {
      setState(() {
        isShareButton = shouldEnable;
        _validationMessage = message;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
        withData: true,
      );
      if (!mounted) return;
      if (result == null || result.files.isEmpty) return;
      final file = result.files.single;
      if (file.bytes == null) return;
      setState(() {
        _selectedImagePreview = file.bytes;
        _selectedImageData = file.bytes;
        _selectedImageName = file.name;
      });
      _validateForm();
    } catch (e) {
      debugPrint('Görsel seçilirken hata: $e');
    }
  }

  Future<void> _sharePost() async {
    if (!isShareButton || _isSubmitting) return;
    if (_selectedImageData == null) {
      if (!mounted) return;
      showTemporarySnackBar(
        context,
        'Lütfen bir görsel seçin.',
        type: SnackBarType.warning,
      );
      return;
    }

    final description = _controllerAciklama.text.trim();
    final isStories = _selectedPostType == 'Hikaye';
    final campaignType = isStories ? 'story' : 'campaign';

    http.MultipartFile _buildImageFile(String field) {
      return http.MultipartFile.fromBytes(
        field,
        _selectedImageData!,
        filename: _selectedImageName ?? '$field.jpg',
      );
    }

    late final Map<String, dynamic> payload;
    if (isStories) {
      payload = {
        //'title': _selectedPostType,
        //'subtitle': description,
        'description': description,
        //'titleSubtitleDescription': description,
        //'campaignType': campaignType,
        //'campaign_type': campaignType,
        'type': campaignType,
        //'banner': _buildImageFile('banner'),
        'photo': _buildImageFile('photo'),
      };
    } else {
      payload = {
        'title': _controllerTitle.text.trim(),
        'subtitle': _controllerSubtitle.text.trim(),
        'description': description,
        //'campaignType': campaignType,
        'campaign_type': "discount",
        'type': campaignType,
        'banner': _buildImageFile('banner'),
        //'photo': _buildImageFile('photo'),
      };
    }

    setState(() => _isSubmitting = true);
    try {
      await ApiService.postStories(payload, isStories: isStories);
      if (!mounted) return;
      showTemporarySnackBar(
        context,
        'Gönderi başarıyla oluşturuldu.',
        type: SnackBarType.success,
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showTemporarySnackBar(context, e.toString(), type: SnackBarType.error);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    // Controller'ı temizle
    _controllerTitle.dispose();
    _controllerSubtitle.dispose();
    _controllerAciklama.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _AddPostViewAppBar(context),
      body: _AddPostViewBody(
        context,
        _controllerTitle,
        _controllerSubtitle,
        _controllerAciklama,
        isShareButton,
        _selectedPostType,
        (val) {
          if (val == null) return;
          setState(() {
            _selectedPostType = val;
          });
          _validateForm();
        },
        _selectedImagePreview,
        _pickImage,
        _sharePost,
        _isSubmitting,
        _validationMessage,
      ),
    );
  }
}
