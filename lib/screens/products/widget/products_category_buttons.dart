
part of '../products_screen.dart';

class ProductsCategoryButtons extends StatefulWidget {
  final dynamic items;
  final int index;

  const ProductsCategoryButtons(
      {super.key, required this.items, required this.index});

  @override
  State<ProductsCategoryButtons> createState() =>
      _ProductsCategoryButtonsState();
}

class _ProductsCategoryButtonsState extends State<ProductsCategoryButtons> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    Color filterButtonOnColor =
        AppColors.secondary(context).withOpacity(0.15);
    return TextButton.icon(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) => _isSelected
                ? filterButtonOnColor
                : AppColors.surface(context),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Kenar yumuşaklığı
              side: BorderSide(
                color: _isSelected
                    ? AppColors.secondary(context)
                    : AppColors.outline(context), // Çizgi rengi
                width: 1, // Çizgi kalınlığı
              ),
            ),
          ),
          iconSize: WidgetStateProperty.all(25),
          textStyle: WidgetStateProperty.all<TextStyle>(
            TextStyle(
                fontSize: AppTextStyle.bodyLarge(context).fontSize,
                color: AppColors.primary(context)),
          ),
          iconColor: WidgetStateProperty.all<Color>(
              AppColors.secondary(context))),
      icon: widget.items['icon'],
      label: Text(widget.items['name']),
      onPressed: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
    );
  }
}
