import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:async';
import '../../app_styles.dart';
import 'provider_profile.dart';

// Main view that handles multiple providers
class PortfolioStoriesView extends StatefulWidget {
  final List<ProviderWithStories> providers;
  final int initialProviderIndex;

  const PortfolioStoriesView({
    super.key,
    required this.providers,
    this.initialProviderIndex = 0,
  });

  @override
  State<PortfolioStoriesView> createState() => _PortfolioStoriesViewState();
}

class _PortfolioStoriesViewState extends State<PortfolioStoriesView> {
  late PageController _providerPageController;
  int currentProviderIndex = 0;

  @override
  void initState() {
    super.initState();
    currentProviderIndex = widget.initialProviderIndex;
    _providerPageController = PageController(
      initialPage: widget.initialProviderIndex,
      viewportFraction: 0.8,
    );
  }

  @override
  void dispose() {
    _providerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _providerPageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          setState(() {
            currentProviderIndex = index;
          });
        },
        itemCount: widget.providers.length,
        itemBuilder: (context, index) {
          final provider = widget.providers[index];
          final isActive = index == currentProviderIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ProviderStoriesCard(
                provider: provider,
                isActive: isActive,
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Individual provider's stories card with auto-advancing stories
class ProviderStoriesCard extends StatefulWidget {
  final ProviderWithStories provider;
  final bool isActive;
  final VoidCallback onClose;

  const ProviderStoriesCard({
    super.key,
    required this.provider,
    required this.isActive,
    required this.onClose,
  });

  @override
  State<ProviderStoriesCard> createState() => _ProviderStoriesCardState();
}

class _ProviderStoriesCardState extends State<ProviderStoriesCard>
    with SingleTickerProviderStateMixin {
  int currentStoryIndex = 0;
  late AnimationController _progressController;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    if (widget.isActive) {
      _startStory();
    }
  }

  @override
  void didUpdateWidget(ProviderStoriesCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startStory();
    } else if (!widget.isActive && oldWidget.isActive) {
      _pauseStory();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  void _startStory() {
    _progressController.reset();
    _progressController.forward();

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), () {
      if (!_isPaused && widget.isActive) {
        _nextStory();
      }
    });
  }

  void _nextStory() {
    if (currentStoryIndex < widget.provider.stories.length - 1) {
      setState(() {
        currentStoryIndex++;
      });
      _startStory();
    } else {
      // Loop back to first story
      setState(() {
        currentStoryIndex = 0;
      });
      _startStory();
    }
  }

  void _previousStory() {
    if (currentStoryIndex > 0) {
      setState(() {
        currentStoryIndex--;
      });
      _startStory();
    }
  }

  void _pauseStory() {
    setState(() {
      _isPaused = true;
    });
    _progressController.stop();
    _timer?.cancel();
  }

  void _resumeStory() {
    if (!widget.isActive) return;

    setState(() {
      _isPaused = false;
    });
    _progressController.forward();

    final remainingTime = Duration(
      milliseconds: ((1.0 - _progressController.value) * 5000).round(),
    );
    _timer?.cancel();
    _timer = Timer(remainingTime, () {
      if (!_isPaused && widget.isActive) {
        _nextStory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = widget.provider.stories[currentStoryIndex];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                currentStory.contentUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.2, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Left/Right tap areas for navigation (middle section only)
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              bottom: 200,
              child: GestureDetector(
                onTapDown: (_) {
                  if (widget.isActive) _pauseStory();
                },
                onTapUp: (_) {
                  if (widget.isActive) _resumeStory();
                },
                onTapCancel: () {
                  if (widget.isActive) _resumeStory();
                },
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.isActive ? _previousStory : null,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.isActive ? _nextStory : null,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top Section - Progress bars and user info
            _buildTopSection(),

            // Bottom Section - Story details and controls
            _buildBottomSection(currentStory),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Positioned(
      top: 16,
      left: 24,
      right: 24,
      child: Column(
        children: [
          // Progress indicators
          Row(
            children: widget.provider.stories.asMap().entries.map((entry) {
              final index = entry.key;
              return Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsets.only(
                    right: index < widget.provider.stories.length - 1 ? 4 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: index == currentStoryIndex
                      ? AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progressController.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    },
                  )
                      : Container(
                    decoration: BoxDecoration(
                      color: index < currentStoryIndex
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Close button only
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(PortfolioStory story) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Absorb taps to prevent propagation to parent gesture detectors
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Description text above the profile bar
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                story.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            // Profile bar at the bottom with action buttons
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // Navigate to provider profile
                if (widget.provider.id.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProviderProfilePage(
                        providerId: widget.provider.id,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Provider profile not available'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: 110,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppStyles.textPrimary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(22.0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          widget.provider.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[600],
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.provider.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildHorizontalActionButton(
                      icon: PhosphorIcons.pushPin(),
                      label: 'SAVE',
                      onTap: () {
                        // Save/bookmark provider
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Provider saved!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildHorizontalActionButton(
                      icon: PhosphorIcons.chatCircleText(),
                      label: 'CONTACT',
                      onTap: () {
                        // Contact provider - could open messaging
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening chat...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
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

  Widget _buildHorizontalActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFF8B7355).withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}

// Data models
class ProviderWithStories {
  final String id;
  final String name;
  final String imageUrl;
  final List<PortfolioStory> stories;

  ProviderWithStories({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.stories,
  });
}

class PortfolioStory {
  final String title;
  final String description;
  final String contentUrl;
  final String category;
  final StoryType type;

  PortfolioStory({
    required this.title,
    required this.description,
    required this.contentUrl,
    required this.category,
    required this.type,
  });
}

enum StoryType { image, video }

// Sample data generator
class PortfolioStoriesData {
  static List<ProviderWithStories> getAllProviders() {
    return [
      ProviderWithStories(
        id: 'sarah_johnson_001',
        name: 'Sarah Johnson',
        imageUrl: 'https://avatar.iran.liara.run/public/girl',
        stories: [
          PortfolioStory(
            title: 'Wedding Photography',
            description:
            'A song about youth running away after church and not staying to help., female vocals, country, jazz',
            contentUrl: 'https://picsum.photos/400/800?random=1',
            category: 'Photography',
            type: StoryType.image,
          ),
          PortfolioStory(
            title: 'Portrait Session',
            description:
            'Professional headshots for corporate clients with stunning natural lighting',
            contentUrl: 'https://picsum.photos/400/800?random=2',
            category: 'Photography',
            type: StoryType.image,
          ),
          PortfolioStory(
            title: 'Product Photography',
            description:
            'Commercial product shots for e-commerce brands and online stores',
            contentUrl: 'https://picsum.photos/400/800?random=3',
            category: 'Photography',
            type: StoryType.image,
          ),
        ],
      ),
      ProviderWithStories(
        id: 'michael_chen_002',
        name: 'Michael Chen',
        imageUrl: 'https://avatar.iran.liara.run/public/boy',
        stories: [
          PortfolioStory(
            title: 'Brand Logo Design',
            description:
            'Modern minimalist logo design for innovative tech startup companies',
            contentUrl: 'https://picsum.photos/400/800?random=4',
            category: 'Design',
            type: StoryType.image,
          ),
          PortfolioStory(
            title: 'Website Mockup',
            description:
            'Responsive web design for premium fashion brand with elegant aesthetics',
            contentUrl: 'https://picsum.photos/400/800?random=5',
            category: 'Design',
            type: StoryType.image,
          ),
        ],
      ),
      ProviderWithStories(
        id: 'emily_davis_003',
        name: 'Emily Davis',
        imageUrl: 'https://avatar.iran.liara.run/public/girl',
        stories: [
          PortfolioStory(
            title: 'Content Writing',
            description:
            'SEO-optimized blog posts for health & wellness industry leaders',
            contentUrl: 'https://picsum.photos/400/800?random=6',
            category: 'Writing',
            type: StoryType.image,
          ),
          PortfolioStory(
            title: 'Copywriting',
            description:
            'Engaging marketing copy for viral social media campaigns',
            contentUrl: 'https://picsum.photos/400/800?random=7',
            category: 'Writing',
            type: StoryType.image,
          ),
          PortfolioStory(
            title: 'Technical Writing',
            description:
            'Clear and comprehensive user manuals and documentation',
            contentUrl: 'https://picsum.photos/400/800?random=8',
            category: 'Writing',
            type: StoryType.image,
          ),
        ],
      ),
      ProviderWithStories(
        id: 'james_wilson_004',
        name: 'James Wilson',
        imageUrl: 'https://avatar.iran.liara.run/public/boy',
        stories: [
          PortfolioStory(
            title: 'Video Production',
            description:
            'Cinematic video content for brands and creative agencies',
            contentUrl: 'https://picsum.photos/400/800?random=10',
            category: 'Video',
            type: StoryType.image,
          ),
        ],
      ),
    ];
  }

  static List<PortfolioStory> getSampleStories(String providerName) {
    final provider = getAllProviders().firstWhere(
          (p) => p.name == providerName,
      orElse: () => getAllProviders()[0],
    );
    return provider.stories;
  }

  // Helper method to get a single provider with stories by name
  static ProviderWithStories getProviderByName(String providerName) {
    return getAllProviders().firstWhere(
          (p) => p.name == providerName,
      orElse: () => getAllProviders()[0],
    );
  }

  // Helper method to create a single-provider list for stories view
  static List<ProviderWithStories> getSingleProvider(String providerName, String imageUrl) {
    // Find existing provider by name, or create a new one
    final existingProvider = getAllProviders().firstWhere(
          (p) => p.name == providerName,
      orElse: () => ProviderWithStories(
        id: providerName.toLowerCase().replaceAll(' ', '_'),
        name: providerName,
        imageUrl: imageUrl,
        stories: [
          PortfolioStory(
            title: 'Portfolio Preview',
            description: 'Check out my work and creative projects',
            contentUrl: 'https://picsum.photos/400/800?random=99',
            category: 'General',
            type: StoryType.image,
          ),
        ],
      ),
    );

    return [existingProvider];
  }
}