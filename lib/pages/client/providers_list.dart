import 'package:flutter/material.dart';
import 'package:goldcircle/pages/client/find_providers.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;
import '../../app_styles.dart';

// Provider data model
class Provider {
  final String id;
  final String name;
  final String profileImage;
  final double rating;
  final int reviewCount;
  final String location;
  final String description;
  final double startingPrice;
  final bool isVerified;
  final bool isOnline;
  final List<String> skills;
  final List<String> categories;
  final String responseTime;
  final int completedProjects;

  Provider({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.description,
    required this.startingPrice,
    required this.isVerified,
    required this.isOnline,
    required this.skills,
    required this.categories,
    required this.responseTime,
    required this.completedProjects,
  });

  factory Provider.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Provider(
      id: doc.id,
      name: data['name'] ?? '',
      profileImage: data['profileImage'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      startingPrice: (data['startingPrice'] ?? 0.0).toDouble(),
      isVerified: data['isVerified'] ?? false,
      isOnline: data['isOnline'] ?? false,
      skills: List<String>.from(data['skills'] ?? []),
      categories: List<String>.from(data['categories'] ?? []),
      responseTime: data['responseTime'] ?? 'within a day',
      completedProjects: data['completedProjects'] ?? 0,
    );
  }

  // Mock data factory for development
  factory Provider.mock(String categoryId, RangeValues budgetRange) {
    final random = math.Random();
    final names = [
      'Sarah Thompson', 'Mike Johnson', 'Priya Patel', 'James Wilson',
      'Anna Davis', 'Robert Chen', 'Maria Rodriguez', 'David Kim',
      'Lisa Anderson', 'Alex Parker', 'Jennifer Brown', 'Chris Taylor'
    ];

    final locations = [
      'Accra, Ghana', 'Cape Coast, Ghana', 'Kumasi, Ghana', 'Tamale, Ghana',
      'Takoradi, Ghana', 'Ho, Ghana', 'Koforidua, Ghana', 'Sunyani, Ghana'
    ];

    final responseTimes = ['within an hour', 'within 4 hours', 'within a day', 'within 2 days'];

    final skills = [
      'Photoshop', 'Illustrator', 'Figma', 'Sketch', 'InDesign', 'After Effects',
      'React', 'Flutter', 'WordPress', 'Shopify', 'HTML/CSS', 'JavaScript',
      'Content Writing', 'SEO', 'Social Media', 'Copywriting', 'Translation',
      'Video Editing', 'Animation', 'UI/UX Design', 'Branding', 'Logo Design'
    ];

    // Generate price within budget range
    final minPrice = budgetRange.start;
    final maxPrice = budgetRange.end;
    final price = minPrice + random.nextDouble() * (maxPrice - minPrice);

    return Provider(
      id: 'provider_${random.nextInt(10000)}',
      name: names[random.nextInt(names.length)],
      profileImage: 'https://api.dicebear.com/7.x/avataaars/png?seed=${random.nextInt(1000)}',
      rating: 3.5 + random.nextDouble() * 1.5, // 3.5 to 5.0
      reviewCount: random.nextInt(150) + 5,
      location: locations[random.nextInt(locations.length)],
      description: 'Experienced professional with ${random.nextInt(8) + 2} years in the field. Passionate about delivering quality work and exceeding client expectations.',
      startingPrice: price,
      isVerified: random.nextBool(),
      isOnline: random.nextDouble() > 0.3, // 70% chance of being online
      skills: (skills..shuffle()).take(random.nextInt(4) + 3).toList(),
      categories: [categoryId],
      responseTime: responseTimes[random.nextInt(responseTimes.length)],
      completedProjects: random.nextInt(200) + 10,
    );
  }
}

// Offer data model
class Offer {
  final String id;
  final String providerId;
  final String providerName;
  final String providerImage;
  final double providerRating;
  final int providerReviews;
  final bool isProviderVerified;
  final bool isProviderOnline;
  final String title;
  final String description;
  final List<String> features;
  final double price;
  final String timeline;
  final int orderCount;
  final String category;
  final List<String> tags;
  final String coverImage;
  final List<String> galleryImages;
  final bool isFeatured;
  final String revisions;

  Offer({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.providerImage,
    required this.providerRating,
    required this.providerReviews,
    required this.isProviderVerified,
    required this.isProviderOnline,
    required this.title,
    required this.description,
    required this.features,
    required this.price,
    required this.timeline,
    required this.orderCount,
    required this.category,
    required this.tags,
    required this.coverImage,
    required this.galleryImages,
    required this.isFeatured,
    required this.revisions,
  });

