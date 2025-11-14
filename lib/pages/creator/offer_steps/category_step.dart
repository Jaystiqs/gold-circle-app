import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../utils/app_styles.dart';
import '../../../models/service_category.dart';

class OfferCategoryStep extends StatefulWidget {
  final String? selectedCategoryId;
  final Function(String, String) onCategorySelected;

  const OfferCategoryStep({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  State<OfferCategoryStep> createState() => _OfferCategoryStepState();
}

class _OfferCategoryStepState extends State<OfferCategoryStep> {
  List<ServiceCategory> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      if (mounted) {
        setState(() {
          _categories = snapshot.docs
              .map((doc) => ServiceCategory.fromFirestore(doc))
              .toList();
          _isLoading = false;
        });

        // Debug logging
        print('Loaded ${_categories.length} categories');
        for (var cat in _categories) {
          print('Category: ${cat.displayName} (${cat.id})');
        }
      }
    } catch (e) {
      print('Error loading categories: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  IconData _getCategoryIcon(String iconName) {
    const iconMap = {
      'paintBrush': PhosphorIconsRegular.paintBrush,
      'monitor': PhosphorIconsRegular.monitor,
      'devices': PhosphorIconsRegular.devices,
      'pencilCircle': PhosphorIconsRegular.pencilCircle,
      'cube': PhosphorIconsRegular.cube,
      'printer': PhosphorIconsRegular.printer,
      'tShirt': PhosphorIconsRegular.tShirt,
      'identificationBadge': PhosphorIconsRegular.identificationBadge,
      'globe': PhosphorIconsRegular.globe,
      'deviceMobile': PhosphorIconsRegular.deviceMobile,
      'terminal': PhosphorIconsRegular.terminal,
      'gameController': PhosphorIconsRegular.gameController,
      'database': PhosphorIconsRegular.database,
      'article': PhosphorIconsRegular.article,
      'megaphone': PhosphorIconsRegular.megaphone,
      'fileDoc': PhosphorIconsRegular.fileDoc,
      'feather': PhosphorIconsRegular.feather,
      'textAa': PhosphorIconsRegular.textAa,
      'handCoins': PhosphorIconsRegular.handCoins,
      'user': PhosphorIconsRegular.user,
      'chartLineUp': PhosphorIconsRegular.chartLineUp,
      'shareNetwork': PhosphorIconsRegular.shareNetwork,
      'envelope': PhosphorIconsRegular.envelope,
      'newspaper': PhosphorIconsRegular.newspaper,
      'users': PhosphorIconsRegular.users,
      'target': PhosphorIconsRegular.target,
      'filmStrip': PhosphorIconsRegular.filmStrip,
      'play': PhosphorIconsRegular.play,
      'camera': PhosphorIconsRegular.camera,
      'waveform': PhosphorIconsRegular.waveform,
      'microphone': PhosphorIconsRegular.microphone,
      'broadcast': PhosphorIconsRegular.broadcast,
      'briefcase': PhosphorIconsRegular.briefcase,
    };

    return iconMap[iconName] ?? PhosphorIconsRegular.briefcase;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      children: [
                        Text(
                          'What\'s your offer category?',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: AppStyles.textPrimary,
                            letterSpacing: -0.5,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Choose the category that describes your offer',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppStyles.textSecondary,
                            letterSpacing: -0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isLoading)
                              Padding(
                                padding: const EdgeInsets.all(48.0),
                                child: CircularProgressIndicator(
                                  color: AppStyles.textPrimary,
                                ),
                              )
                            else if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.all(48.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      PhosphorIconsRegular.warningCircle,
                                      size: 64,
                                      color: Colors.red.shade300,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error loading categories',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppStyles.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppStyles.textSecondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isLoading = true;
                                          _errorMessage = null;
                                        });
                                        _loadCategories();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppStyles.textPrimary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text(
                                        'Retry',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (_categories.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(48.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        PhosphorIconsRegular.warningCircle,
                                        size: 64,
                                        color: AppStyles.textSecondary,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No categories available',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: AppStyles.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Please contact support',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppStyles.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ..._categories.map((category) =>
                                    OfferCategoryCard(
                                      category: category,
                                      isSelected:
                                      widget.selectedCategoryId == category.id,
                                      getCategoryIcon: _getCategoryIcon,
                                      onTap: () => widget.onCategorySelected(
                                        category.displayName,
                                        category.id,
                                      ),
                                    )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OfferCategoryCard extends StatelessWidget {
  final ServiceCategory category;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData Function(String) getCategoryIcon;

  const OfferCategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.getCategoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
                color: isSelected
                    ? AppStyles.textPrimary
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  getCategoryIcon(category.icon),
                  size: 32,
                  color: isSelected
                      ? AppStyles.textPrimary
                      : AppStyles.textSecondary,
                ),
                const SizedBox(width: 16),
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
                          height: 1.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}