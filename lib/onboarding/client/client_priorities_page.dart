import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class ClientPrioritiesPage extends StatefulWidget {
  final Function(List<String> priorities) onPrioritiesSelected;

  const ClientPrioritiesPage({
    super.key,
    required this.onPrioritiesSelected,
  });

  @override
  State<ClientPrioritiesPage> createState() => _ClientPrioritiesPageState();
}

class _ClientPrioritiesPageState extends State<ClientPrioritiesPage> {
  final Set<String> _selectedPriorities = {};

  final List<PriorityOption> _priorities = [
    PriorityOption(
      id: 'right_talent',
      title: 'Finding the right talent',
      icon: Icons.person_search_rounded,
    ),
    PriorityOption(
      id: 'tight_deadline',
      title: 'Meeting a tight deadline',
      icon: Icons.schedule_rounded,
    ),
    PriorityOption(
      id: 'quality_work',
      title: 'Quality work',
      icon: Icons.star_rounded,
    ),
    PriorityOption(
      id: 'budget_friendly',
      title: 'Budget-friendly options',
      icon: Icons.attach_money_rounded,
    ),
    PriorityOption(
      id: 'communication',
      title: 'Clear communication',
      icon: Icons.chat_bubble_rounded,
    ),
    PriorityOption(
      id: 'reliability',
      title: 'Reliability & trust',
      icon: Icons.verified_user_rounded,
    ),
  ];

  void _togglePriority(String priorityId) {
    setState(() {
      if (_selectedPriorities.contains(priorityId)) {
        _selectedPriorities.remove(priorityId);
      } else {
        _selectedPriorities.add(priorityId);
      }
    });
  }

  void _continue() {
    if (_selectedPriorities.isNotEmpty) {
      widget.onPrioritiesSelected(_selectedPriorities.toList());
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
                'What is important\nto you?',
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

                // // Subtitle
                // Text(
                //   'Select all that apply',
                //   style: AppStyles.bodyLarge.copyWith(
                //     fontSize: 16,
                //     color: AppStyles.textSecondary,
                //   ),
                //   textAlign: TextAlign.center,
                // ),

                const SizedBox(height: 16),

                // Priorities List
                Column(
                  children: _priorities.map((priority) {
                    final isSelected = _selectedPriorities.contains(priority.id);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () => _togglePriority(priority.id),
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
                              // Icon
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  priority.icon,
                                  size: 24,
                                  color: AppStyles.textSecondary,
                                ),
                              ),

                              const SizedBox(width: 16),

                              // Title
                              Expanded(
                                child: Text(
                                  priority.title,
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
              onPressed: _selectedPriorities.isNotEmpty ? _continue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedPriorities.isNotEmpty
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

class PriorityOption {
  final String id;
  final String title;
  final IconData icon;

  PriorityOption({
    required this.id,
    required this.title,
    required this.icon,
  });
}