  factory Offer.mock(String categoryId, RangeValues budgetRange) {
    final random = math.Random();

    final providerNames = [
      'Sarah Thompson', 'Mike Johnson', 'Priya Patel', 'James Wilson',
      'Anna Davis', 'Robert Chen', 'Maria Rodriguez', 'David Kim',
      'Lisa Anderson', 'Alex Parker', 'Jennifer Brown', 'Chris Taylor'
    ];

    final offerTitles = {
      'design': [
        'Complete Brand Identity Package',
        'Professional Logo Design Suite',
        'Social Media Design Bundle',
        'Website UI/UX Design',
        'Print Design Collection',
        'Mobile App Interface Design',
        'Business Card & Stationery Set',
        'Marketing Materials Package'
      ],
      'development': [
        'Custom Website Development',
        'E-commerce Store Setup',
        'Mobile App Development',
        'WordPress Site Build',
        'Landing Page Creation',
        'Database Integration Service',
        'API Development Package',
        'Performance Optimization'
      ],
      'writing': [
        'Content Writing Package',
        'Blog Article Series',
        'Website Copy Bundle',
        'SEO Content Strategy',
        'Product Description Set',
        'Email Campaign Content',
        'Social Media Content Plan',
        'Technical Documentation'
      ],
      'marketing': [
        'Digital Marketing Strategy',
        'Social Media Management',
        'SEO Optimization Package',
        'PPC Campaign Setup',
        'Brand Strategy Development',
        'Market Research Report',
        'Competitor Analysis',
        'Growth Hacking Plan'
      ]
    };

    final features = {
      'design': [
        'Multiple concept variations',
        'Unlimited revisions',
        'High-resolution files',
        'Vector formats included',
        'Brand guidelines document',
        'Commercial usage rights',
        'Source files provided',
        'Color palette selection'
      ],
      'development': [
        'Responsive design',
        'Cross-browser compatibility',
        'Mobile optimization',
        'SEO-friendly structure',
        'Clean, documented code',
        'Testing & debugging',
        'Deployment assistance',
        'Performance optimization'
      ],
      'writing': [
        'SEO-optimized content',
        'Plagiarism-free guarantee',
        'Research included',
        'Multiple drafts',
        'Fast turnaround',
        'Keyword integration',
        'Engaging storytelling',
        'Brand voice consistency'
      ],
      'marketing': [
        'Strategic planning',
        'Market analysis',
        'Competitor research',
        'Target audience insights',
        'Campaign optimization',
        'Performance tracking',
        'Regular reporting',
        'Growth recommendations'
      ]
    };

    final timelines = ['2 days', '3 days', '5 days', '1 week', '2 weeks'];
    final revisionOptions = ['2 revisions', '3 revisions', '5 revisions', 'Unlimited revisions'];

    final categoryKey = categoryId.toLowerCase();
    final availableTitles = offerTitles[categoryKey] ?? offerTitles['design']!;
    final availableFeatures = features[categoryKey] ?? features['design']!;

    // Generate price within budget range
    final minPrice = budgetRange.start;
    final maxPrice = budgetRange.end;
    final price = minPrice + random.nextDouble() * (maxPrice - minPrice);

    final selectedFeatures = (availableFeatures..shuffle()).take(random.nextInt(3) + 3).toList();

    return Offer(
      id: 'offer_${random.nextInt(10000)}',
      providerId: 'provider_${random.nextInt(1000)}',
      providerName: providerNames[random.nextInt(providerNames.length)],
      providerImage: 'https://api.dicebear.com/7.x/avataaars/png?seed=${random.nextInt(1000)}',
      providerRating: 3.5 + random.nextDouble() * 1.5,
      providerReviews: random.nextInt(100) + 5,
      isProviderVerified: random.nextBool(),
      isProviderOnline: random.nextDouble() > 0.3,
      title: availableTitles[random.nextInt(availableTitles.length)],
      description: 'Professional ${categoryKey} service tailored to your specific needs. High-quality deliverables with attention to detail and industry best practices.',
      features: selectedFeatures,
      price: price,
      timeline: timelines[random.nextInt(timelines.length)],
      orderCount: random.nextInt(200) + 5,
      category: categoryId,
      tags: selectedFeatures.take(3).toList(),
      coverImage: 'https://picsum.photos/400/300?random=${random.nextInt(1000)}',
      galleryImages: List.generate(3, (index) => 'https://picsum.photos/400/300?random=${random.nextInt(1000)}'),
      isFeatured: random.nextDouble() > 0.8,
      revisions: revisionOptions[random.nextInt(revisionOptions.length)],
    );
  }
}

