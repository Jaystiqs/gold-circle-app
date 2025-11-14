import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class ClientAdditionalTasksPage extends StatefulWidget {
  final String? selectedMainTask;
  final Function(List<String> additionalTasks) onTasksSelected;

  const ClientAdditionalTasksPage({
    super.key,
    this.selectedMainTask,
    required this.onTasksSelected,
  });

  @override
  State<ClientAdditionalTasksPage> createState() =>
      _ClientAdditionalTasksPageState();
}

class _ClientAdditionalTasksPageState extends State<ClientAdditionalTasksPage> {
  final Set<String> _selectedTasks = {};

  final List<TaskOption> _allTasks = [
    TaskOption(
      id: 'website_building',
      title: 'Website Building',
      icon: Icons.language,
      color: Color(0xFFE3F2FD),
    ),
    TaskOption(
      id: 'mobile_app',
      title: 'Mobile App',
      icon: Icons.phone_android,
      color: Color(0xFFF3E5F5),
    ),
    TaskOption(
      id: 'logo_design',
      title: 'Logo Design',
      icon: Icons.brush,
      color: Color(0xFFFFF3E0),
    ),
    TaskOption(
      id: 'social_media_content',
      title: 'Social Media Content',
      icon: Icons.camera_alt,
      color: Color(0xFFFCE4EC),
    ),
    TaskOption(
      id: 'video_editing',
      title: 'Video Editing',
      icon: Icons.videocam,
      color: Color(0xFFFFEBEE),
    ),
    TaskOption(
      id: 'copywriting',
      title: 'Copywriting',
      icon: Icons.edit_note,
      color: Color(0xFFF1F8E9),
    ),
    TaskOption(
      id: 'seo_optimization',
      title: 'SEO Optimization',
      icon: Icons.search,
      color: Color(0xFFE8F5E9),
    ),
    TaskOption(
      id: 'graphic_design',
      title: 'Graphic Design',
      icon: Icons.palette,
      color: Color(0xFFE1F5FE),
    ),
    TaskOption(
      id: 'content_writing',
      title: 'Content Writing',
      icon: Icons.article,
      color: Color(0xFFFFF9C4),
    ),
    TaskOption(
      id: 'brand_identity',
      title: 'Brand Identity',
      icon: Icons.fingerprint,
      color: Color(0xFFE0F2F1),
    ),
    TaskOption(
      id: 'email_marketing',
      title: 'Email Marketing',
      icon: Icons.email,
      color: Color(0xFFF3E5F5),
    ),
    TaskOption(
      id: 'animation',
      title: 'Animation',
      icon: Icons.animation,
      color: Color(0xFFFFCCBC),
    ),
    TaskOption(
      id: 'art_design',
      title: 'Art & Design Work',
      icon: Icons.color_lens,
      color: Color(0xFFFFE0B2),
    ),
    TaskOption(
      id: 'architectural_plans',
      title: 'Architectural Plans',
      icon: Icons.architecture,
      color: Color(0xFFD1C4E9),
    ),
    TaskOption(
      id: 'interior_design',
      title: 'Interior Design',
      icon: Icons.living,
      color: Color(0xFFB2DFDB),
    ),
    TaskOption(
      id: '3d_modeling',
      title: '3D Modeling',
      icon: Icons.view_in_ar,
      color: Color(0xFFFFCDD2),
    ),
    TaskOption(
      id: 'illustration',
      title: 'Illustration',
      icon: Icons.draw,
      color: Color(0xFFF0F4C3),
    ),
    TaskOption(
      id: 'ui_ux_design',
      title: 'UI/UX Design',
      icon: Icons.phonelink,
      color: Color(0xFFBBDEFB),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select the main task if it exists in the list
    if (widget.selectedMainTask != null &&
        _allTasks.any((task) => task.id == widget.selectedMainTask)) {
      _selectedTasks.add(widget.selectedMainTask!);
    }
  }

  void _toggleTask(String taskId) {
    // Don't allow deselecting the main task
    if (taskId == widget.selectedMainTask) return;

    setState(() {
      if (_selectedTasks.contains(taskId)) {
        _selectedTasks.remove(taskId);
      } else {
        _selectedTasks.add(taskId);
      }
    });
  }

  void _continue() {
    // Return all selected tasks except the main one (which is already stored)
    final additionalTasks = _selectedTasks
        .where((task) => task != widget.selectedMainTask)
        .toList();
    widget.onTasksSelected(additionalTasks);
  }

  @override
  Widget build(BuildContext context) {
    final hasAdditionalSelections = _selectedTasks.any(
            (task) => widget.selectedMainTask == null || task != widget.selectedMainTask);

    return Column(
      children: [
        // Fixed Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
          child: Column(
            children: [
              // Title
              Text(
                'Do you have other tasks \nin mind for the future?',
                style: AppStyles.h1.copyWith(
                  height: 1.0,
                  fontSize: 32,
                  color: AppStyles.textPrimary,
                  fontWeight: AppStyles.bold,
                  letterSpacing: -1.0,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Select all that apply',
                style: AppStyles.bodyLarge.copyWith(
                  fontSize: 16,
                  color: AppStyles.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // Scrollable Task Grid
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.90,
                  ),
                  itemCount: _allTasks.length,
                  itemBuilder: (context, index) {
                    final task = _allTasks[index];
                    final isSelected = _selectedTasks.contains(task.id);
                    final isMainTask = widget.selectedMainTask != null &&
                        task.id == widget.selectedMainTask;

                    return GestureDetector(
                      onTap: () => _toggleTask(task.id),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppStyles.backgroundWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? (isMainTask
                                ? AppStyles.goldPrimary
                                : AppStyles.textBlack)
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
                        child: Stack(
                          children: [
                            // Main Content
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
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
                                      color:
                                      AppStyles.textPrimary.withOpacity(0.8),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Title
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Text(
                                      task.title,
                                      style: AppStyles.bodyMedium.copyWith(
                                        fontWeight: AppStyles.medium,
                                        fontSize: 15,
                                        color: AppStyles.textBlack,
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // "Your main task" badge
                            if (isMainTask)
                              Positioned(
                                bottom: 8,
                                left: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppStyles.goldPrimary.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Main task',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppStyles.goldPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
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

        // Fixed Buttons at Bottom
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
              onPressed: _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.textBlack,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                hasAdditionalSelections
                    ? 'Continue with ${_selectedTasks.length - (widget.selectedMainTask != null && _selectedTasks.contains(widget.selectedMainTask) ? 1 : 0)} additional task${_selectedTasks.length - (widget.selectedMainTask != null && _selectedTasks.contains(widget.selectedMainTask) ? 1 : 0) == 1 ? '' : 's'}'
                    : 'Continue',
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