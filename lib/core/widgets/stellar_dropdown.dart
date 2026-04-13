import 'package:demo_task/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StellarDropdownOption<T> {
  const StellarDropdownOption({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

class StellarDropdownField<T> extends StatelessWidget {
  const StellarDropdownField({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.fieldKey,
    this.selectedSuffix = 'Current',
    this.disabledSuffix = 'Locked',
    this.fillColor = Colors.white,
  });

  final Key? fieldKey;
  final T value;
  final List<StellarDropdownOption<T>> options;
  final ValueChanged<T?> onChanged;
  final String selectedSuffix;
  final String disabledSuffix;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      key: fieldKey,
      value: value,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppTheme.secondary,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.4),
        ),
      ),
      items: options.map((option) {
        final isSelected = option.value == value;

        return DropdownMenuItem<T>(
          value: option.value,
          enabled: option.enabled,
          child: Opacity(
            opacity: option.enabled ? 1 : 0.45,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isSelected
                      ? '${option.label} ($selectedSuffix)'
                      : option.enabled
                      ? option.label
                      : '${option.label} ($disabledSuffix)',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
