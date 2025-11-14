import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';

class CreatorOfferPage extends StatefulWidget {
  final String offerId;
  final String providerId;

  const CreatorOfferPage({
    super.key,
    required this.offerId,
    required this.providerId,
  });

  @override
  State<CreatorOfferPage> createState() => _CreatorOfferPageState();
}

class _CreatorOfferPageState extends State<CreatorOfferPage> {
  bool _isSaved = false;

  // Mock offer data - UGC Content Creation
  final _offer = OfferDetailData(
    id: '1',
    title: 'UGC Content Package - Premium',
    description: 'Authentic user-generated content that converts! I\'ll create engaging, relatable content for your brand that resonates with your target audience. Perfect for social media ads, organic posts, and marketing campaigns. My content style is natural, trustworthy, and designed to drive engagement and sales.',
    price: 850,
    originalPrice: 1200,
    duration: '3-5 days',
    deliveryTime: '5-7 days',
    revisions: 3,
    category: 'UGC Content Creation',
    images: [
      'https://placehold.co/600x400/f0f0f0/cccccc?text=UGC+Sample+1',
      'https://placehold.co/600x400/e8e8e8/999999?text=UGC+Sample+2',
      'https://placehold.co/600x400/f5f5f5/aaaaaa?text=UGC+Sample+3',
      'https://placehold.co/600x400/ececec/bbbbbb?text=UGC+Sample+4',
    ],
    includes: [
      OfferInclude(
        icon: PhosphorIcons.videoCamera(),
        title: '5 High-Quality Videos',
        description: '15-30 second videos perfect for TikTok, Reels & ads',
      ),
      OfferInclude(
        icon: PhosphorIcons.image(),
        title: '10 Static Images',
        description: 'Professional lifestyle photos with your product',
      ),
      OfferInclude(
        icon: PhosphorIcons.textAa(),
        title: 'Hook Scripts Included',
        description: 'Attention-grabbing opening lines for each video',
      ),
      OfferInclude(
        icon: PhosphorIcons.fileText(),
        title: 'Usage Rights',
        description: 'Full commercial rights for ads and organic posts',
      ),
      OfferInclude(
        icon: PhosphorIcons.shootingStar(),
        title: 'Multiple Angles',
        description: 'Various shots and perspectives for each concept',
      ),
      OfferInclude(
        icon: PhosphorIcons.chatCircle(),
        title: 'Brand Strategy Call',
        description: 'Pre-production call to align on brand voice',
      ),
    ],
    addOns: [
      AddOn(
        id: '1',
        title: 'Rush Delivery',
        description: 'Get your content in 2-3 days',
        price: 200,
      ),
      AddOn(
        id: '2',
        title: 'Extra Videos (3x)',
        description: 'Three additional 15-30 second videos',
        price: 300,
      ),
      AddOn(
        id: '3',
        title: 'Testimonial Style Video',
        description: 'Authentic review-style content (60 seconds)',
        price: 250,
      ),
      AddOn(
        id: '4',
        title: 'Trending Audio Edit',
        description: 'Content edited with viral trending sounds',
        price: 150,
      ),
    ],
    faqs: [
      FAQ(
        question: 'What products do you create content for?',
        answer: 'I create UGC for beauty, skincare, fashion, lifestyle, tech gadgets, food & beverage, and home products. If you have something else, just reach out and we can discuss!',
      ),
      FAQ(
        question: 'Do I need to ship the product to you?',
        answer: 'Yes, you\'ll need to ship the product to me for authentic hands-on content. I\'m based in Accra, Ghana. Alternatively, I can purchase it locally if available and invoice you.',
      ),
      FAQ(
        question: 'Can I use the content for paid ads?',
        answer: 'Absolutely! All content comes with full commercial usage rights, perfect for Facebook Ads, Instagram Ads, TikTok Ads, and any other marketing channels.',
      ),
      FAQ(
        question: 'What\'s your content style?',
        answer: 'My style is authentic, relatable, and conversational - like a friend recommending a product. I avoid overly salesy vibes and focus on genuine storytelling that builds trust.',
      ),
      FAQ(
        question: 'Do you provide content ideas or should I?',
        answer: 'I can do both! I\'ll provide creative concepts based on current trends, or work from your specific brief. We\'ll collaborate during our strategy call to nail the perfect approach.',
      ),
      FAQ(
        question: 'What if I need revisions?',
        answer: '3 rounds of revisions are included! This covers edits like different hooks, text overlays, or minor adjustments. Major re-shoots would be a separate project.',
      ),
    ],
    provider: CreatorSummary(
      id: '1',
      name: 'Ama Mensah',
      imageUrl: 'https://avatar.iran.liara.run/public/girl',
      rating: 4.9,
      reviewCount: 89,
      responseTime: '2 hours',
      isVerified: true,
    ),
    reviews: [
      OfferReview(
        id: '1',
        clientName: 'TrendyFit Ghana',
        clientImage: 'https://avatar.iran.liara.run/public/boy',
        rating: 5.0,
        comment: 'Ama\'s UGC helped us scale our ad campaigns! Her content feels so authentic and our CTR improved by 40%. She really understands what works on social media.',
        date: DateTime.now().subtract(const Duration(days: 12)),
        images: [
          'https://placehold.co/300x200/f0f0f0/cccccc?text=Review+1',
          'https://placehold.co/300x200/e8e8e8/999999?text=Review+2',
        ],
      ),
      OfferReview(
        id: '2',
        clientName: 'GlowUp Skincare',
        clientImage: 'https://avatar.iran.liara.run/public/girl',
        rating: 5.0,
        comment: 'Best UGC creator we\'ve worked with! Professional, creative, and delivered ahead of schedule. The content she created is now our top-performing ad creative.',
        date: DateTime.now().subtract(const Duration(days: 25)),
        images: [],
      ),
      OfferReview(
        id: '3',
        clientName: 'Kwame\'s Kitchen',
        clientImage: 'https://avatar.iran.liara.run/public/boy',
        rating: 4.8,
        comment: 'Great quality content and very responsive. Ama understood our brand voice perfectly and created content that really connects with our audience. Highly recommend!',
        date: DateTime.now().subtract(const Duration(days: 38)),
        images: [
          'https://placehold.co/300x200/f5f5f5/aaaaaa?text=Review+3',
        ],
      ),
    ],
  );

