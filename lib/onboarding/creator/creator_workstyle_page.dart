import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class CreatorWorkStylePage extends StatefulWidget {
  final Function(String workStyle) onWorkStyleSelected;

  const CreatorWorkStylePage({
    super.key,
    required this.onWorkStyleSelected,
  });

  @override
  State<CreatorWorkStylePage> createState() => _CreatorWorkStylePageState();
}

class _CreatorWorkStylePageState extends State<CreatorWorkStylePage> {
  String? _selectedWorkStyle;

  final List<WorkStyleOption> _workStyles = [
    WorkStyleOption(
      id: 'remote',
      title: 'Remote only',
      subtitle: 'Work from anywhere',
      icon: Icons.laptop_mac,
      color: Color(0xFFE3F2FD),
    ),
    WorkStyleOption(
      id: 'in_person',
      title: 'In-person',
      subtitle: 'Accra area',
      icon: Icons.location_on,
      color: Color(0xFFFFE0B2),
    ),
    WorkStyleOption(
      id: 'flexible',
      title: 'Flexible',
      subtitle: 'Both remote and in-person',
      icon: Icons.swap_horiz,
      color: Color(0xFFE8F5E9),
    ),
  ];

  void _selectWorkStyle(String workStyleId) {
    setState(() {
      _selectedWorkStyle = workStyleId;
    });
  }

  void _continue() {
    if (_selectedWorkStyle != null) {
      widget.onWorkStyleSelected(_selectedWorkStyle!);
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
                'How do you prefer\nto work?',
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

                // Work Style Options
                Column(
                  children: _workStyles.map((workStyle) {
                    final isSelected = _selectedWorkStyle == workStyle.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () => _selectWorkStyle(workStyle.id),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppStyles.backgroundWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppStyles.goldPrimary
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
                                  color: workStyle.color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  workStyle.icon,
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
                                      workStyle.title,
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
                                      workStyle.subtitle,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppStyles.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Selection indicator
                              if (isSelected)
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppStyles.goldPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18,
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.shade100,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You can always update this preference later in your profile settings.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
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
              onPressed: _selectedWorkStyle != null ? _continue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedWorkStyle != null
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

class WorkStyleOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  WorkStyleOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}