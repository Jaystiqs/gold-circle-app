import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../utils/app_styles.dart';

class SummaryStep extends StatelessWidget {
  final String category;
  final String title;
  final String description;
  final RangeValues budgetRange;
  final String timeline;
  final List<String> assetUrls;

  const SummaryStep({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.budgetRange,
    required this.timeline,
    required this.assetUrls,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review your task request',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppStyles.textPrimary,
              height: 1.0,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure everything looks good before submitting',
            style: AppStyles.bodyMedium.copyWith(
              color: AppStyles.textSecondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 32),

          // Category
          _buildSummaryCard(
            icon: PhosphorIconsRegular.tag,
            title: 'Category',
            content: category,
          ),
          const SizedBox(height: 16),

          // Title
          _buildSummaryCard(
            icon: PhosphorIconsRegular.textT,
            title: 'Title',
            content: title,
          ),
          const SizedBox(height: 16),

          // Description
          _buildSummaryCard(
            icon: PhosphorIconsRegular.article,
            title: 'Description',
            content: description,
            maxLines: null,
          ),
          const SizedBox(height: 16),

          // Budget
          _buildSummaryCard(
            icon: PhosphorIconsRegular.currencyCircleDollar,
            title: 'Budget',
            content: 'GHS${budgetRange.start.round()} - GHS${budgetRange.end.round()}',
          ),
          const SizedBox(height: 16),

          // Timeline
          _buildSummaryCard(
            icon: PhosphorIconsRegular.calendar,
            title: 'Timeline',
            content: timeline,
          ),

          // Assets (if any)
          if (assetUrls.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSummaryCard(
              icon: PhosphorIconsRegular.link,
              title: 'Asset Links',
              content: '${assetUrls.length} ${assetUrls.length == 1 ? 'link' : 'links'} added',
              showList: true,
              listItems: assetUrls,
            ),
          ],

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String content,
    int? maxLines = 2,
    bool showList = false,
    List<String>? listItems,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppStyles.textLight.withOpacity(0.3), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppStyles.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppStyles.textSecondary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!showList)
            Text(
              content,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppStyles.textPrimary,
                height: 1.0,
                letterSpacing: -0.2,
              ),
              maxLines: maxLines,
              overflow: maxLines != null ? TextOverflow.ellipsis : null,
            )
          else if (listItems != null) ...[
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppStyles.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            ...listItems.map((url) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.link,
                    size: 14,
                    color: AppStyles.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      url,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppStyles.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}