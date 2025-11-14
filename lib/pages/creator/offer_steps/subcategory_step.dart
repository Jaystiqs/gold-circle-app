import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../utils/app_styles.dart';

class OfferSubcategoryStep extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String? selectedSubcategoryId;
  final Function(String, String) onSubcategorySelected;

  const OfferSubcategoryStep({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.selectedSubcategoryId,
    required this.onSubcategorySelected,
  });

  @override
  State<OfferSubcategoryStep> createState() => _OfferSubcategoryStepState();
}

class _OfferSubcategoryStepState extends State<OfferSubcategoryStep> {
  List<Subcategory> _subcategories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSubcategories();
  }

  Future<void> _loadSubcategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .collection('subcategories')
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      if (mounted) {
        setState(() {
          _subcategories = snapshot.docs
              .map((doc) => Subcategory.fromFirestore(doc))
              .toList();
          _isLoading = false;
        });

        // Debug logging
        print('Loaded ${_subcategories.length} subcategories for ${widget.categoryName}');
        for (var subcat in _subcategories) {
          print('Subcategory: ${subcat.displayName} (${subcat.id})');
        }
      }
    } catch (e) {
      print('Error loading subcategories: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  IconData _getSubcategoryIcon(String iconName) {
    const iconMap = {
      'identificationBadge': PhosphorIconsRegular.identificationBadge,
      'tShirt': PhosphorIconsRegular.tShirt,
      'paintBrush': PhosphorIconsRegular.paintBrush,
      'pencilCircle': PhosphorIconsRegular.pencilCircle,
      'devices': PhosphorIconsRegular.devices,
      'printer': PhosphorIconsRegular.printer,
      'cube': PhosphorIconsRegular.cube,
      'presentation': PhosphorIconsRegular.presentation,
      'globe': PhosphorIconsRegular.globe,
      'deviceMobile': PhosphorIconsRegular.deviceMobile,
      'terminal': PhosphorIconsRegular.terminal,
      'shoppingCart': PhosphorIconsRegular.shoppingCart,
      'code': PhosphorIconsRegular.code,
      'gameController': PhosphorIconsRegular.gameController,
      'plugsConnected': PhosphorIconsRegular.plugsConnected,
      'shareNetwork': PhosphorIconsRegular.shareNetwork,
      'camera': PhosphorIconsRegular.camera,
      'users': PhosphorIconsRegular.users,
      'filmStrip': PhosphorIconsRegular.filmStrip,
      'megaphone': PhosphorIconsRegular.megaphone,
      'target': PhosphorIconsRegular.target,
      'textAa': PhosphorIconsRegular.textAa,
      'briefcase': PhosphorIconsRegular.briefcase,
    };

    return iconMap[iconName] ?? PhosphorIconsRegular.briefcase;
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
              'Choose a specific service',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppStyles.textPrimary,
                letterSpacing: -0.5,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          if (_isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: CircularProgressIndicator(
                  color: AppStyles.goldPrimary,
                ),
              ),
            )
          else if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  children: [
                    Icon(
                      PhosphorIconsRegular.warningCircle,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading services',
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
                        _loadSubcategories();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.goldPrimary,
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
              ),
            )
          else if (_subcategories.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    children: [
                      Icon(
                        PhosphorIconsRegular.warningCircle,
                        size: 64,
                        color: AppStyles.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No services available',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppStyles.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _subcategories.length,
                itemBuilder: (context, index) {
                  final subcategory = _subcategories[index];
                  final isSelected = widget.selectedSubcategoryId == subcategory.id;

                  return SubcategoryCard(
                    subcategory: subcategory,
                    isSelected: isSelected,
                    icon: _getSubcategoryIcon(subcategory.icon),
                    onTap: () => widget.onSubcategorySelected(
                      subcategory.displayName,
                      subcategory.id,
                    ),
                  );
                },
              ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class SubcategoryCard extends StatelessWidget {
  final Subcategory subcategory;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const SubcategoryCard({
    super.key,
    required this.subcategory,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppStyles.backgroundGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? AppStyles.textPrimary
                      : AppStyles.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subcategory.displayName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppStyles.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Subcategory model
class Subcategory {
  final String id;
  final String name;
  final String displayName;
  final String icon;
  final String description;
  final bool isActive;
  final int sortOrder;

  Subcategory({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.description,
    required this.isActive,
    required this.sortOrder,
  });

  factory Subcategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Subcategory(
      id: doc.id,
      name: data['name'] ?? '',
      displayName: data['displayName'] ?? '',
      icon: data['icon'] ?? 'briefcase',
      description: data['description'] ?? '',
      isActive: data['isActive'] ?? true,
      sortOrder: data['sortOrder'] ?? 0,
    );
  }
}