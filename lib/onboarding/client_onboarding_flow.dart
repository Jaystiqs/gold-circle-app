import 'package:flutter/material.dart';
import 'package:goldcircle/onboarding/models/onboarding_data.dart';
import 'package:goldcircle/onboarding/widgets/onboarding_progressbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/consolidated_auth.dart';
import '../utils/app_styles.dart';

// Import all pages
import 'client/client_tasks.dart';
import 'client/client_ai_info_page.dart';
import 'client/client_priorities_page.dart';
import 'client/client_how_it_works_page.dart';
import 'client/client_additional_tasks_page.dart';
import 'client/client_ai_search_info_page.dart';
import 'client/client_discovery_page.dart';
import 'client/client_notifications_page.dart';

class ClientOnboardingFlow extends StatefulWidget {
  const ClientOnboardingFlow({super.key});

  @override
  State<ClientOnboardingFlow> createState() => _ClientOnboardingFlowState();
}

class _ClientOnboardingFlowState extends State<ClientOnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 9; // Updated to reflect actual number of pages

  // Store onboarding data
  final OnboardingData _onboardingData = OnboardingData(userType: 'client');

  // Store selections
  String? _selectedMainTask;
  String? _selectedSubTask;

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
    await prefs.setString('user_type', 'client');

    // Save onboarding data
    print('Client Onboarding Data: ${_onboardingData.toJson()}');

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
                    //1. What tasks will you want done on Gold Circle
                    ClientTasksPage(
                      onTaskSelected: (taskId) {
                        setState(() {
                          _selectedMainTask = taskId;
                          _onboardingData.primaryTask = taskId;
                        });
                        _nextPage();
                      },
                    ),

                    //2. How would you like that task done? (Task chosen in 1)
                    if (_selectedMainTask != null)
                      ClientSubTasksPage(
                        selectedMainTask: _selectedMainTask!,
                        onSubTaskSelected: (subTaskIds) {
                          setState(() {
                            _onboardingData.taskPreferences = subTaskIds;
                          });
                          _nextPage();
                        },
                      )
                    else
                    // Fallback if somehow main task isn't selected
                      Center(child: CircularProgressIndicator()),

                    //3. Gold Circle uses AI and smart algorithms to connect you to talented professions to get your tasks done
                    ClientAIInfoPage(
                      onContinue: _nextPage,
                    ),

                    //4. What is important to you? (Finding the right talent, Meeting a tight deadline, etc)
                    ClientPrioritiesPage(
                      onPrioritiesSelected: (priorities) {
                        setState(() {
                          _onboardingData.priorities = priorities;
                        });
                        _nextPage();
                      },
                    ),

                    //5. How it works (Shows steps of the process. 1.You tell us what you need. 2.We find the best matches. 3. You choose who to work with.)
                    ClientHowItWorksPage(
                      onContinue: _nextPage,
                    ),

                    //6. Do you have other tasks you would want done. (Multiselect of different tasks in a grid)
                    ClientAdditionalTasksPage(
                      selectedMainTask: _selectedMainTask,
                      onTasksSelected: (additionalTasks) {
                        setState(() {
                          _onboardingData.additionalTasks = additionalTasks;
                        });
                        _nextPage();
                      },
                    ),

                    //7. Gold Circle has intelligent AI powered search help you find the right professional for your task
                    ClientAISearchInfoPage(
                      onContinue: _nextPage,
                    ),

                    //8. How did you hear about us?
                    ClientDiscoveryPage(
                      onSourceSelected: (source) {
                        setState(() {
                          _onboardingData.referralSource = source;
                        });
                        _nextPage();
                      },
                    ),

                    //9. Let us keep you up to date (Turn on notifications)
                    ClientNotificationsPage(
                      onContinue: _nextPage,
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