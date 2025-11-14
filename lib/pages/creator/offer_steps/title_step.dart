import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../utils/app_styles.dart';

class OfferTitleStep extends StatefulWidget {
  final TextEditingController controller;

  const OfferTitleStep({
    super.key,
    required this.controller,
  });

  @override
  State<OfferTitleStep> createState() => _OfferTitleStepState();
}

class _OfferTitleStepState extends State<OfferTitleStep> {

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
                  'Tips for a great title',
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
              'Keep it specific and searchable',
              'Include what you\'re offering and who it\'s for',
            ),
            const SizedBox(height: 16),
            _buildTip(
              'Make it benefit-focused',
              'Highlight the value clients will get',
            ),
            const SizedBox(height: 16),
            _buildTip(
              'Use keywords naturally',
              'Think about what clients would search for',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAITitleSuggestions(BuildContext context) {
    final currentTitle = widget.controller.text.trim();

    // TODO: Replace with actual AI API call
    final suggestions = _generateTitleSuggestions(currentTitle);

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
                      'AI Title Suggestions',
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
              'Select a suggestion to use it',
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
                    suggestion['title']!,
                    suggestion['reason']!,
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

  List<Map<String, String>> _generateTitleSuggestions(String currentTitle) {
    // TODO: Replace with actual AI API call
    if (currentTitle.isEmpty) {
      return [
        {
          'title': 'Professional Logo Design for Growing Brands',
          'reason': 'Clear, benefit-focused, targets specific audience',
        },
        {
          'title': 'Custom Logo Design - Unique Brand Identity',
          'reason': 'Emphasizes uniqueness and brand value',
        },
        {
          'title': 'Modern Logo Design with Unlimited Revisions',
          'reason': 'Highlights service quality and flexibility',
        },
      ];
    }

    // Mock suggestions based on current title
    return [
      {
        'title': '$currentTitle - Fast Delivery',
        'reason': 'Adds urgency and delivery promise',
      },
      {
        'title': 'Professional $currentTitle for Your Business',
        'reason': 'More specific to target audience',
      },
      {
        'title': '$currentTitle with Premium Quality',
        'reason': 'Emphasizes value proposition',
      },
    ];
  }

  Widget _buildSuggestionCard(BuildContext context, String title, String reason) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.controller.text = title;
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
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppStyles.textPrimary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),
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
                      reason,
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
              'Give your offer a title',
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
            'Create a clear, compelling title that describes your service',
            style: TextStyle(
              fontSize: 18,
              color: AppStyles.textSecondary,
              letterSpacing: -0.3,
            ), textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          TextField(
            controller: widget.controller,
            autofocus: true,
            maxLength: 80,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppStyles.textPrimary,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: 'E.g., Professional Logo Design for Your Brand',
              hintStyle: TextStyle(
                fontSize: 18,
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
              suffixIcon: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  color: AppStyles.textPrimary,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showAITitleSuggestions(context),
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
            ),
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