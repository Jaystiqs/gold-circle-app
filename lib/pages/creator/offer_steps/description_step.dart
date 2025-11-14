import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../utils/app_styles.dart';

class OfferDescriptionStep extends StatefulWidget {
  final TextEditingController controller;

  const OfferDescriptionStep({
    super.key,
    required this.controller,
  });

  @override
  State<OfferDescriptionStep> createState() => _OfferDescriptionStepState();
}

class _OfferDescriptionStepState extends State<OfferDescriptionStep> {
  void _showTipsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tips for a great description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    PhosphorIconsRegular.x,
                    color: AppStyles.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTip(
              'Start with the main benefit',
              'Lead with what the client will gain from your service',
            ),
            const SizedBox(height: 16),
            _buildTip(
              'Be specific about deliverables',
              'Clearly outline what\'s included in your offer',
            ),
            const SizedBox(height: 16),
            _buildTip(
              'Highlight your unique approach',
              'Explain what makes your service different',
            ),
            const SizedBox(height: 16),
            _buildTip(
              'Address client concerns',
              'Mention revisions, communication style, or timeline',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAiSuggestionsBottomSheet(BuildContext context) {
    final currentDescription = widget.controller.text.trim();

    if (currentDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a description first'),
          backgroundColor: AppStyles.textSecondary,
        ),
      );
      return;
    }

    // TODO: Replace with actual AI API call
    final suggestions = _generateDescriptionSuggestions(currentDescription);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      PhosphorIconsRegular.sparkle,
                      color: AppStyles.textPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI Description Improvements',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppStyles.textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    PhosphorIconsRegular.x,
                    color: AppStyles.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select a version to use it',
              style: TextStyle(
                fontSize: 14,
                color: AppStyles.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: suggestions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return _buildSuggestionCard(
                    context,
                    suggestion['description']!,
                    suggestion['improvement']!,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _generateDescriptionSuggestions(String currentDescription) {
    // TODO: Replace with actual AI API call
    if (currentDescription.isEmpty) {
      return [
        {
          'description': 'I create stunning, conversion-focused designs that help brands stand out. With 5+ years of experience, I deliver professional work with unlimited revisions until you\'re 100% satisfied. Fast turnaround, clear communication, and results that exceed expectations.',
          'improvement': 'Professional structure with clear value proposition',
        },
      ];
    }

    // Mock suggestions based on current description
    return [
      {
        'description': '$currentDescription\n\nWhat you\'ll get:\n• Professional quality guaranteed\n• Unlimited revisions included\n• Fast 24-hour response time\n• Complete source files delivered',
        'improvement': 'Added structured deliverables section',
      },
      {
        'description': 'Transform your brand with $currentDescription. I work closely with clients to ensure every detail aligns with your vision. You\'ll receive dedicated support throughout the process and final files ready for immediate use.',
        'improvement': 'More engaging opening with client benefits',
      },
      {
        'description': currentDescription.replaceFirst(
          currentDescription.split('.').first,
          '${currentDescription.split('.').first} - backed by 100+ satisfied clients and a 5-star rating',
        ),
        'improvement': 'Added social proof and credibility',
      },
    ];
  }

  Widget _buildSuggestionCard(BuildContext context, String description, String improvement) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.controller.text = description;
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppStyles.backgroundGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppStyles.textPrimary,
                  height: 1.5,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.lightbulb,
                    size: 14,
                    color: AppStyles.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      improvement,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppStyles.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
              'Describe your offer',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppStyles.textPrimary,
                height: 1.0,
                letterSpacing: -0.5,
              ), textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explain what you\'ll deliver and what makes your service unique',
            style: TextStyle(
              fontSize: 18,
              color: AppStyles.textSecondary,
              letterSpacing: -0.3,
            ), textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Stack(
            children: [
              TextField(
                controller: widget.controller,
                autofocus: true,
                maxLength: 1000,
                maxLines: 8,
                minLines: 8,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppStyles.textPrimary,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  hintText: 'E.g., I\'ll create a professional logo that perfectly captures your brand identity. You\'ll receive multiple concepts, unlimited revisions, and all source files...',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: AppStyles.textLight,
                    fontWeight: FontWeight.w400,
                  ),
                  counterStyle: TextStyle(
                    fontSize: 13,
                    color: AppStyles.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppStyles.textPrimary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
              Positioned(
                bottom: 32,
                right: 12,
                child: Material(
                  color: AppStyles.textPrimary,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showAiSuggestionsBottomSheet(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        PhosphorIcons.sparkle(PhosphorIconsStyle.bold),
                        color: AppStyles.goldPrimary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => _showTipsBottomSheet(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: Text(
              'Tips',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppStyles.textPrimary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppStyles.backgroundGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppStyles.textPrimary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppStyles.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}