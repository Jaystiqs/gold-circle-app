import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class CreatorExperiencePage extends StatefulWidget {
  final Function(String experienceLevel) onExperienceSelected;

  const CreatorExperiencePage({
    super.key,
    required this.onExperienceSelected,
  });

  @override
  State<CreatorExperiencePage> createState() => _CreatorExperiencePageState();
}

class _CreatorExperiencePageState extends State<CreatorExperiencePage> {
  String? _selectedExperience;

  final List<ExperienceOption> _experienceLevels = [
    ExperienceOption(
      id: 'beginner',
      title: 'Just starting out',
      subtitle: '0-1 years of experience',
      icon: Icons.star_outline,
      // color: Color(0xFFFFF3E0),
    ),
    ExperienceOption(
      id: 'intermediate',
      title: 'Some experience',
      subtitle: '1-3 years of experience',
      icon: Icons.star_half,
      // color: Color(0xFFE3F2FD),
    ),
    ExperienceOption(
      id: 'experienced',
      title: 'Experienced',
      subtitle: '3-5 years of experience',
      icon: Icons.star,
      // color: Color(0xFFE8F5E9),
    ),
    ExperienceOption(
      id: 'expert',
      title: 'Expert',
      subtitle: '5+ years of experience',
      icon: Icons.stars,
      // color: Color(0xFFFFF9C4),
    ),
  ];

  void _selectExperience(String experienceId) {
    setState(() {
      _selectedExperience = experienceId;
    });
  }

  void _continue() {
    if (_selectedExperience != null) {
      widget.onExperienceSelected(_selectedExperience!);
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
                'What\'s your experience\nlevel?',
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

                // Experience Options
                Column(
                  children: _experienceLevels.map((experience) {
                    final isSelected = _selectedExperience == experience.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () => _selectExperience(experience.id),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppStyles.backgroundWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppStyles.textPrimary
                                  : Colors.grey.withOpacity(0.4),
                              width: isSelected ? 2.5 : 1,
                            ),
                            // boxShadow: [
                            //   if (!isSelected)
                            //     BoxShadow(
                            //       color: Colors.grey.withOpacity(0.08),
                            //       spreadRadius: 0,
                            //       blurRadius: 8,
                            //       offset: const Offset(0, 2),
                            //     ),
                            // ],
                          ),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppStyles.textLight.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  experience.icon,
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
                                      experience.title,
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
                                      experience.subtitle,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppStyles.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // // Selection indicator
                              // if (isSelected)
                              //   Container(
                              //     width: 28,
                              //     height: 28,
                              //     decoration: BoxDecoration(
                              //       color: AppStyles.goldPrimary,
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: Icon(
                              //       Icons.check,
                              //       color: Colors.white,
                              //       size: 18,
                              //     ),
                              //   ),
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
              onPressed: _selectedExperience != null ? _continue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedExperience != null
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

class ExperienceOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  // final Color color;

  ExperienceOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    // required this.color,
  });
}