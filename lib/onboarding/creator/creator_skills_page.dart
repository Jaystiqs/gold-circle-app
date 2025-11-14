import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class CreatorSkillsPage extends StatefulWidget {
  final String selectedPrimaryService;
  final Function(List<String> skills) onSkillsSelected;

  const CreatorSkillsPage({
    super.key,
    required this.selectedPrimaryService,
    required this.onSkillsSelected,
  });

  @override
  State<CreatorSkillsPage> createState() => _CreatorSkillsPageState();
}

class _CreatorSkillsPageState extends State<CreatorSkillsPage>
    with SingleTickerProviderStateMixin {
  final Set<String> _selectedSkills = {};
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final Map<String, ServiceOption> _services = {
    'design': ServiceOption(
      id: 'design',
      title: 'Design & Creative',
      icon: Icons.palette_outlined,
      color: Color(0xFFE3F2FD),
    ),
    'development': ServiceOption(
      id: 'development',
      title: 'Development & Tech',
      icon: Icons.code,
      color: Color(0xFFF3E5F5),
    ),
    // 'writing': ServiceOption(
    //   id: 'writing',
    //   title: 'Writing & Content',
    //   icon: Icons.edit_note,
    //   color: Color(0xFFFFF3E0),
    // ),
    // 'marketing': ServiceOption(
    //   id: 'marketing',
    //   title: 'Marketing & Sales',
    //   icon: Icons.trending_up,
    //   color: Color(0xFFE8F5E9),
    // ),
    'social_media': ServiceOption(
      id: 'social_media',
      title: 'Social Media Mgt & UGC',
      icon: Icons.business_center_outlined,
      color: Color(0xFFFCE4EC),
    ),
  };

  final Map<String, List<SkillOption>> _skillsByService = {
    'design': [
      SkillOption(id: 'ui_ux', title: 'UI/UX Design'),
      SkillOption(id: 'graphic_design', title: 'Graphic Design'),
      SkillOption(id: 'brand_identity', title: 'Brand Identity'),
      SkillOption(id: 'illustration', title: 'Illustration'),
      SkillOption(id: 'logo_design', title: 'Logo Design'),
      SkillOption(id: 'print_design', title: 'Print Design'),
      SkillOption(id: 'presentation_design', title: 'Presentation Design'),
      SkillOption(id: '3d_design', title: '3D Design'),
    ],
    'development': [
      SkillOption(id: 'web_development', title: 'Web Development'),
      SkillOption(id: 'mobile_apps', title: 'Mobile Apps'),
      SkillOption(id: 'backend_development', title: 'Backend Development'),
      SkillOption(id: 'wordpress', title: 'WordPress'),
      SkillOption(id: 'ecommerce', title: 'E-commerce Development'),
      SkillOption(id: 'frontend', title: 'Frontend Development'),
      SkillOption(id: 'fullstack', title: 'Full Stack Development'),
      SkillOption(id: 'api_development', title: 'API Development'),
    ],
    // 'writing': [
    //   SkillOption(id: 'content_writing', title: 'Content Writing'),
    //   SkillOption(id: 'copywriting', title: 'Copywriting'),
    //   SkillOption(id: 'blog_writing', title: 'Blog Writing'),
    //   SkillOption(id: 'technical_writing', title: 'Technical Writing'),
    //   SkillOption(id: 'seo_writing', title: 'SEO Writing'),
    //   SkillOption(id: 'scriptwriting', title: 'Scriptwriting'),
    //   SkillOption(id: 'editing', title: 'Editing & Proofreading'),
    //   SkillOption(id: 'ghostwriting', title: 'Ghostwriting'),
    // ],
    // 'marketing': [
    //   SkillOption(id: 'digital_marketing', title: 'Digital Marketing'),
    //   SkillOption(id: 'seo', title: 'SEO'),
    //   SkillOption(id: 'email_marketing', title: 'Email Marketing'),
    //   SkillOption(id: 'marketing_strategy', title: 'Marketing Strategy'),
    //   SkillOption(id: 'content_marketing', title: 'Content Marketing'),
    //   SkillOption(id: 'paid_ads', title: 'Paid Advertising'),
    //   SkillOption(id: 'analytics', title: 'Analytics & Reporting'),
    //   SkillOption(id: 'brand_marketing', title: 'Brand Marketing'),
    // ],
    'social_media': [
      SkillOption(id: 'social_media_management', title: 'Social Media Management'),
      SkillOption(id: 'content_creation', title: 'Content Creation'),
      SkillOption(id: 'ugc', title: 'User Generated Content'),
      SkillOption(id: 'community_management', title: 'Community Management'),
      SkillOption(id: 'social_media_ads', title: 'Social Media Advertising'),
      SkillOption(id: 'influencer_marketing', title: 'Influencer Marketing'),
      SkillOption(id: 'video_content', title: 'Video Content'),
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSkill(String skillId) {
    setState(() {
      if (_selectedSkills.contains(skillId)) {
        _selectedSkills.remove(skillId);
      } else {
        _selectedSkills.add(skillId);
      }
    });
  }

  void _continue() {
    if (_selectedSkills.isNotEmpty) {
      widget.onSkillsSelected(_selectedSkills.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedServiceData = _services[widget.selectedPrimaryService];
    final skillOptions = _skillsByService[widget.selectedPrimaryService] ?? [];

    if (selectedServiceData == null) {
      return Center(
        child: Text('Service not found'),
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
                    'What are your\nspecific skills?',
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

                // Centered Selected Service Card with Animation
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
                            color: selectedServiceData.color,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            selectedServiceData.icon,
                            size: 44,
                            color: AppStyles.textPrimary.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            selectedServiceData.title,
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

                // Subtitle
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Select all that apply',
                    style: AppStyles.bodyLarge.copyWith(
                      fontSize: 16,
                      color: AppStyles.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),

                // Skills Grid
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
                    itemCount: skillOptions.length,
                    itemBuilder: (context, index) {
                      final skill = skillOptions[index];
                      final isSelected = _selectedSkills.contains(skill.id);

                      return GestureDetector(
                        onTap: () => _toggleSkill(skill.id),
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
                              skill.title,
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
                onPressed: _selectedSkills.isNotEmpty ? _continue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedSkills.isNotEmpty
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
                  _selectedSkills.isEmpty
                      ? 'Select at least one skill'
                      : 'Continue with ${_selectedSkills.length} skill${_selectedSkills.length == 1 ? '' : 's'}',
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

class ServiceOption {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  ServiceOption({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class SkillOption {
  final String id;
  final String title;

  SkillOption({
    required this.id,
    required this.title,
  });
}