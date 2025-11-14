import 'package:flutter/material.dart';
import 'package:goldcircle/onboarding/client/client_discovery_page.dart';
import 'package:goldcircle/onboarding/client/client_notifications_page.dart';
import 'package:goldcircle/onboarding/models/onboarding_data.dart';
import 'package:goldcircle/onboarding/creator/creator_availability_page.dart';
import 'package:goldcircle/onboarding/creator/creator_benefits_page.dart';
import 'package:goldcircle/onboarding/creator/creator_experience_page.dart';
import 'package:goldcircle/onboarding/creator/creator_explore_tasks_page.dart';
import 'package:goldcircle/onboarding/creator/creator_goal_page.dart';
import 'package:goldcircle/onboarding/creator/creator_how_it_works_page.dart';
import 'package:goldcircle/onboarding/creator/creator_services_page.dart';
import 'package:goldcircle/onboarding/creator/creator_skills_page.dart';
import 'package:goldcircle/onboarding/widgets/onboarding_progressbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_styles.dart';
import '../auth/consolidated_auth.dart';

// Import creator pages
class CreatorOnboardingFlow extends StatefulWidget {
  const CreatorOnboardingFlow({super.key});

  @override
  State<CreatorOnboardingFlow> createState() => _CreatorOnboardingFlowState();
}

class _CreatorOnboardingFlowState extends State<CreatorOnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 11; // Updated to 10 pages

  // Store onboarding data
  final OnboardingData _onboardingData = OnboardingData(userType: 'creator');

  // Store selections
  String? _selectedPrimaryService;
  List<String>? _selectedSkills;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    // Mark onboarding as complete
    _onboardingData.isComplete = true;

    // Save onboarding completion status to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_onboarding', true);
    await prefs.setString('user_type', 'creator');

    // Save onboarding data
    print('Creator Onboarding Data: ${_onboardingData.toJson()}');

    // Navigate to sign up with onboarding data
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ConsolidatedAuthPage(
            onboardingData: _onboardingData,
          ),
        ),
      );
    }
  }

  double get _progress => (_currentPage + 1) / _totalPages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            OnboardingProgressBar(
              progress: _progress,
              onBack: _currentPage > 0
                  ? _previousPage
                  : () => Navigator.pop(context),
            ),

            // Pages
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  overscroll: false,
                  physics: const ClampingScrollPhysics(),
                ),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    //1. What's your main service offering?
                    CreatorServicesPage(
                      onServiceSelected: (serviceId) {
                        setState(() {
                          _selectedPrimaryService = serviceId;
                          _onboardingData.primaryService = serviceId;
                        });
                        _nextPage();
                      },
                    ),

                    //2. Specific skills/specializations (based on service selected in page 1)
                    if (_selectedPrimaryService != null)
                      CreatorSkillsPage(
                        selectedPrimaryService: _selectedPrimaryService!,
                        onSkillsSelected: (skills) {
                          setState(() {
                            _selectedSkills = skills;
                            _onboardingData.skills = skills;
                          });
                          _nextPage();
                        },
                      )
                    else
                      Center(child: CircularProgressIndicator()),

                    //3. Experience level
                    CreatorExperiencePage(
                      onExperienceSelected: (experienceLevel) {
                        setState(() {
                          _onboardingData.experienceLevel = experienceLevel;
                        });
                        _nextPage();
                      },
                    ),

                    //4. Platform benefits (Informational)
                    CreatorBenefitsPage(
                      onContinue: _nextPage,
                    ),

                    //5. Goal/Motivation
                    CreatorGoalPage(
                      onGoalSelected: (goal) {
                        setState(() {
                          _onboardingData.goal = goal;
                        });
                        _nextPage();
                      },
                    ),

                    //6. Availability/Capacity
                    CreatorAvailabilityPage(
                      onAvailabilitySelected: (availability) {
                        setState(() {
                          _onboardingData.availability = availability;
                        });
                        _nextPage();
                      },
                    ),

                    //7. How it works (Informational)
                    CreatorHowItWorksPage(
                      onContinue: _nextPage,
                    ),

                    // 8.
                    //8. Explore opportunities (Informational)
                    CreatorExploreTasksPage(
                      onContinue: _nextPage,
                    ),

                    //9. How did you hear about us?
                    ClientDiscoveryPage(
                      onSourceSelected: (source) {
                        setState(() {
                          _onboardingData.referralSource = source;
                        });
                        _nextPage();
                      },
                    ),

                    //10. Enable notifications
                    ClientNotificationsPage(
                      onContinue: _completeOnboarding,
                    ),

                    //10. This will trigger signup which is handled in _completeOnboarding()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}