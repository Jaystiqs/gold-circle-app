import 'package:flutter/material.dart';
import '../../../utils/app_styles.dart';
import 'service_category.dart';

class CategoryStep extends StatelessWidget {
  final List<ServiceCategory> categories;
  final bool isLoading;
  final String? selectedCategoryId;
  final Function(String, String) onCategorySelected;
  final IconData Function(String) getCategoryIcon;

  const CategoryStep({
    super.key,
    required this.categories,
    required this.isLoading,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.getCategoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    final parentCategories =
    categories.where((c) => c.isParentCategory).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What category best describes your task?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppStyles.textPrimary,
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 48),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ...parentCategories.map((category) => CategoryCard(
              category: category,
              isSelected: selectedCategoryId == category.id,
              getCategoryIcon: getCategoryIcon,
              onTap: () => onCategorySelected(
                category.displayName,
                category.id,
              ),
            )),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final ServiceCategory category;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData Function(String) getCategoryIcon;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.getCategoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color:
                isSelected ? AppStyles.textPrimary : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppStyles.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  getCategoryIcon(category.icon),
                  size: 32,
                  color: isSelected ? AppStyles.textPrimary : Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}