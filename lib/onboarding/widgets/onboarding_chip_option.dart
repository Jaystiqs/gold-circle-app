import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class OnboardingChipOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const OnboardingChipOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppStyles.goldPrimary
              : AppStyles.backgroundWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppStyles.goldPrimary : AppStyles.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppStyles.bodyMedium.copyWith(
            color: isSelected ? AppStyles.textWhite : AppStyles.textPrimary,
            fontWeight: isSelected ? AppStyles.semiBold : AppStyles.regular,
          ),
        ),
      ),
    );
  }
}