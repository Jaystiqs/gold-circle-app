import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';
import '../../utils/custom_toolbar.dart';
import 'client_creators_list.dart';
import 'client_find_creators.dart';

class ClientChooseSubcategories extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryDisplayName;

  const ClientChooseSubcategories({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryDisplayName,
  }) : super(key: key);

  @override
  State<ClientChooseSubcategories> createState() =>
      _ClientChooseSubcategoriesState();
}

class _ClientChooseSubcategoriesState
    extends State<ClientChooseSubcategories> {
  List<SubcategoryData> _subcategories = [];
  bool _isLoading = true;

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

      setState(() {
        _subcategories = snapshot.docs.map((doc) {
          final data = doc.data();
          return SubcategoryData(
            id: doc.id,
            name: data['name'] ?? '',
            displayName: data['displayName'] ?? '',
            icon: data['icon'] ?? '',
            description: data['description'] ?? '',
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading subcategories: $e');
      setState(() {
        _isLoading = false;
      });
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
    };
    return iconMap[iconName] ?? PhosphorIconsRegular.briefcase;
  }

  Color _getIconColor(int index) {
    final colors = [
      AppStyles.goldPrimary,
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEC4899), // Pink
      const Color(0xFFEF4444), // Red
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF10B981), // Emerald
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF14B8A6), // Teal
    ];
    return colors[index % colors.length];
  }

  void _navigateToCreatorsList(SubcategoryData subcategory) {
    // Create search criteria with default "any budget" and "any timeline"
    final searchCriteria = SearchCriteria(
      selectedCategory: subcategory.displayName,
      selectedCategoryId: subcategory.id,
      selectedBudget: 'GHS100 - GHS20,000+', // Full range
      budgetRange: const RangeValues(100, 20000), // Full budget range
      selectedTimeline: 'Flexible', // Flexible timeline
      timelineCategory: 'Days',
      timelineValue: 7.0, // Default 7 days if needed
      projectDescription: null,
      searchQuery: null,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatorsListPage(searchCriteria: searchCriteria),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            CustomToolbar(
              title: widget.categoryDisplayName,
              showBackButton: false,
              rightAction: IconButton(
                  icon: Icon(PhosphorIcons.x()),
                  onPressed: () => {
                    Navigator.of(context).pop()
                  }
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
                  ),
                ),
              )
                  : _subcategories.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.magnifyingGlass(),
                      size: 64,
                      color: AppStyles.textLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No subcategories available',
                      style: AppStyles.bodyLarge.copyWith(
                        color: AppStyles.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
                  : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'Choose a service',
                      //   style: AppStyles.h4.copyWith(
                      //     color: AppStyles.textPrimary,
                      //     fontWeight: AppStyles.medium,
                      //   ),
                      // ),
                      // const SizedBox(height: 8),
                      // Text(
                      //   'Select the specific service you need',
                      //   style: AppStyles.bodyMedium.copyWith(
                      //     color: AppStyles.textSecondary,
                      //   ),
                      // ),
                      // const SizedBox(height: 24),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _subcategories.length,
                        itemBuilder: (context, index) {
                          final subcategory = _subcategories[index];
                          return _buildSubcategoryCard(subcategory, index);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryCard(SubcategoryData subcategory, int index) {
    final iconColor = _getIconColor(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _navigateToCreatorsList(subcategory);
          },
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppStyles.backgroundWhite,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: AppStyles.textLight.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Icon(
                        _getSubcategoryIcon(subcategory.icon),
                        size: 32,
                        color: iconColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subcategory.displayName,
                          style: AppStyles.bodyLarge.copyWith(
                            color: AppStyles.textPrimary,
                            fontWeight: AppStyles.semiBold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          subcategory.description,
                          style: AppStyles.bodyMedium.copyWith(
                            color: AppStyles.textSecondary,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Icon(
                    PhosphorIcons.caretRight(),
                    color: AppStyles.textSecondary,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Subcategory Data Model
class SubcategoryData {
  final String id;
  final String name;
  final String displayName;
  final String icon;
  final String description;

  SubcategoryData({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.description,
  });
}