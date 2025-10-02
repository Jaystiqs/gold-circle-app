import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../app_styles.dart';

class ProvidersListPage extends StatefulWidget {
  final String selectedService;
  final String selectedBudget;
  final String selectedTimeline;

  const ProvidersListPage({
    super.key,
    required this.selectedService,
    required this.selectedBudget,
    required this.selectedTimeline,
  });

  @override
  State<ProvidersListPage> createState() => _ProvidersListPageState();
}

class _ProvidersListPageState extends State<ProvidersListPage> {
  String _sortBy = 'Recommended';

  // Filter states
  bool _verifiedFilter = false;
  bool _fastResponseFilter = false;
  bool _topRatedFilter = false;

  String _providerType = 'Any type';

  double _minPrice = 200;
  double _maxPrice = 5000;

  String _experienceLevel = 'Any level';

  final List<Map<String, dynamic>> providers = [
    {
      'name': 'Kwame Photography',
      'service': 'Photography',
      'rating': 4.9,
      'reviews': 127,
      'price': 'GH₵800',
      'location': 'Accra, Greater Accra',
      'speciality': 'Wedding & Portrait Photography',
      'availability': 'Available this week',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'isVerified': true,
      'responseTime': '2 hours',
      'completedJobs': 89,
    },
    {
      'name': 'Ama\'s Design Studio',
      'service': 'Graphic Design',
      'rating': 5.0,
      'reviews': 94,
      'price': 'GH₵600',
      'location': 'Kumasi, Ashanti',
      'speciality': 'Brand Identity & Logo Design',
      'availability': 'Available today',
      'image': 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=400',
      'isVerified': true,
      'responseTime': '1 hour',
      'completedJobs': 156,
    },
    {
      'name': 'TechFlow Solutions',
      'service': 'Web Development',
      'rating': 4.8,
      'reviews': 203,
      'price': 'GH₵2,500',
      'location': 'Accra, Greater Accra',
      'speciality': 'Full-stack Web Applications',
      'availability': 'Available in 2 days',
      'image': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      'isVerified': true,
      'responseTime': '3 hours',
      'completedJobs': 67,
    },
    {
      'name': 'Creative Mind Studios',
      'service': 'Video Editing',
      'rating': 4.7,
      'reviews': 82,
      'price': 'GH₵1,200',
      'location': 'Takoradi, Western',
      'speciality': 'Corporate & Social Media Videos',
      'availability': 'Available this week',
      'image': 'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=400',
      'isVerified': false,
      'responseTime': '4 hours',
      'completedJobs': 43,
    },
    {
      'name': 'WordCraft Ghana',
      'service': 'Writing',
      'rating': 4.9,
      'reviews': 156,
      'price': 'GH₵400',
      'location': 'Accra, Greater Accra',
      'speciality': 'Content Writing & Copywriting',
      'availability': 'Available today',
      'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      'isVerified': true,
      'responseTime': '1 hour',
      'completedJobs': 234,
    },
    {
      'name': 'Digital Marketing Pro',
      'service': 'Marketing',
      'rating': 4.6,
      'reviews': 118,
      'price': 'GH₵1,800',
      'location': 'Cape Coast, Central',
      'speciality': 'Social Media & SEO Marketing',
      'availability': 'Available in 3 days',
      'image': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400',
      'isVerified': true,
      'responseTime': '2 hours',
      'completedJobs': 91,
    },
  ];

