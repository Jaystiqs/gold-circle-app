import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../app_styles.dart';
import '../client/find_providers.dart';

// Category data model based on your Firestore structure
class ServiceCategory {
  final String id;
  final String name;
  final String displayName;
  final String icon;
  final String description;
  final String? parentId;
  final bool isActive;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.description,
    this.parentId,
    required this.isActive,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceCategory(
      id: data['id'] ?? doc.id,
      name: data['name'] ?? '',
      displayName: data['displayName'] ?? '',
      icon: data['icon'] ?? '',
      description: data['description'] ?? '',
      parentId: data['parentId'],
      isActive: data['isActive'] ?? true,
      sortOrder: data['sortOrder'] ?? 0,
      createdAt: data['createdAt']?.toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  bool get isParentCategory => parentId == null;
  bool get isSubCategory => parentId != null;
}

class ServicesListPage extends StatefulWidget {
  const ServicesListPage({super.key});

  @override
  State<ServicesListPage> createState() => _ServicesListPageState();
}

class _ServicesListPageState extends State<ServicesListPage> {
  // Firestore data
  List<ServiceCategory> _categories = [];
  bool _isLoadingData = true;
  String? _dataError;

  // Search functionality
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingData = true;
      _dataError = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      _categories = snapshot.docs.map((doc) => ServiceCategory.fromFirestore(doc)).toList();

      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingData = false;
          _dataError = 'Failed to load categories: $e';
        });
      }
      print('Error loading categories: $e');
    }
  }

  // Map category icon strings to Phosphor icons
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

  // Map category icon strings to colors
  Color _getCategoryColor(String iconName) {
    const colorMap = {
      'paintBrush': Color(0xFF8B5CF6), // Purple
      'monitor': Color(0xFF3B82F6), // Blue
      'devices': Color(0xFF06B6D4), // Cyan
      'pencilCircle': Color(0xFF10B981), // Emerald
      'cube': Color(0xFF84CC16), // Lime
      'printer': Color(0xFF6366F1), // Indigo
      'tShirt': Color(0xFFEC4899), // Pink
      'identificationBadge': Color(0xFFF59E0B), // Amber
      'globe': Color(0xFF14B8A6), // Teal
      'deviceMobile': Color(0xFF8B5CF6), // Purple
      'terminal': Color(0xFF374151), // Gray
      'gameController': Color(0xFFEF4444), // Red
      'database': Color(0xFF059669), // Emerald
      'article': Color(0xFF7C3AED), // Violet
      'megaphone': Color(0xFFDC2626), // Red
      'fileDoc': Color(0xFF2563EB), // Blue
      'feather': Color(0xFF0891B2), // Sky
      'textAa': Color(0xFF7C2D12), // Orange
      'handCoins': Color(0xFF059669), // Emerald
      'user': Color(0xFF7C3AED), // Violet
      'chartLineUp': Color(0xFF16A34A), // Green
      'shareNetwork': Color(0xFF2563EB), // Blue
      'envelope': Color(0xFFDC2626), // Red
      'newspaper': Color(0xFF374151), // Gray
      'users': Color(0xFF8B5CF6), // Purple
      'target': Color(0xFFEF4444), // Red
      'filmStrip': Color(0xFFDC2626), // Red
      'play': Color(0xFFEF4444), // Red
      'camera': Color(0xFF8B5CF6), // Purple
      'waveform': Color(0xFF06B6D4), // Cyan
      'microphone': Color(0xFF10B981), // Emerald
      'broadcast': Color(0xFFEF4444), // Red
      'briefcase': Color(0xFF374151), // Gray (default)
    };

    return colorMap[iconName] ?? const Color(0xFF374151);
  }

  List<ServiceCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return _categories;
    }

    return _categories.where((category) {
      return category.displayName.toLowerCase().contains(_searchQuery) ||
          category.description.toLowerCase().contains(_searchQuery) ||
          category.name.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Error state
    if (_dataError != null) {
      return Scaffold(
        backgroundColor: AppStyles.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          PhosphorIcons.warning(),
                          size: 64,
                          color: AppStyles.textLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading categories',
                          style: AppStyles.h4.copyWith(color: AppStyles.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _dataError!,
                          style: AppStyles.bodyMedium.copyWith(color: AppStyles.textLight),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadCategories,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppStyles.goldPrimary,
                          ),
                          child: const Text('Retry'),
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

    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildCategoriesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 16.0, 16.0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back,
                  color: AppStyles.textPrimary,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  'Services',
                  style: AppStyles.h1.copyWith(
                    color: AppStyles.textPrimary,
                    fontWeight: AppStyles.bold,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isSearchActive ? PhosphorIcons.x() : PhosphorIcons.magnifyingGlass(),
                  color: AppStyles.textPrimary,
                ),
                onPressed: _toggleSearch,
              ),
            ],
          ),
          if (_isSearchActive) ...[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppStyles.backgroundGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: AppStyles.bodyMedium.copyWith(color: AppStyles.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search services...',
                  hintStyle: AppStyles.bodyMedium.copyWith(color: AppStyles.textLight),
                  prefixIcon: Icon(
                    PhosphorIcons.magnifyingGlass(),
                    color: AppStyles.textLight,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    // Loading state
    if (_isLoadingData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading categories...',
                style: AppStyles.bodyMedium.copyWith(color: AppStyles.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final filteredCategories = _filteredCategories;

    // Empty state
    if (filteredCategories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _searchQuery.isNotEmpty ? PhosphorIcons.magnifyingGlass() : PhosphorIcons.folder(),
                size: 64,
                color: AppStyles.textLight,
              ),
              const SizedBox(height: 16),
              Text(
                _searchQuery.isNotEmpty ? 'No results found' : 'No categories found',
                style: AppStyles.h4.copyWith(color: AppStyles.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                _searchQuery.isNotEmpty
                    ? 'Try searching with different keywords'
                    : 'No categories match the current filter',
                style: AppStyles.bodyMedium.copyWith(color: AppStyles.textLight),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Categories list
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredCategories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return _buildCategoryTile(category);
      },
    );
  }

  Widget _buildCategoryTile(ServiceCategory category) {
    final categoryColor = _getCategoryColor(category.icon);

    return InkWell(
      onTap: () {
        // Navigate to providers in this category or category detail page
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                _getCategoryIcon(category.icon),
                color: categoryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Category Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.displayName,
                          style: AppStyles.bodyLarge.copyWith(
                            fontWeight: AppStyles.semiBold,
                            color: AppStyles.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (category.isSubCategory)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppStyles.textLight.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Sub',
                            style: AppStyles.bodySmall.copyWith(
                              color: AppStyles.textLight,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.description,
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppStyles.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}