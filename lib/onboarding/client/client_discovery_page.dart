import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class ClientDiscoveryPage extends StatefulWidget {
  final Function(String source) onSourceSelected;

  const ClientDiscoveryPage({
    super.key,
    required this.onSourceSelected,
  });

  @override
  State<ClientDiscoveryPage> createState() => _ClientDiscoveryPageState();
}

class _ClientDiscoveryPageState extends State<ClientDiscoveryPage> {
  String? _selectedSource;

  final List<DiscoveryOption> _sources = [
    DiscoveryOption(
      id: 'gef',
      title: 'Global Entrepreneurship Festival',
    ),
    DiscoveryOption(
      id: 'social_media',
      title: 'Social Media',
    ),
    DiscoveryOption(
      id: 'friend_referral',
      title: 'Friend or Colleague',
    ),
    DiscoveryOption(
      id: 'search_engine',
      title: 'Search Engine',
    ),
    DiscoveryOption(
      id: 'online_ad',
      title: 'Online Advertisement',
    ),
    DiscoveryOption(
      id: 'blog_article',
      title: 'Blog or Article',
    ),
    DiscoveryOption(
      id: 'app_store',
      title: 'App Store',
    ),
    DiscoveryOption(
      id: 'other',
      title: 'Other',
    ),
  ];

  void _selectSource(String sourceId) {
    setState(() {
      _selectedSource = sourceId;
    });
  }

  void _continue() {
    if (_selectedSource != null) {
      widget.onSourceSelected(_selectedSource!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
          child: Column(
            children: [
              // Title
              Text(
                'How did you hear\nabout us?',
                style: AppStyles.h1.copyWith(
                  height: 1.2,
                  fontSize: 32,
                  color: AppStyles.textPrimary,
                  fontWeight: AppStyles.bold,
                  letterSpacing: -1.0,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),

        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                // Subtitle
                // Text(
                //   'Help us understand how you found Gold Circle',
                //   style: AppStyles.bodyLarge.copyWith(
                //     fontSize: 16,
                //     color: AppStyles.textSecondary,
                //   ),
                //   textAlign: TextAlign.center,
                // ),

                const SizedBox(height: 36),

                // Options List
                Column(
                  children: _sources.map((source) {
                    final isSelected = _selectedSource == source.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () => _selectSource(source.id),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppStyles.backgroundWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppStyles.textBlack
                                  : Colors.grey.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Title
                              Expanded(
                                child: Text(
                                  source.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: AppStyles.textBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Fixed Continue Button
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: AppStyles.backgroundWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _selectedSource != null ? _continue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedSource != null
                    ? AppStyles.textBlack
                    : Colors.grey.shade300,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade400,
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DiscoveryOption {
  final String id;
  final String title;

  DiscoveryOption({
    required this.id,
    required this.title,
  });
}