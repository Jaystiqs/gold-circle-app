import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class CreatorAvailabilityPage extends StatefulWidget {
  final Function(String availability) onAvailabilitySelected;

  const CreatorAvailabilityPage({
    super.key,
    required this.onAvailabilitySelected,
  });

  @override
  State<CreatorAvailabilityPage> createState() => _CreatorAvailabilityPageState();
}

class _CreatorAvailabilityPageState extends State<CreatorAvailabilityPage> {
  String? _selectedAvailability;

  final List<AvailabilityOption> _availabilityOptions = [
    AvailabilityOption(
      id: 'few_projects',
      title: 'Just a few projects',
      subtitle: '1-2 projects per month',
      icon: Icons.calendar_today,
      color: Color(0xFFFFF3E0),
    ),
    AvailabilityOption(
      id: 'regular_work',
      title: 'Regular steady work',
      subtitle: '3-5 projects per month',
      icon: Icons.event_repeat,
      color: Color(0xFFE3F2FD),
    ),
    AvailabilityOption(
      id: 'maximum_work',
      title: 'As much as possible',
      subtitle: '6+ projects per month',
      icon: Icons.flash_on,
      color: Color(0xFFE8F5E9),
    ),
  ];

  void _selectAvailability(String availabilityId) {
    setState(() {
      _selectedAvailability = availabilityId;
    });
  }

  void _continue() {
    if (_selectedAvailability != null) {
      widget.onAvailabilitySelected(_selectedAvailability!);
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
                'How much work are\nyou looking for?',
                style: AppStyles.h1.copyWith(
                  height: 1.2,
                  fontSize: 28,
                  color: AppStyles.textPrimary,
                  fontWeight: AppStyles.semiBold,
                  letterSpacing: -1.0,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 18),

              // Subtitle
              Text(
                'This helps us match you with the right amount of opportunities.',
                style: AppStyles.bodyLarge.copyWith(
                  fontSize: 16,
                  color: AppStyles.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),
    // This helps us match you with the right amount of opportunities.
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
                const SizedBox(height: 16),

                // Availability Options
                Column(
                  children: _availabilityOptions.map((availability) {
                    final isSelected = _selectedAvailability == availability.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () => _selectAvailability(availability.id),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppStyles.backgroundWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppStyles.textPrimary
                                  : Colors.grey.withOpacity(0.3),
                              width: isSelected ? 2.5 : 1,
                            ),
                            boxShadow: [
                              if (!isSelected)
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppStyles.textPrimary.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  availability.icon,
                                  size: 28,
                                  color: AppStyles.textPrimary.withOpacity(0.8),
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Text content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      availability.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: AppStyles.textBlack,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      availability.subtitle,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppStyles.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Info message
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          ' You can adjust this anytime.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
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
              onPressed: _selectedAvailability != null ? _continue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAvailability != null
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

class AvailabilityOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  AvailabilityOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}