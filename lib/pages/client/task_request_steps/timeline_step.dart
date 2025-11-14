import 'package:flutter/material.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/circular_timeline_selector.dart';

class TimelineStep extends StatelessWidget {
  final String selectedCategory;
  final double currentValue;
  final Function(String) onCategoryChanged;
  final Function(double) onValueChanged;

  const TimelineStep({
    super.key,
    required this.selectedCategory,
    required this.currentValue,
    required this.onCategoryChanged,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['Days', 'Weeks', 'Months'];
    final selectedIndex = categories.indexOf(selectedCategory);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When do you need this completed?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppStyles.textPrimary,
              height: 1.0,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set a realistic timeline for your project',
            style: AppStyles.bodyMedium.copyWith(
              color: AppStyles.textSecondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                // Category toggle
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTimelineToggle(
                    categories,
                    selectedIndex,
                    onCategoryChanged,
                  ),
                ),
                const SizedBox(height: 40),
                // Circular timeline selector
                CircularTimelineSelector(
                  key: ValueKey(selectedCategory),
                  category: selectedCategory,
                  initialValue: currentValue,
                  activeColor: AppStyles.goldPrimary,
                  inactiveColor: Colors.grey.shade300,
                  thumbColor: Colors.white,
                  size: 200.0,
                  onChanged: onValueChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineToggle(
      List<String> categories,
      int selectedIndex,
      Function(String) onCategoryChanged,
      ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / 3;

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: itemWidth * selectedIndex + 4,
                top: 4,
                bottom: 4,
                width: itemWidth - 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: categories.asMap().entries.map((entry) {
                  final category = entry.value;
                  final isSelected = selectedCategory == category;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onCategoryChanged(category),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? AppStyles.textPrimary
                                : AppStyles.textSecondary,
                          ),
                          child: Text(
                            category,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}