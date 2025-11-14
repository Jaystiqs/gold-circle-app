import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/circular_timeline_selector.dart';

class OfferTimelineStep extends StatefulWidget {
  final int productionDays;
  final int deliveryDays;
  final int revisions;
  final Function(int) onProductionDaysChanged;
  final Function(int) onDeliveryDaysChanged;
  final Function(int) onRevisionsChanged;

  const OfferTimelineStep({
    super.key,
    required this.productionDays,
    required this.deliveryDays,
    required this.revisions,
    required this.onProductionDaysChanged,
    required this.onDeliveryDaysChanged,
    required this.onRevisionsChanged,
  });

  @override
  State<OfferTimelineStep> createState() => _OfferTimelineStepState();
}

class _OfferTimelineStepState extends State<OfferTimelineStep> {
  String _selectedCategory = 'Days'; // For production time

  void _showTimelineTipsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Timeline tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    PhosphorIconsRegular.x,
                    color: AppStyles.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTip(
              'Be realistic with timelines',
              'Account for revisions, communication, and unexpected delays',
            ),
            const SizedBox(height: 16),
            _buildTip(
              'Production time',
              'How long it takes you to complete the initial work',
            ),
            const SizedBox(height: 16),
            _buildTip(
              'Additional delivery time',
              'Extra time added after production for final touches and delivery',
            ),
            const SizedBox(height: 16),
            _buildTip(
              'Total timeline',
              'Production time + delivery time = total days to complete',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Set your timeline',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppStyles.textPrimary,
                height: 1.0,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'How long will it take to complete and deliver this service?',
              style: TextStyle(
                fontSize: 18,
                color: AppStyles.textSecondary,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // // Production Time Section
          // _buildSectionHeader(
          //   icon: PhosphorIconsRegular.hammer,
          //   title: 'Production time',
          //   description: 'Time to complete the work',
          // ),
          // const SizedBox(height: 24),

          // Category selector for production time
          SizedBox(
              width:500,
              child: _buildCategorySelector()
          ),
          const SizedBox(height: 24),

          // Circular selector for production time
          Center(
            child: CircularTimelineSelector(
              category: _selectedCategory,
              initialValue: widget.productionDays.toDouble(),
              onChanged: (value) {
                widget.onProductionDaysChanged(value.toInt());
              },
              activeColor: AppStyles.goldPrimary,
              inactiveColor: Colors.grey.shade300,
              thumbColor: Colors.white,
              centerBackgroundColor: Colors.white,
              size: 180,
            ),
          ),

          const SizedBox(height: 40),

          // Delivery Time Section
          _buildSectionHeader(
            icon: PhosphorIconsRegular.truck,
            title: 'Additional delivery time',
            description: 'Extra days after production',
          ),
          const SizedBox(height: 24),

          // Compact selector for delivery days
          _buildCompactSelector(
            value: widget.deliveryDays,
            minValue: 1,
            maxValue: 7,
            onChanged: widget.onDeliveryDaysChanged,
            unit: 'day',
          ),

          const SizedBox(height: 32),

          // Total Timeline Summary
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppStyles.goldPrimary.withOpacity(0.1),
                  AppStyles.goldPrimary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppStyles.goldPrimary.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  PhosphorIconsRegular.calendarCheck,
                  color: AppStyles.goldPrimary,
                  size: 32,
                ),
                const SizedBox(height: 16),
                Text(
                  'Total delivery time',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.productionDays + widget.deliveryDays}',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: AppStyles.textPrimary,
                    height: 1.0,
                  ),
                ),
                Text(
                  'days',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppStyles.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.productionDays} production + ${widget.deliveryDays} delivery',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppStyles.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: TextButton.icon(
              onPressed: () => _showTimelineTipsBottomSheet(context),
              icon: Icon(
                PhosphorIconsRegular.lightbulb,
                color: AppStyles.textPrimary,
                size: 18,
              ),
              label: Text(
                'Timeline tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppStyles.textPrimary,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Center(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppStyles.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    final categories = ['Days', 'Weeks', 'Months'];

    return Container(
      decoration: BoxDecoration(
        color: AppStyles.backgroundGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  category,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppStyles.textPrimary
                        : AppStyles.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompactSelector({
    required int value,
    required int minValue,
    required int maxValue,
    required Function(int) onChanged,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Decrease button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: value > minValue ? () => onChanged(value - 1) : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: value > minValue
                      ? AppStyles.backgroundGrey
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  PhosphorIconsRegular.minus,
                  color: value > minValue
                      ? AppStyles.textPrimary
                      : AppStyles.textLight,
                  size: 20,
                ),
              ),
            ),
          ),

          // Value display
          Expanded(
            child: Column(
              children: [
                Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppStyles.textPrimary,
                  ),
                ),
                Text(
                  value == 1 ? unit : '${unit}s',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppStyles.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Increase button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: value < maxValue ? () => onChanged(value + 1) : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: value < maxValue
                      ? AppStyles.backgroundGrey
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  PhosphorIconsRegular.plus,
                  color: value < maxValue
                      ? AppStyles.textPrimary
                      : AppStyles.textLight,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppStyles.backgroundGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppStyles.textPrimary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppStyles.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}