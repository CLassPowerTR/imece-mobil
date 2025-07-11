import 'package:flutter/material.dart';

/// Kullanımı:
/// DropdownBox(
///   value: seciliDeger,
///   items: ['A', 'B', 'C'],
///   onChanged: (val) { ... },
///   label: 'Adres Tipi',
/// )
class DropdownBox extends StatelessWidget {
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String label;
  final String Function(String)? itemLabelBuilder;

  const DropdownBox({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
    this.itemLabelBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    final onSecondary = Theme.of(context).colorScheme.onSecondary;
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).colorScheme.surface,
        // Açılan menüdeki yazı rengi ve seçili item arka planı için
        splashColor: secondary.withOpacity(0.1),
        highlightColor: secondary.withOpacity(0.15),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        isDense: true,
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: secondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: secondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: secondary, width: 1),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: items
            .map((tip) => DropdownMenuItem(
                  value: tip,
                  child: Builder(
                    builder: (context) {
                      final isSelected = value == tip;
                      final label = itemLabelBuilder != null
                          ? itemLabelBuilder!(tip)
                          : tip;
                      return Container(
                        decoration: isSelected
                            ? BoxDecoration(
                                color: secondary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              )
                            : null,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: secondary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        icon: Icon(Icons.arrow_drop_down, color: secondary),
        dropdownColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