class ProvidersListPage extends StatefulWidget {
  final SearchCriteria searchCriteria;

  const ProvidersListPage({
    super.key,
    required this.searchCriteria,
  });

  @override
  State<ProvidersListPage> createState() => _ProvidersListPageState();
}

class _ProvidersListPageState extends State<ProvidersListPage> {
  List<Provider> _providers = [];
  List<Offer> _offers = [];
  bool _isLoading = true;
  String? _error;

  // Filter states
  String _sortBy = 'relevance'; // relevance, rating, price_low, price_high
  bool _onlineOnly = false;
  bool _verifiedOnly = false;
  RangeValues? _priceFilter;

  // Tab state
  int _selectedTabIndex = 0;

  // Pinned offers state
  Set<String> _pinnedOffers = {};

  // Pinned providers state
  Set<String> _pinnedProviders = {};

  @override
  void initState() {
    super.initState();
    _priceFilter = widget.searchCriteria.budgetRange;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // In a real app, you'd query Firestore based on search criteria
      // For now, generate mock data
      await Future.delayed(const Duration(milliseconds: 1500)); // Simulate network delay

      final mockProviders = List.generate(
        15 + math.Random().nextInt(10), // 15-25 providers
            (index) => Provider.mock(
          widget.searchCriteria.selectedCategoryId,
          widget.searchCriteria.budgetRange,
        ),
      );

      final mockOffers = List.generate(
        12 + math.Random().nextInt(8), // 12-20 offers
            (index) => Offer.mock(
          widget.searchCriteria.selectedCategoryId,
          widget.searchCriteria.budgetRange,
        ),
      );

      setState(() {
        _providers = mockProviders;
        _offers = mockOffers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  List<Provider> get filteredAndSortedProviders {
    var filtered = _providers.where((provider) {
      // Apply filters
      if (_onlineOnly && !provider.isOnline) return false;
      if (_verifiedOnly && !provider.isVerified) return false;
      if (_priceFilter != null) {
        if (provider.startingPrice < _priceFilter!.start ||
            provider.startingPrice > _priceFilter!.end) return false;
      }
      return true;
    }).toList();

    // Apply sorting
    switch (_sortBy) {
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.startingPrice.compareTo(a.startingPrice));
        break;
      case 'relevance':
      default:
      // Keep original order (relevance/AI ranking)
        break;
    }

    return filtered;
  }

  List<Offer> get filteredAndSortedOffers {
    var filtered = _offers.where((offer) {
      // Apply filters
      if (_onlineOnly && !offer.isProviderOnline) return false;
      if (_verifiedOnly && !offer.isProviderVerified) return false;
      if (_priceFilter != null) {
        if (offer.price < _priceFilter!.start ||
            offer.price > _priceFilter!.end) return false;
      }
      return true;
    }).toList();

    // Apply sorting
    switch (_sortBy) {
      case 'rating':
        filtered.sort((a, b) => b.providerRating.compareTo(a.providerRating));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'relevance':
      default:
      // Sort featured offers first, then by order count
        filtered.sort((a, b) {
          if (a.isFeatured && !b.isFeatured) return -1;
          if (!a.isFeatured && b.isFeatured) return 1;
          return b.orderCount.compareTo(a.orderCount);
        });
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:130.0),
              child: Column(
                children: [
                  Expanded(
                    child: _selectedTabIndex == 0 ? _buildOffersTab() : _buildProvidersTab(),
                  ),
                ],
              ),
            ),
            _buildUnifiedHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildUnifiedHeader() {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section
          Container(
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
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.searchCriteria.selectedCategory,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${widget.searchCriteria.selectedBudget} · ${widget.searchCriteria.selectedTimeline}',
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
                  onTap: _showFiltersBottomSheet,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      PhosphorIconsRegular.slidersHorizontal,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab bar section (seamlessly connected)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabItem('Offers', 0),
                const SizedBox(width: 40),
                _buildTabItem('Providers', 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.black : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildProvidersTab() {
    return _buildProvidersContent();
  }

  Widget _buildOffersTab() {
    return _buildOffersContent();
  }

  Widget _buildProvidersContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (filteredAndSortedProviders.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20,),
      itemCount: filteredAndSortedProviders.length,
      itemBuilder: (context, index) {
        return _buildProviderCard(filteredAndSortedProviders[index]);
      },
    );
  }

  Widget _buildOffersContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (filteredAndSortedOffers.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20,),
      itemCount: filteredAndSortedOffers.length,
      itemBuilder: (context, index) {
        return _buildOfferCard(filteredAndSortedOffers[index]);
      },
    );
  }

  Widget _buildOfferCard(Offer offer) {
    final isPinned = _pinnedOffers.contains(offer.id);

    return GestureDetector(
      onTap: () {
        // Handle offer tap
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image with save button
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      offer.coverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            PhosphorIconsRegular.image,
                            color: Colors.grey.shade400,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Save button (thumbtack)
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => _toggleOfferPin(offer.id),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Fill layer (underneath)
                        Icon(
                          PhosphorIconsFill.pushPin,
                          size: 24,
                          color: isPinned ? AppStyles.goldPrimary : Colors.black54,
                        ),
                        // Outline layer (on top)
                        Icon(
                          PhosphorIconsRegular.pushPin,
                          size: 24,
                          color: isPinned ? AppStyles.goldPrimary : Colors.white, // White outline for visibility on image
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  offer.title,
                  style: AppStyles.h4.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppStyles.textPrimary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Rating or "New offer"
                Row(
                  children: [
                    if (offer.orderCount > 0) ...[
                      Icon(
                        PhosphorIconsFill.star,
                        size: 12,
                        color: AppStyles.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${offer.providerRating.toStringAsFixed(1)} (${offer.providerReviews})',
                        style: AppStyles.h4.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'New offer',
                        style: AppStyles.h4.copyWith(
                          fontSize: 14,
                          color: AppStyles.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'delivery in ${offer.timeline}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Price
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _formatPrice(offer.price),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _selectedTabIndex == 0
                ? 'Finding the best providers for you...'
                : 'Loading available offers...',
            style: TextStyle(
              fontSize: 16,
              color: AppStyles.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a moment',
            style: TextStyle(
              fontSize: 14,
              color: AppStyles.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsRegular.warning,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              _selectedTabIndex == 0 ? 'Error loading providers' : 'Error loading offers',
              style: AppStyles.h3.copyWith(
                color: AppStyles.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(
                fontSize: 14,
                color: AppStyles.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.goldPrimary,
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _selectedTabIndex == 0
                  ? PhosphorIconsRegular.magnifyingGlass
                  : PhosphorIconsRegular.tag,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              _selectedTabIndex == 0 ? 'No providers found' : 'No offers found',
              style: AppStyles.h3.copyWith(
                color: AppStyles.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your filters or search criteria',
              style: TextStyle(
                fontSize: 14,
                color: AppStyles.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _onlineOnly = false;
                  _verifiedOnly = false;
                  _priceFilter = widget.searchCriteria.budgetRange;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.goldPrimary,
              ),
              child: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard(Provider provider) {
    final isPinned = _pinnedProviders.contains(provider.id);

    return GestureDetector(
      onTap: () {
        // Handle provider tap - go to profile
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Provider info row
                  Row(
                    children: [
                      // Profile image
                      Stack(
                        children: [
                          Container(
                            width: 78, // Outer container for gold border
                            height: 78,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  AppStyles.goldPrimary,
                                  AppStyles.goldPrimary.withOpacity(0.8),
                                  AppStyles.goldPrimary,
                                ],
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(4), // Space for gold border
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white, // White border background
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(3), // Space for white border
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade100,
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    provider.profileImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        PhosphorIconsRegular.user,
                                        color: Colors.grey.shade400,
                                        size: 24,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Online status indicator
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: provider.isOnline ? Colors.green : Colors.red,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 16),

                      // Name and details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name with verification
                            Row(
                              children: [
                                Text(
                                  provider.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                if (provider.isVerified) ...[
                                  const SizedBox(width: 6),
                                  Icon(
                                    PhosphorIconsRegular.checkCircle,
                                    size: 14,
                                    color: AppStyles.goldPrimary,
                                  ),
                                ],
                              ],
                            ),

                            const SizedBox(height: 2),

                            // Rating and location
                            Row(
                              children: [
                                Icon(PhosphorIcons.star(),
                                  size: 16,),
                                Text(
                                  ' ${provider.rating.toStringAsFixed(1)} (${provider.reviewCount})',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppStyles.textBlack,
                                  ),
                                ),
                              ],
                            ),

                            Text(
                              'responds ${provider.responseTime}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Divider line
                  Divider(
                    color: Colors.grey.shade200,
                    thickness: 1,
                    height: 1,
                  ),

                  const SizedBox(height: 20),

                  // Skills or description - minimal
                  if (provider.skills.isNotEmpty)
                    Text(
                      provider.skills.take(3).join(' · '),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      provider.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 26),

                  // // Bottom row - message button and price
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Text(
                  //           "from ",
                  //           style: AppStyles.bodyLarge.copyWith(
                  //               color: AppStyles.textSecondary,
                  //             letterSpacing: -0.5
                  //           ),
                  //         ),
                  //         Text(
                  //           "${_formatPrice(provider.startingPrice)}",
                  //           style: AppStyles.h4.copyWith(
                  //               color: AppStyles.textPrimary,
                  //               letterSpacing: -0.5
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     GestureDetector(
                  //       onTap: () {
                  //         _onMessageProvider(provider);
                  //       },
                  //       child: Container(
                  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.grey.shade300),
                  //           borderRadius: BorderRadius.circular(8),
                  //         ),
                  //         child: Text(
                  //           'Send Message',
                  //           style: TextStyle(
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.w500,
                  //             color: Colors.grey.shade700,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // Bottom row - price and action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price
                      Row(
                        children: [
                          Text(
                            "from ",
                            style: AppStyles.bodyLarge.copyWith(
                                color: AppStyles.textSecondary,
                                letterSpacing: -0.5
                            ),
                          ),
                          Text(
                            _formatPrice(provider.startingPrice),
                            style: AppStyles.h4.copyWith(
                                color: AppStyles.textPrimary,
                                letterSpacing: -0.5
                            ),
                          ),
                        ],
                      ),

                      // Action buttons
                      Row(
                        children: [
                          // Send Message button
                          GestureDetector(
                            onTap: () {
                              _onMessageProvider(provider);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Message',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Hire button
                          GestureDetector(
                            onTap: () {
                              // _onHireProvider(provider);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppStyles.goldPrimary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Hire',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Pin button positioned at top right
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => _toggleProviderPin(provider.id),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Fill layer (underneath)
                    Icon(
                      PhosphorIconsFill.pushPin,
                      size: 24,
                      color: isPinned ? AppStyles.goldPrimary : Colors.black12,
                    ),
                    // Outline layer (on top)
                    Icon(
                      PhosphorIconsRegular.pushPin,
                      size: 24,
                      color: isPinned ? AppStyles.goldPrimary : AppStyles.textPrimary.withOpacity(0.9), // Always dark outline
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add this method to handle message functionality
  void _onMessageProvider(Provider provider) {
    // Navigate to chat/message screen
    // Example:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ChatScreen(provider: provider),
    //   ),
    // );
  }

  void _toggleProviderPin(String providerId) {
    setState(() {
      if (_pinnedProviders.contains(providerId)) {
        _pinnedProviders.remove(providerId);
      } else {
        _pinnedProviders.add(providerId);
      }
    });
  }

  void _toggleOfferPin(String offerId) {
    setState(() {
      if (_pinnedOffers.contains(offerId)) {
        _pinnedOffers.remove(offerId);
      } else {
        _pinnedOffers.add(offerId);
      }
    });
  }

  String _formatPrice(double price) {
    // if (price >= 1000) {
    //   return 'GH₵${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}K';
    // }
    return 'GH₵${price.toStringAsFixed(0)}';
  }

  Widget _buildSortOption(String value, String label) {
    final isSelected = _sortBy == value;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppStyles.goldPrimary : AppStyles.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? Icon(PhosphorIconsRegular.check, color: AppStyles.goldPrimary)
          : null,
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _onlineOnly = false;
                            _verifiedOnly = false;
                            _priceFilter = widget.searchCriteria.budgetRange;
                          });
                        },
                        child: Text(
                          'Clear all',
                          style: TextStyle(color: AppStyles.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Online status filter
                  SwitchListTile(
                    title: Text(
                      'Online now',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppStyles.textPrimary,
                      ),
                    ),
                    subtitle: Text(_selectedTabIndex == 0
                        ? 'Show only providers currently online'
                        : 'Show only offers from providers currently online'),
                    value: _onlineOnly,
                    onChanged: (value) {
                      setModalState(() {
                        _onlineOnly = value;
                      });
                    },
                    activeColor: AppStyles.goldPrimary,
                  ),

                  // Verified filter
                  SwitchListTile(
                    title: Text(
                      'Verified only',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppStyles.textPrimary,
                      ),
                    ),
                    subtitle: Text(_selectedTabIndex == 0
                        ? 'Show only verified providers'
                        : 'Show only offers from verified providers'),
                    value: _verifiedOnly,
                    onChanged: (value) {
                      setModalState(() {
                        _verifiedOnly = value;
                      });
                    },
                    activeColor: AppStyles.goldPrimary,
                  ),

                  const SizedBox(height: 20),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {}); // Apply filters to main state
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.goldPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }
}