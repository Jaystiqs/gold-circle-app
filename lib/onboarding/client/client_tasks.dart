import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

// Page 1: Main Task Selection
class ClientTasksPage extends StatefulWidget {
  final Function(String task) onTaskSelected;

  const ClientTasksPage({
    super.key,
    required this.onTaskSelected,
  });

  @override
  State<ClientTasksPage> createState() => _ClientTasksPageState();
}

class _ClientTasksPageState extends State<ClientTasksPage> {
  String? _selectedTask;

  final List<TaskOption> _tasks = [
    TaskOption(
      id: 'design',
      title: 'Design & Creative',
      icon: Icons.palette_outlined,
      color: Color(0xFFE3F2FD),
    ),
    TaskOption(
      id: 'development',
      title: 'Development & Tech',
      icon: Icons.code,
      color: Color(0xFFF3E5F5),
    ),
    // TaskOption(
    //   id: 'writing',
    //   title: 'Writing & Content',
    //   icon: Icons.edit_note,
    //   color: Color(0xFFFFF3E0),
    // ),
    // TaskOption(
    //   id: 'marketing',
    //   title: 'Marketing & Sales',
    //   icon: Icons.trending_up,
    //   color: Color(0xFFE8F5E9),
    // ),
    TaskOption(
      id: 'social_media',
      title: 'Social Media Mgt\n& UGC',
      icon: Icons.business_center_outlined,
      color: Color(0xFFFCE4EC),
    ),
  ];

  void _selectTask(String taskId) {
    setState(() {
      _selectedTask = taskId;
    });
    widget.onTaskSelected(taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Static Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Text(
              'What task will you want done \n on Gold Circle?',
              style: AppStyles.h1.copyWith(
                height: 1.2,
                fontSize: 28,
                color: AppStyles.textPrimary,
                fontWeight: AppStyles.semiBold,
                letterSpacing: -1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Scrollable Task Grid
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                final isSelected = _selectedTask == task.id;

                return GestureDetector(
                  onTap: () => _selectTask(task.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppStyles.backgroundWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppStyles.goldPrimary
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon Container
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: task.color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            task.icon,
                            size: 36,
                            color: AppStyles.textPrimary.withOpacity(0.8),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            task.title,
                            style: AppStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppStyles.textBlack,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Page 2: Sub-task Selection with Multiple Selection Support
class ClientSubTasksPage extends StatefulWidget {
  final String selectedMainTask;
  final Function(List<String> subTasks) onSubTaskSelected;

  const ClientSubTasksPage({
    super.key,
    required this.selectedMainTask,
    required this.onSubTaskSelected,
  });

  @override
  State<ClientSubTasksPage> createState() => _ClientSubTasksPageState();
}

class _ClientSubTasksPageState extends State<ClientSubTasksPage>
    with SingleTickerProviderStateMixin {
  final Set<String> _selectedSubTasks = {};
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final Map<String, TaskOption> _mainTasks = {
    'design': TaskOption(
      id: 'design',
      title: 'Design & Creative',
      icon: Icons.palette_outlined,
      color: Color(0xFFE3F2FD),
    ),
    'development': TaskOption(
      id: 'development',
      title: 'Development & Tech',
      icon: Icons.code,
      color: Color(0xFFF3E5F5),
    ),
    'social_media': TaskOption(
      id: 'social_media',
      title: 'Social Media Mgt & UGC',
      icon: Icons.business_center_outlined,
      color: Color(0xFFFCE4EC),
    ),
  };

  final Map<String, List<SubTaskOption>> _subTasks = {
    'design': [
      SubTaskOption(id: 'logo', title: 'Logo Design'),
      SubTaskOption(id: 'ui_ux', title: 'UI/UX Design'),
      SubTaskOption(id: 'graphic', title: 'Graphic Design'),
      SubTaskOption(id: 'brand', title: 'Brand Identity'),
      SubTaskOption(id: 'illustration', title: 'Illustration'),
    ],
    'development': [
      SubTaskOption(id: 'web', title: 'Website Development'),
      SubTaskOption(id: 'mobile', title: 'Mobile App Development'),
      SubTaskOption(id: 'backend', title: 'Backend Development'),
      SubTaskOption(id: 'wordpress', title: 'WordPress'),
    ],
    'social_media': [
      SubTaskOption(id: 'management', title: 'Social Media Management'),
      SubTaskOption(id: 'content_creation', title: 'Content Creation'),
      SubTaskOption(id: 'ugc', title: 'User Generated Content'),
      SubTaskOption(id: 'community', title: 'Community Management'),
      SubTaskOption(id: 'promotion', title: 'Social Media Promotion'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation on page load
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSubTask(String subTaskId) {
    setState(() {
      if (_selectedSubTasks.contains(subTaskId)) {
        _selectedSubTasks.remove(subTaskId);
      } else {
        _selectedSubTasks.add(subTaskId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedTaskData = _mainTasks[widget.selectedMainTask];
    final subOptions = _subTasks[widget.selectedMainTask] ?? [];

    if (selectedTaskData == null) {
      return Center(
        child: Text('Task not found'),
      );
    }

    return Column(
      children: [
        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'What specific service\ndo you need?',
                    style: AppStyles.h1.copyWith(
                      height: 1.2,
                      fontSize: 28,
                      color: AppStyles.textPrimary,
                      fontWeight: AppStyles.semiBold,
                      letterSpacing: -1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 32),

                // Centered Selected Task Card with Animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppStyles.backgroundWhite,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: selectedTaskData.color,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            selectedTaskData.icon,
                            size: 44,
                            color: AppStyles.textPrimary.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            selectedTaskData.title,
                            style: AppStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: AppStyles.textBlack,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Sub-options Grid
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: subOptions.length,
                    itemBuilder: (context, index) {
                      final subOption = subOptions[index];
                      final isSelected = _selectedSubTasks.contains(subOption.id);

                      return GestureDetector(
                        onTap: () => _toggleSubTask(subOption.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
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
                          child: Center(
                            child: Text(
                              subOption.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: AppStyles.textBlack,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Fixed Continue Button at Bottom
        FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
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
                onPressed: _selectedSubTasks.isNotEmpty
                    ? () => widget.onSubTaskSelected(_selectedSubTasks.toList())
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedSubTasks.isNotEmpty
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
        ),
      ],
    );
  }
}

class TaskOption {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  TaskOption({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class SubTaskOption {
  final String id;
  final String title;

  SubTaskOption({
    required this.id,
    required this.title,
  });
}