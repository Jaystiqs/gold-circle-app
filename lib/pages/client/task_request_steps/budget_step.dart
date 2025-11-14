import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/custom_smooth_slider.dart';

class BudgetStep extends StatelessWidget {
  final RangeValues budgetRange;
  final Function(RangeValues) onBudgetChanged;

  static const double minBudget = 100;
  static const double maxBudget = 20000;

  final List<Map<String, dynamic>> commonBudgetRanges = const [
    {'label': 'Under GHS500', 'min': 100.0, 'max': 500.0},
    {'label': 'GHS500-1K', 'min': 500.0, 'max': 1000.0},
    {'label': 'GHS1K-3K', 'min': 1000.0, 'max': 3000.0},
    {'label': 'GHS3K-5K', 'min': 3000.0, 'max': 5000.0},
    {'label': 'GHS5K-10K', 'min': 5000.0, 'max': 10000.0},
    {'label': 'GHS10K+', 'min': 10000.0, 'max': 20000.0},
    {'label': 'Any Price', 'min': 100.0, 'max': 20000.0},
  ];

  const BudgetStep({
    super.key,
    required this.budgetRange,
    required this.onBudgetChanged,
  });

  void _showEditBottomSheet(
      BuildContext context,
      bool isMinimum,
      double currentValue,
      ) {
    final TextEditingController controller = TextEditingController(
      text: currentValue.toInt().toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Edit ${isMinimum ? 'Minimum' : 'Maximum'} Budget',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Enter amount in GHS',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppStyles.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Text Field
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textPrimary,
                    letterSpacing: -0.5,
                  ),
                  decoration: InputDecoration(
                    prefixText: 'GHS ',
                    prefixStyle: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppStyles.textSecondary,
                      letterSpacing: -0.5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppStyles.goldPrimary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppStyles.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final value = double.tryParse(controller.text);
                          if (value != null) {
                            double newMin = budgetRange.start;
                            double newMax = budgetRange.end;

                            if (isMinimum) {
                              // Validate minimum
                              if (value < minBudget) {
                                newMin = minBudget;
                              } else if (value > budgetRange.end) {
                                newMin = budgetRange.end;
                              } else {
                                newMin = value;
                              }
                            } else {
                              // Validate maximum
                              if (value > maxBudget) {
                                newMax = maxBudget;
                              } else if (value < budgetRange.start) {
                                newMax = budgetRange.start;
                              } else {
                                newMax = value;
                              }
                            }

                            onBudgetChanged(RangeValues(newMin, newMax));
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.goldPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What\'s your budget?',
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
              'Pricing, includes all fees',
              style: TextStyle(
                fontSize: 18,
                color: AppStyles.textSecondary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 48),

            // Smooth Range Slider
            SmoothRangeSlider(
              min: minBudget,
              max: maxBudget,
              values: budgetRange,
              activeColor: AppStyles.goldPrimary,
              inactiveColor: Colors.grey.shade300,
              thumbColor: Colors.white,
              thumbBorderColor: Colors.grey.shade400,
              thumbRadius: 15,
              thumbBorderWidth: 1.5,
              trackHeight: 3,
              useNonLinearScale: true,
              scalePower: 2.5,
              onChanged: onBudgetChanged,
            ),

            const SizedBox(height: 16),

            // Min/Max Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Minimum',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppStyles.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Maximum',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppStyles.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Budget Display Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBudgetDisplayCard(
                  context,
                  budgetRange.start.toCurrency(),
                  true,
                  budgetRange.start,
                ),
                const SizedBox(width: 20),
                _buildBudgetDisplayCard(
                  context,
                  budgetRange.end >= maxBudget
                      ? '${budgetRange.end.toCurrency()}+'
                      : budgetRange.end.toCurrency(),
                  false,
                  budgetRange.end,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Suggested Ranges Title
            Text(
              'Suggested ranges',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppStyles.textPrimary,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 12),

            // Suggested Range Chips in Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: commonBudgetRanges.length,
              itemBuilder: (context, index) {
                final range = commonBudgetRanges[index];
                final isSelected = budgetRange.start == range['min'] &&
                    budgetRange.end == range['max'];

                return GestureDetector(
                  onTap: () {
                    onBudgetChanged(RangeValues(range['min'], range['max']));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppStyles.blackMedium : Colors.grey.shade300,
                        width: isSelected ? 2 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        range['label'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.blackMedium,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetDisplayCard(
      BuildContext context,
      String value,
      bool isMinimum,
      double currentValue,
      ) {
    return GestureDetector(
      onTap: () => _showEditBottomSheet(context, isMinimum, currentValue),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppStyles.borderMedium, width: 0.8),
        ),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppStyles.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}