  List<Map<String, dynamic>> get filteredProviders {
    // Filter by selected service if applicable
    if (widget.selectedService != 'All Services') {
      return providers.where((provider) =>
      provider['service'] == widget.selectedService).toList();
    }
    return providers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildResultsAndFiltersBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filteredProviders.length,
                itemBuilder: (context, index) {
                  return _buildOfferCard(filteredProviders[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back arrow
          IconButton(
            icon: Icon(PhosphorIconsRegular.arrowLeft, size: 24, color: Colors.black),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),

          // Search parameters container (Airbnb style)
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context), // Go back to search
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Changed from .start to .center
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.selectedService,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.selectedBudget} · ${widget.selectedTimeline}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Filter icon
          GestureDetector(
            onTap: _showFilterDialog,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                PhosphorIconsRegular.slidersHorizontal,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsAndFiltersBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results count
          Text(
            '${filteredProviders.length} providers available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppStyles.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          // const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label) {
    final isSelected = _sortBy == label;
    return GestureDetector(
      onTap: () => setState(() => _sortBy = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppStyles.goldPrimary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppStyles.goldPrimary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.black : AppStyles.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Provider Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Icon(
                      PhosphorIconsRegular.user,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              // Heart icon
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    PhosphorIconsRegular.heart,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              // Verified badge
              if (provider['isVerified'])
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppStyles.goldPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(PhosphorIconsRegular.checkCircle, size: 12, color: Colors.black),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Provider Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        provider['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.textPrimary,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(PhosphorIconsRegular.star, size: 16, color: AppStyles.goldPrimary),
                        const SizedBox(width: 4),
                        Text(
                          '${provider['rating']} (${provider['reviews']})',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppStyles.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Speciality
                Text(
                  provider['speciality'],
                  style: TextStyle(
                    fontSize: 14,
                    color: AppStyles.textSecondary,
                  ),
                ),

                const SizedBox(height: 8),

                // Location and Availability
                Row(
                  children: [
                    Icon(PhosphorIconsRegular.mapPin, size: 14, color: AppStyles.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      provider['location'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppStyles.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        provider['availability'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Stats Row
                Row(
                  children: [
                    _buildStatItem(PhosphorIconsRegular.clock, 'Response: ${provider['responseTime']}'),
                    const SizedBox(width: 16),
                    _buildStatItem(PhosphorIconsRegular.checkCircle, '${provider['completedJobs']} completed'),
                  ],
                ),

                const SizedBox(height: 16),

                // Price and Contact Button
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Starting from',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppStyles.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${provider['price']}/project',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppStyles.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to provider profile or contact
                        _showContactDialog(provider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.goldPrimary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Contact',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppStyles.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: AppStyles.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppStyles.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      PhosphorIconsRegular.x,
                      size: 24,
                      color: AppStyles.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recommended for you
                    _buildRecommendedSection(),
                    const SizedBox(height: 32),

                    // Provider type
                    _buildProviderTypeSection(),
                    const SizedBox(height: 32),

                    // Price range
                    _buildPriceRangeSection(),
                    const SizedBox(height: 32),

                    // Experience level
                    _buildExperienceLevelSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Clear all filters
                        setState(() {
                          _sortBy = 'Recommended';
                          _verifiedFilter = false;
                          _fastResponseFilter = false;
                          _topRatedFilter = false;
                          _providerType = 'Any type';
                          _minPrice = 200;
                          _maxPrice = 5000;
                          _experienceLevel = 'Any level';
                        });
                      },
                      child: Text(
                        'Clear all',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.textPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Show ${filteredProviders.length} providers',
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
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended for you',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppStyles.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildRecommendedFilter('Verified', PhosphorIconsRegular.checkCircle, _verifiedFilter, () {
              setState(() => _verifiedFilter = !_verifiedFilter);
            })),
            const SizedBox(width: 12),
            Expanded(child: _buildRecommendedFilter('Fast Response', PhosphorIconsRegular.lightning, _fastResponseFilter, () {
              setState(() => _fastResponseFilter = !_fastResponseFilter);
            })),
            const SizedBox(width: 12),
            Expanded(child: _buildRecommendedFilter('Top Rated', PhosphorIconsRegular.star, _topRatedFilter, () {
              setState(() => _topRatedFilter = !_topRatedFilter);
            })),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendedFilter(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppStyles.goldPrimary.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppStyles.goldPrimary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppStyles.goldPrimary : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? Colors.black : AppStyles.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: AppStyles.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Provider type',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppStyles.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildProviderTypeChip('Any type', _providerType == 'Any type')),
            const SizedBox(width: 12),
            Expanded(child: _buildProviderTypeChip('Individual', _providerType == 'Individual')),
            const SizedBox(width: 12),
            Expanded(child: _buildProviderTypeChip('Agency', _providerType == 'Agency')),
          ],
        ),
      ],
    );
  }

  Widget _buildProviderTypeChip(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _providerType = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppStyles.textPrimary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppStyles.textPrimary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppStyles.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price range',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppStyles.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Project rate, includes all fees',
          style: TextStyle(
            fontSize: 14,
            color: AppStyles.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // Price histogram (simplified representation)
        Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(20, (index) {
              final heights = [20, 35, 45, 60, 70, 75, 65, 55, 50, 45, 40, 35, 30, 25, 20, 15, 12, 10, 8, 5];
              return Container(
                width: 8,
                height: heights[index].toDouble(),
                decoration: BoxDecoration(
                  color: AppStyles.goldPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 24),

        // Price range inputs
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minimum',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppStyles.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'GH₵200',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppStyles.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maximum',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppStyles.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'GH₵5,000',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppStyles.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExperienceLevelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience level',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppStyles.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            _buildExperienceOption('Any level'),
            _buildExperienceOption('Entry level (0-2 years)'),
            _buildExperienceOption('Intermediate (2-5 years)'),
            _buildExperienceOption('Expert (5+ years)'),
          ],
        ),
      ],
    );
  }

  Widget _buildExperienceOption(String title) {
    bool isSelected = title == _experienceLevel;
    return GestureDetector(
      onTap: () {
        setState(() {
          _experienceLevel = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppStyles.textPrimary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppStyles.textPrimary : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? AppStyles.textPrimary : Colors.white,
              ),
              child: isSelected
                  ? Icon(PhosphorIconsRegular.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppStyles.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(Map<String, dynamic> provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Contact ${provider['name']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppStyles.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening chat with ${provider['name']}...')),
                      );
                    },
                    icon: Icon(PhosphorIconsRegular.chatCircle),
                    label: Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.goldPrimary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${provider['name']}...')),
                      );
                    },
                    icon: Icon(PhosphorIconsRegular.phone),
                    label: Text('Call'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: AppStyles.goldPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}