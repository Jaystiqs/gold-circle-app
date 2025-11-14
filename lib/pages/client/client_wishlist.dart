import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Services', 'Products', 'Jobs'];

  bool _isLoading = false;
  List<Map<String, dynamic>> _wishlistItems = [];
  String _searchQuery = '';
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadWishlist() async {
    setState(() => _isLoading = true);

    try {
      // Load wishlist items based on selected filter
      // For now, using mock data
      _wishlistItems = _getMockWishlistItems();

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading wishlist: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _getMockWishlistItems() {
    // Mock wishlist items
    if (_selectedFilterIndex == 0) {
      // All items
      return [
        {
          'id': '1',
          'title': 'Premium Logo Design Package',
          'description': 'Professional logo design with unlimited revisions and brand guidelines included.',
          'provider': 'Sarah Johnson',
          'providerImage': 'https://avatar.iran.liara.run/public/girl',
          'price': 1500.0,
          'rating': 4.9,
          'reviews': 127,
          'category': 'Services',
          'type': 'Graphic Design',
          'image': 'https://images.unsplash.com/photo-1626785774573-4b799315345d?w=400',
          'savedDate': DateTime.now().subtract(const Duration(days: 2)),
          'isAvailable': true,
        },
        {
          'id': '2',
          'title': 'Modern Desk Lamp',
          'description': 'Minimalist LED desk lamp with adjustable brightness and USB charging port.',
          'provider': 'HomeStyle Co.',
          'providerImage': 'https://avatar.iran.liara.run/public/boy',
          'price': 250.0,
          'rating': 4.7,
          'reviews': 89,
          'category': 'Products',
          'type': 'Home & Office',
          'image': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=400',
          'savedDate': DateTime.now().subtract(const Duration(days: 5)),
          'isAvailable': true,
        },
        {
          'id': '3',
          'title': 'E-commerce Website Development',
          'description': 'Full-stack development of a responsive e-commerce platform with payment integration.',
          'provider': 'Michael Chen',
          'providerImage': 'https://avatar.iran.liara.run/public/boy',
          'price': 5000.0,
          'rating': 5.0,
          'reviews': 43,
          'category': 'Services',
          'type': 'Web Development',
          'image': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400',
          'savedDate': DateTime.now().subtract(const Duration(hours: 12)),
          'isAvailable': true,
        },
        {
          'id': '4',
          'title': 'Wireless Noise-Canceling Headphones',
          'description': 'Premium over-ear headphones with active noise cancellation and 30-hour battery life.',
          'provider': 'TechGear Store',
          'providerImage': 'https://avatar.iran.liara.run/public/girl',
          'price': 450.0,
          'rating': 4.8,
          'reviews': 234,
          'category': 'Products',
          'type': 'Electronics',
          'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
          'savedDate': DateTime.now().subtract(const Duration(days: 1)),
          'isAvailable': false,
        },
        {
          'id': '5',
          'title': 'Social Media Management',
          'description': 'Complete social media management for 3 platforms including content creation and analytics.',
          'provider': 'Emily Davis',
          'providerImage': 'https://avatar.iran.liara.run/public/girl',
          'price': 800.0,
          'rating': 4.6,
          'reviews': 56,
          'category': 'Services',
          'type': 'Digital Marketing',
          'image': 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=400',
          'savedDate': DateTime.now().subtract(const Duration(days: 7)),
          'isAvailable': true,
        },
        {
          'id': '6',
          'title': 'Ergonomic Office Chair',
          'description': 'Premium mesh office chair with lumbar support and adjustable armrests.',
          'provider': 'Workspace Pro',
          'providerImage': 'https://avatar.iran.liara.run/public/boy',
          'price': 650.0,
          'rating': 4.9,
          'reviews': 178,
          'category': 'Products',
          'type': 'Furniture',
          'image': 'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=400',
          'savedDate': DateTime.now().subtract(const Duration(days: 3)),
          'isAvailable': true,
        },
      ];
    } else if (_selectedFilterIndex == 1) {
      // Services
      return [
        {
          'id': '1',
          'title': 'Premium Logo Design Package',
          'description': 'Professional logo design with unlimited revisions and brand guidelines included.',
          'provider': 'Sarah Johnson',
          'providerImage': 'https://avatar.iran.liara.run/public/girl',
          'price': 1500.0,
          'rating': 4.9,
          'reviews': 127,
          'category': 'Services',
          'type': 'Graphic Design',
          'image': 'https://images.unsplash.com/photo-1626785774573-4b799315345d?w=400',
          'savedDate': DateTime.now().subtract(const Duration(days: 2)),
          'isAvailable': true,
        },
        {
          'id': '3',
          'title': 'E-commerce Website Development',
          'description': 'Full-stack development of a responsive e-commerce platform with payment integration.',
          'provider': 'Michael Chen',
          'providerImage': 'https://avatar.iran.liara.run/public/boy',
          'price': 5000.0,
          'rating': 5.0,
          'reviews': 43,
          'category': 'Services',
          'type': 'Web Development',
          'image': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400',
          'savedDate': DateTime.now().subtract(const Duration(hours: 12)),
          'isAvailable': true,
        },
        {
          'id': '5',
          'title': 'Social Media Management',
          'description': 'Complete social media management for 3 platforms including content creation and analytics.',
          'provider': 'Emily Davis',
          'providerImage': 'https://avatar.iran.liara.run/public/girl',
          'price': 800.0,
          'rating': 4.6,
          'reviews': 56,
          'category': 'Services',
          'type': 'Digital Marketing',
          'image': 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=400',
          'savedDate': DateTime.now().subtract(const Duration(days: 7)),
          'isAvailable': true,
        },
      ];
    } else if (_selectedFilterIndex == 2) {
      // Products
      return [
        {
          'id': '2',
          'title': 'Modern Desk Lamp',
          'description': 'Minimalist LED desk lamp with adjustable brightness and USB charging port.',
          'provider': 'HomeStyle Co.',
          'providerImage': 'https://avatar.iran.liara.run/public/boy',
          'price': 250.0,
          'rating': 4.7,
          'reviews': 89,
          'category': 'Products',
          'type': 'Home & Office',
          'image': 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=400',
          'savedDate': DateTime.now().subtract(const Duration(days: 5)),
          'isAvailable': true,
        },
        {
          'id': '4',
          'title': 'Wireless Noise-Canceling Headphones',
          'description': 'Premium over-ear headphones with active noise cancellation and 30-hour battery life.',
          'provider': 'TechGear Store',
          'providerImage': 'https://avatar.iran.liara.run/public/girl',
          'price': 450.0,
          'rating': 4.8,
          'reviews': 234,
          'category': 'Products',
          'type': 'Electronics',
          'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
          'savedDate': DateTime.now().subtract(const Duration(days: 1)),
          'isAvailable': false,
        },
        {
          'id': '6',
          'title': 'Ergonomic Office Chair',
          'description': 'Premium mesh office chair with lumbar support and adjustable armrests.',
          'provider': 'Workspace Pro',
          'providerImage': 'https://avatar.iran.liara.run/public/boy',
          'price': 650.0,
          'rating': 4.9,
          'reviews': 178,
          'category': 'Products',
          'type': 'Furniture',
          'image': 'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=400',
          'savedDate': DateTime.now().subtract(const Duration(days: 3)),
          'isAvailable': true,
        },
      ];
    }
    return [];
  }

  List<Map<String, dynamic>> get filteredItems {
    if (_searchQuery.isEmpty) return _wishlistItems;

    return _wishlistItems.where((item) {
      final title = (item['title'] as String? ?? '').toLowerCase();
      final description = (item['description'] as String? ?? '').toLowerCase();
      final type = (item['type'] as String? ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();

      return title.contains(query) ||
          description.contains(query) ||
          type.contains(query);
    }).toList();
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  Future<void> _removeFromWishlist(String itemId) async {
    setState(() {
      _wishlistItems.removeWhere((item) => item['id'] == itemId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Removed from wishlist'),
        backgroundColor: AppStyles.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppStyles.goldPrimary,
          onPressed: () {
            _loadWishlist();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.magnifyingGlass(),
              size: 80,
              color: AppStyles.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: AppStyles.h5.copyWith(
                color: AppStyles.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search',
              style: AppStyles.bodyMedium.copyWith(
                color: AppStyles.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.heart(),
            size: 80,
            color: AppStyles.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: AppStyles.h5.copyWith(
              color: AppStyles.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Items you save will appear here',
            style: AppStyles.bodyMedium.copyWith(
              color: AppStyles.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close search when tapping anywhere
        if (_isSearchExpanded) {
          setState(() {
            _isSearchExpanded = false;
            _searchController.clear();
            _searchQuery = '';
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppStyles.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              if (!_isSearchExpanded) _buildHeader(),
              if (_isSearchExpanded) _buildExpandedSearchBar(),
              if (!_isSearchExpanded) _buildFilterTabs(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadWishlist,
                  color: AppStyles.goldPrimary,
                  child: _isLoading
                      ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
                      strokeWidth: 2,
                    ),
                  )
                      : _buildWishlistGrid(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 16.0, 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Wishlists',
              style: AppStyles.h1.copyWith(
                color: AppStyles.textPrimary,
                fontWeight: AppStyles.bold,
                letterSpacing: -1.5,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              PhosphorIcons.magnifyingGlass(),
              color: AppStyles.textPrimary,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isSearchExpanded = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppStyles.backgroundGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppStyles.textLight.withOpacity(0.3),
          ),
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          style: AppStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Search wishlist...',
            hintStyle: AppStyles.bodyLarge.copyWith(
              color: AppStyles.textLight,
            ),
            prefixIcon: Icon(
              PhosphorIcons.magnifyingGlass(),
              color: AppStyles.textLight,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                PhosphorIcons.x(),
                color: AppStyles.textLight,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isSearchExpanded = false;
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.asMap().entries.map((entry) {
            final index = entry.key;
            final filter = entry.value;
            final isSelected = index == _selectedFilterIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                  _loadWishlist();
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppStyles.textPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? AppStyles.textPrimary : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppStyles.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildWishlistGrid() {
    final items = filteredItems;

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildWishlistCard(item);
      },
    );
  }

  Widget _buildWishlistCard(Map<String, dynamic> item) {
    final rating = (item['rating'] as num?)?.toDouble() ?? 0.0;
    final reviews = item['reviews'] as int? ?? 0;
    final isAvailable = item['isAvailable'] as bool? ?? true;
    final savedDate = item['savedDate'] as DateTime?;

    return GestureDetector(
      onTap: () {
        _showItemDetails(item);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppStyles.backgroundGrey,
              ),
              child: item['providerImage'] != null
                  ? ClipOval(
                child: Image.network(
                  item['providerImage'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      PhosphorIcons.user(),
                      color: AppStyles.textLight,
                      size: 24,
                    );
                  },
                ),
              )
                  : Icon(
                PhosphorIcons.user(),
                color: AppStyles.textLight,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item title
                  Text(
                    item['title'] ?? 'Item Title',
                    style: AppStyles.bodyLarge.copyWith(
                      fontWeight: AppStyles.semiBold,
                      color: AppStyles.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Provider and category
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['provider'] ?? 'Provider',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppStyles.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: AppStyles.bodySmall.copyWith(
                          color: AppStyles.textLight,
                        ),
                      ),
                      Text(
                        item['type'] ?? '',
                        style: AppStyles.bodySmall.copyWith(
                          color: AppStyles.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Rating and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            PhosphorIcons.star(),
                            size: 12,
                            color: AppStyles.goldPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: AppStyles.bodySmall.copyWith(
                              color: AppStyles.textPrimary,
                              fontWeight: AppStyles.semiBold,
                            ),
                          ),
                          Text(
                            ' ($reviews)',
                            style: AppStyles.bodySmall.copyWith(
                              color: AppStyles.textLight,
                            ),
                          ),
                          if (!isAvailable) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Unavailable',
                                style: AppStyles.bodySmall.copyWith(
                                  color: Colors.red,
                                  fontSize: 11,
                                  fontWeight: AppStyles.medium,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        'GHS${item['price']?.toStringAsFixed(0) ?? '0'}',
                        style: AppStyles.bodyLarge.copyWith(
                          fontWeight: AppStyles.bold,
                          color: AppStyles.goldPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Heart icon
            GestureDetector(
              onTap: () {
                _removeFromWishlist(item['id']);
              },
              child: Icon(
                PhosphorIcons.heartStraight(),
                color: Colors.red,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetails(Map<String, dynamic> item) {
    final rating = (item['rating'] as num?)?.toDouble() ?? 0.0;
    final reviews = item['reviews'] as int? ?? 0;
    final isAvailable = item['isAvailable'] as bool? ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item['title'] ?? 'Item Title',
                                style: AppStyles.h3.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _removeFromWishlist(item['id']);
                                Navigator.pop(context);
                              },
                              child: Icon(
                                PhosphorIcons.heartStraight(),
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons.star(),
                              size: 16,
                              color: AppStyles.goldPrimary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppStyles.textPrimary,
                              ),
                            ),
                            Text(
                              ' ($reviews reviews)',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppStyles.textSecondary,
                              ),
                            ),
                            if (!isAvailable) ...[
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Unavailable',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppStyles.backgroundGrey,
                                ),
                                child: item['providerImage'] != null
                                    ? ClipOval(
                                  child: Image.network(
                                    item['providerImage'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        PhosphorIcons.user(),
                                        color: AppStyles.textLight,
                                      );
                                    },
                                  ),
                                )
                                    : Icon(PhosphorIcons.user(), color: AppStyles.textLight),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['provider'] ?? 'Provider',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      item['type'] ?? '',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppStyles.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'GHS${item['price']?.toStringAsFixed(0) ?? '0'}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppStyles.goldPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['description'] ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppStyles.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isAvailable
                                ? () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item['category']} order functionality coming soon'),
                                  backgroundColor: AppStyles.textPrimary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.goldPrimary,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              isAvailable ? 'Order Now' : 'Currently Unavailable',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}