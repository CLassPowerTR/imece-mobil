import 'package:flutter/material.dart';
import 'package:imecehub/core/constants/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final List<Map<String, Object>> categories;
  final Map<String, List<String>> subcategories;
  final String? selectedCategoryName;
  final String? selectedSubcategoryName;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onSubcategoryChanged;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.subcategories,
    required this.selectedCategoryName,
    required this.selectedSubcategoryName,
    required this.onCategoryChanged,
    required this.onSubcategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> categoryNames =
        categories.map((e) => e['ad']!.toString()).toList();
    final List<String> availableSubcats = selectedCategoryName != null
        ? (subcategories[selectedCategoryName!] ?? const <String>[])
        : const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: 'Kategori',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.secondary(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.secondary(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.secondary(context)),
            ),
          ),
          value: selectedCategoryName,
          items: categoryNames
              .map((name) => DropdownMenuItem<String>(
                    value: name,
                    child: Text(name),
                  ))
              .toList(),
          onChanged: (val) => onCategoryChanged(val),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: 'Alt Kategori',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.secondary(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.secondary(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: AppColors.secondary(context)),
            ),
          ),
          value: availableSubcats.contains(selectedSubcategoryName)
              ? selectedSubcategoryName
              : null,
          items: availableSubcats
              .map((name) => DropdownMenuItem<String>(
                    value: name,
                    child: Text(name),
                  ))
              .toList(),
          onChanged: (val) => onSubcategoryChanged(val),
        ),
      ],
    );
  }
}