  // final Set<String> _selectedAddOns = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppStyles.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            PhosphorIcons.arrowLeft(),
            color: AppStyles.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              PhosphorIcons.shareNetwork(),
              color: AppStyles.textPrimary,
            ),
            onPressed: () {
              // Share offer
            },
          ),
          IconButton(
            icon: Icon(
              _isSaved ? PhosphorIconsFill.pushPin : PhosphorIcons.pushPin(),
              color: _isSaved ? AppStyles.goldPrimary : AppStyles.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isSaved = !_isSaved;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(),
            const SizedBox(height: 24),
            _buildOfferHeader(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            const SizedBox(height: 32),
            _buildProviderSection(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            const SizedBox(height: 32),
            _buildDescriptionSection(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            const SizedBox(height: 32),
            _buildIncludesSection(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            const SizedBox(height: 32),
            _buildFAQSection(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(),
            ),
            const SizedBox(height: 32),
            _buildReviewsSection(),
            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: _offer.images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                _offer.images[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppStyles.backgroundGrey,
                    child: Icon(
                      PhosphorIcons.image(),
                      size: 48,
                      color: AppStyles.textLight,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOfferHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppStyles.goldPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _offer.category,
              style: AppStyles.bodySmall.copyWith(
                color: AppStyles.textPrimary,
                fontWeight: AppStyles.semiBold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _offer.title,
            style: AppStyles.h2.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (_offer.originalPrice != null) ...[
                Text(
                  'GHS${_offer.originalPrice}',
                  style: AppStyles.h5.copyWith(
                    color: AppStyles.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                'GHS${_offer.price}',
                style: AppStyles.h3.copyWith(
                  fontWeight: AppStyles.bold,
                  color: AppStyles.goldPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIcons.star(PhosphorIconsStyle.fill),
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_offer.provider.rating}',
                      style: AppStyles.bodyMedium.copyWith(
                        color: Colors.green,
                        fontWeight: AppStyles.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildQuickInfo(
                PhosphorIcons.clock(),
                _offer.duration,
                'Production',
              ),
              const SizedBox(width: 24),
              _buildQuickInfo(
                PhosphorIcons.calendar(),
                _offer.deliveryTime,
                'Delivery',
              ),
              const SizedBox(width: 24),
              _buildQuickInfo(
                PhosphorIcons.arrowsClockwise(),
                '${_offer.revisions} revisions',
                'Included',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppStyles.textSecondary,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppStyles.bodyMedium.copyWith(
              fontWeight: AppStyles.semiBold,
            ),
          ),
          Text(
            label,
            style: AppStyles.bodySmall.copyWith(
              color: AppStyles.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          // Navigate to provider profile
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppStyles.borderLight),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(_offer.provider.imageUrl),
                  ),
                  if (_offer.provider.isVerified)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _offer.provider.name,
                      style: AppStyles.bodyLarge.copyWith(
                        fontWeight: AppStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          PhosphorIcons.star(PhosphorIconsStyle.fill),
                          size: 14,
                          color: AppStyles.goldPrimary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_offer.provider.rating} (${_offer.provider.reviewCount})',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppStyles.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          PhosphorIcons.clock(),
                          size: 14,
                          color: AppStyles.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_offer.provider.responseTime} response',
                          style: AppStyles.bodySmall.copyWith(
                            color: AppStyles.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                PhosphorIcons.caretRight(),
                color: AppStyles.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this offer',
            style: AppStyles.h4.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _offer.description,
            style: AppStyles.bodyLarge.copyWith(
              color: AppStyles.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncludesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'What\'s included',
            style: AppStyles.h4.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: _offer.includes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = _offer.includes[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 30,
                  color: AppStyles.goldPrimary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppStyles.bodyLarge.copyWith(
                          fontWeight: AppStyles.regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Frequently asked questions',
            style: AppStyles.h4.copyWith(
              fontWeight: AppStyles.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: _offer.faqs.length,
          separatorBuilder: (context, index) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final faq = _offer.faqs[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: AppStyles.bodyLarge.copyWith(
                    fontWeight: AppStyles.semiBold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  faq.answer,
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppStyles.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews for this offer',
                style: AppStyles.h4.copyWith(
                  fontWeight: AppStyles.bold,
                ),
              ),
              Text(
                '${_offer.reviews.length}',
                style: AppStyles.bodyLarge.copyWith(
                  color: AppStyles.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: _offer.reviews.length,
          separatorBuilder: (context, index) => const Divider(height: 32),
          itemBuilder: (context, index) {
            return _buildReviewItem(_offer.reviews[index]);
          },
        ),
      ],
    );
  }

  Widget _buildReviewItem(OfferReview review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(review.clientImage),
              backgroundColor: AppStyles.backgroundGrey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.clientName,
                    style: AppStyles.bodyLarge.copyWith(
                      fontWeight: AppStyles.semiBold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          PhosphorIcons.star(PhosphorIconsStyle.fill),
                          size: 14,
                          color: AppStyles.goldPrimary,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(review.date),
                        style: AppStyles.bodySmall.copyWith(
                          color: AppStyles.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          review.comment,
          style: AppStyles.bodyMedium.copyWith(
            color: AppStyles.textPrimary,
            height: 1.5,
          ),
        ),
        if (review.images.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: review.images.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    review.images[index],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GHS${_offer.price.toStringAsFixed(0)}',
                  style: AppStyles.h5.copyWith(
                    fontWeight: AppStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 32),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to booking/checkout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.goldPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Book This',
                  style: AppStyles.button.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}

// Data models
class OfferDetailData {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? originalPrice;
  final String duration;
  final String deliveryTime;
  final int revisions;
  final String category;
  final List<String> images;
  final List<OfferInclude> includes;
  final List<AddOn> addOns;
  final List<FAQ> faqs;
  final CreatorSummary provider;
  final List<OfferReview> reviews;

  OfferDetailData({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.duration,
    required this.deliveryTime,
    required this.revisions,
    required this.category,
    required this.images,
    required this.includes,
    required this.addOns,
    required this.faqs,
    required this.provider,
    required this.reviews,
  });
}

class OfferInclude {
  final IconData icon;
  final String title;
  final String description;

  OfferInclude({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class AddOn {
  final String id;
  final String title;
  final String description;
  final double price;

  AddOn({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });
}

class FAQ {
  final String question;
  final String answer;

  FAQ({
    required this.question,
    required this.answer,
  });
}

class CreatorSummary {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String responseTime;
  final bool isVerified;

  CreatorSummary({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.responseTime,
    required this.isVerified,
  });
}

class OfferReview {
  final String id;
  final String clientName;
  final String clientImage;
  final double rating;
  final String comment;
  final DateTime date;
  final List<String> images;

  OfferReview({
    required this.id,
    required this.clientName,
    required this.clientImage,
    required this.rating,
    required this.comment,
    required this.date,
    required this.images,
  });
}