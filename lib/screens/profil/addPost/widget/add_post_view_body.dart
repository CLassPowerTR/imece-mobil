part of '../add_post_screen.dart';

const List<String> _postTypes = ['Kampanya Hikayesi', 'Hikaye'];

SingleChildScrollView _AddPostViewBody(
  BuildContext context,
  TextEditingController controllerTitle,
  TextEditingController controllerSubtitle,
  TextEditingController controllerAciklama,
  bool isShareButton,
  String selectedPostType,
  ValueChanged<String?> onPostTypeChanged,
  Uint8List? selectedImageBytes,
  VoidCallback onPickImage,
  VoidCallback onShare,
  bool isSubmitting,
  String? validationMessage,
) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  final themeData = HomeStyle(context: context);

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 10),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          _updateImage(
            context,
            width,
            height,
            themeData,
            selectedImageBytes,
            onPickImage,
          ),

          IgnorePointer(
            ignoring: true,
            child: Opacity(
              opacity: 0.6,
              child: DropdownBox(
                value: selectedPostType,
                items: _postTypes,
                onChanged: (_) {},
                label: 'Gönderi Türü',
              ),
            ),
          ),
          if (selectedPostType != 'Hikaye') ...[
            _textFieldTitle(context, controllerTitle, 'Başlık'),
            _textFieldTitle(context, controllerSubtitle, 'Alt Başlık'),
          ],
          _textFieldAciklama(
            height,
            context,
            themeData,
            controllerAciklama,
            width,
          ),
          _shareButton(
            context,
            isShareButton,
            isSubmitting,
            themeData,
            width,
            onShare,
            validationMessage,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        ],
      ),
    ),
  );
}

Align _shareButton(
  BuildContext context,
  bool isShareButton,
  bool isSubmitting,
  HomeStyle themeData,
  double width,
  VoidCallback onShare,
  String? validationMessage,
) {
  return Align(
    alignment: Alignment.topRight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 6,
      children: [
        if (validationMessage != null && !isShareButton && !isSubmitting)
          Text(
            validationMessage,
            style: TextStyle(color: themeData.error, fontSize: 12),
          ),
        textButton(
          context,
          isSubmitting ? 'Paylaşılıyor...' : 'Paylaş',
          elevation: isShareButton ? 6 : 0,
          buttonColor: isShareButton
              ? themeData.secondary
              : themeData.primary.withOpacity(0.3),
          shadowColor: themeData.secondary,
          minSizeWidth: width * 0.4,
          fontSize: themeData.bodyLarge.fontSize,
          weight: FontWeight.w600,
          onPressed: isShareButton && !isSubmitting ? onShare : null,
          icon: isSubmitting
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: themeData.onSecondary,
                    ),
                  ),
                )
              : null,
        ),
      ],
    ),
  );
}

SizedBox _textFieldAciklama(
  double height,
  BuildContext context,
  themeData,
  TextEditingController controllerAciklama,
  double width,
) {
  return SizedBox(
    height: height * 0.28,
    width: width,
    child: textField(
      context,
      controller: controllerAciklama,
      labelText: 'Açıklama',
      expands: true,
    ),
  );
}

Widget _textFieldTitle(
  BuildContext context,
  TextEditingController controller,
  String label,
) {
  return textField(
    context,
    controller: controller,
    labelText: label,
    minLines: 1,
    maxLines: 1,
  );
}

Widget _updateImage(
  BuildContext context,
  double width,
  double height,
  HomeStyle themeData,
  Uint8List? previewBytes,
  VoidCallback onPickImage,
) {
  return container(
    context,
    width: width,
    height: height * 0.4,
    isBoxShadow: true,
    borderRadius: BorderRadius.circular(12),
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 10),
    color: themeData.surfaceContainer,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        customText(
          'Gönderi Görseli',
          context,
          size: HomeStyle(context: context).bodyLarge.fontSize,
          weight: FontWeight.bold,
        ),
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            width: width,
            height: width * 0.45,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            alignment: Alignment.center,
            child: previewBytes == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        'Görsel Seç / Sürükle',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      previewBytes,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
        ),
        richText(
          maxLines: 3,
          context,
          children: [
            WidgetSpan(child: Text('• ')),
            TextSpan(text: '1:1 veya 4:5 oranında görseller önerilir.\n'),
            WidgetSpan(child: Text('• ')),
            TextSpan(text: 'PNG / JPG ve maksimum 5MB boyutunda olmalıdır.'),
          ],
        ),
      ],
    ),
  );
}
