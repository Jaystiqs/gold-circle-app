import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class CreatorGoalPage extends StatefulWidget {
  final Function(String goal) onGoalSelected;

  const CreatorGoalPage({
    super.key,
    required this.onGoalSelected,
  });

  @override
  State<CreatorGoalPage> createState() => _CreatorGoalPageState();
}

class _CreatorGoalPageState extends State<CreatorGoalPage> {
  String? _selectedGoal;

  final List<GoalOption> _goals = [
    GoalOption(
      id: 'side_income',
      title: 'Earn\nside income',
      subtitle: 'Supplement your current income',
      icon: Icons.savings_outlined,
      color: Color(0xFFFFF3E0),
    ),
    GoalOption(
      id: 'build_reputation',
      title: 'Establish\ncredibility & reviews',
      subtitle: 'Establish credibility and reviews',
      icon: Icons.star_border,
      color: Color(0xFFE3F2FD),
    ),
    GoalOption(
      id: 'find_clients',
      title: 'Find consistent clients',
      subtitle: 'Build long-term relationships',
      icon: Icons.people_outline,
      color: Color(0xFFE8F5E9),
    ),
    GoalOption(
      id: 'grow_business',
      title: 'Grow \n my portfolio',
      subtitle: 'Scale up and expand',
      icon: Icons.trending_up,
      color: Color(0xFFFCE4EC),
    ),
  ];

  void _selectGoal(String goalId) {
    setState(() {
      _selectedGoal = goalId;
    });
  }

  void _continue() {
    if (_selectedGoal != null) {
      widget.onGoalSelected(_selectedGoal!);
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
                'What\'s your main goal\non Gold Circle?',
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

        // Scrollable Content with Grid
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 36),

                // Goal Options Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _goals.length,
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    final isSelected = _selectedGoal == goal.id;

                    return GestureDetector(
                      onTap: () => _selectGoal(goal.id),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppStyles.backgroundWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppStyles.textPrimary
                                : Colors.grey.withOpacity(0.2),
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon Container
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: goal.color,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  goal.icon,
                                  size: 36,
                                  color: AppStyles.textPrimary.withOpacity(0.8),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Title
                              Text(
                                goal.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: AppStyles.textBlack,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // const SizedBox(height: 6),
                              //
                              // // Subtitle
                              // Text(
                              //   goal.subtitle,
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     color: AppStyles.textSecondary,
                              //     height: 1.3,
                              //   ),
                              //   textAlign: TextAlign.center,
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
              onPressed: _selectedGoal != null ? _continue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedGoal != null
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

class GoalOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  GoalOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}