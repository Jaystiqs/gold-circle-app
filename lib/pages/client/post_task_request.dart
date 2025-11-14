import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../utils/app_styles.dart';
import 'task_request_steps/assets_step.dart';
import 'task_request_steps/budget_step.dart';
import 'task_request_steps/category_step.dart';
import 'task_request_steps/description_step.dart';
import 'task_request_steps/service_category.dart';
import 'task_request_steps/timeline_step.dart';
import 'task_request_steps/title_step.dart';
import 'task_request_steps/summary_step.dart';

class PostTaskRequestPage extends StatefulWidget {
  const PostTaskRequestPage({super.key});

  @override
  State<PostTaskRequestPage> createState() => _PostTaskRequestPageState();
}

class _PostTaskRequestPageState extends State<PostTaskRequestPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 7;

  // Form data
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _googleDriveUrlController = TextEditingController();
  final _dropboxUrlController = TextEditingController();
  final _otherUrlController = TextEditingController();
  String? _selectedCategory;
  String? _selectedCategoryId;
  RangeValues _budgetRange = const RangeValues(200, 5000);
  String _selectedTimelineCategory = 'Days';
  double _daysValue = 7.0;
  double _weeksValue = 2.0;
  double _monthsValue = 3.0;
  List<String> _selectedSkills = [];

  // Firestore data
  List<ServiceCategory> _categories = [];
  bool _isLoadingCategories = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();

    // Add listeners to text controllers to rebuild when text changes
    _titleController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
    _googleDriveUrlController.addListener(() => setState(() {}));
    _dropboxUrlController.addListener(() => setState(() {}));
    _otherUrlController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _googleDriveUrlController.dispose();
    _dropboxUrlController.dispose();
    _otherUrlController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Map category icon strings to Phosphor icons
  IconData _getCategoryIcon(String iconName) {
    const iconMap = {
      'paintBrush': PhosphorIconsRegular.paintBrush,
      'monitor': PhosphorIconsRegular.monitor,
      'devices': PhosphorIconsRegular.devices,
      'pencilCircle': PhosphorIconsRegular.pencilCircle,
      'cube': PhosphorIconsRegular.cube,
      'printer': PhosphorIconsRegular.printer,
      'tShirt': PhosphorIconsRegular.tShirt,
      'identificationBadge': PhosphorIconsRegular.identificationBadge,
      'globe': PhosphorIconsRegular.globe,
      'deviceMobile': PhosphorIconsRegular.deviceMobile,
      'terminal': PhosphorIconsRegular.terminal,
      'gameController': PhosphorIconsRegular.gameController,
      'database': PhosphorIconsRegular.database,
      'article': PhosphorIconsRegular.article,
      'megaphone': PhosphorIconsRegular.megaphone,
      'fileDoc': PhosphorIconsRegular.fileDoc,
      'feather': PhosphorIconsRegular.feather,
      'textAa': PhosphorIconsRegular.textAa,
      'handCoins': PhosphorIconsRegular.handCoins,
      'user': PhosphorIconsRegular.user,
      'chartLineUp': PhosphorIconsRegular.chartLineUp,
      'shareNetwork': PhosphorIconsRegular.shareNetwork,
      'envelope': PhosphorIconsRegular.envelope,
      'newspaper': PhosphorIconsRegular.newspaper,
      'users': PhosphorIconsRegular.users,
      'target': PhosphorIconsRegular.target,
      'filmStrip': PhosphorIconsRegular.filmStrip,
      'play': PhosphorIconsRegular.play,
      'camera': PhosphorIconsRegular.camera,
      'waveform': PhosphorIconsRegular.waveform,
      'microphone': PhosphorIconsRegular.microphone,
      'broadcast': PhosphorIconsRegular.broadcast,
      'briefcase': PhosphorIconsRegular.briefcase,
    };

    return iconMap[iconName] ?? PhosphorIconsRegular.briefcase;
  }

  Future<void> _loadCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      if (mounted) {
        setState(() {
          _categories = snapshot.docs
              .map((doc) => ServiceCategory.fromFirestore(doc))
              .toList();
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCategories = false);
      }
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedCategory != null && _selectedCategoryId != null;
      case 1:
        return _titleController.text.trim().isNotEmpty;
      case 2:
        return _descriptionController.text.trim().isNotEmpty;
      case 3:
        return true; // Budget always has a value
      case 4:
        return true; // Timeline always has a value
      case 5:
        return true; // Assets step is optional
      case 6:
        return true; // Summary step - ready to submit
      default:
        return false;
    }
  }

  Future<void> _submitTask() async {
    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data();
      final clientName = userData?['fullName'] ??
          userData?['firstName'] ??
          user.displayName ??
          'Anonymous Client';

      // Collect asset URLs
      final List<String> assetUrls = [];
      if (_googleDriveUrlController.text.trim().isNotEmpty) {
        assetUrls.add(_googleDriveUrlController.text.trim());
      }
      if (_dropboxUrlController.text.trim().isNotEmpty) {
        assetUrls.add(_dropboxUrlController.text.trim());
      }
      if (_otherUrlController.text.trim().isNotEmpty) {
        assetUrls.add(_otherUrlController.text.trim());
      }

      final taskRequest = {
        'clientId': user.uid,
        'clientName': clientName,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory!,
        'categoryId': _selectedCategoryId!,
        'budgetMin': _budgetRange.start,
        'budgetMax': _budgetRange.end,
        'timeline': _getTimelineString(),
        'timelineValue': _getCurrentTimelineValue(),
        'timelineUnit': _selectedTimelineCategory.toLowerCase(),
        'skills': _selectedSkills,
        'assetUrls': assetUrls,
        'status': 'open',
        'proposalCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('task_requests')
          .add(taskRequest);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Task request posted successfully!')),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  double _getCurrentTimelineValue() {
    switch (_selectedTimelineCategory) {
      case 'Days':
        return _daysValue;
      case 'Weeks':
        return _weeksValue;
      case 'Months':
        return _monthsValue;
      default:
        return _daysValue;
    }
  }

  String _getTimelineString() {
    final value = _getCurrentTimelineValue().round();
    String unit;
    switch (_selectedTimelineCategory) {
      case 'Days':
        unit = value == 1 ? 'day' : 'days';
        break;
      case 'Weeks':
        unit = value == 1 ? 'week' : 'weeks';
        break;
      case 'Months':
        unit = value == 1 ? 'month' : 'months';
        break;
      default:
        unit = 'days';
    }
    return '$value $unit';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  CategoryStep(
                    categories: _categories,
                    isLoading: _isLoadingCategories,
                    selectedCategoryId: _selectedCategoryId,
                    getCategoryIcon: _getCategoryIcon,
                    onCategorySelected: (category, categoryId) {
                      setState(() {
                        _selectedCategory = category;
                        _selectedCategoryId = categoryId;
                      });
                    },
                  ),
                  TitleStep(controller: _titleController),
                  DescriptionStep(controller: _descriptionController),
                  BudgetStep(
                    budgetRange: _budgetRange,
                    onBudgetChanged: (range) {
                      setState(() => _budgetRange = range);
                    },
                  ),
                  TimelineStep(
                    selectedCategory: _selectedTimelineCategory,
                    currentValue: _getCurrentTimelineValue(),
                    onCategoryChanged: (category) {
                      setState(() => _selectedTimelineCategory = category);
                    },
                    onValueChanged: (value) {
                      setState(() {
                        switch (_selectedTimelineCategory) {
                          case 'Days':
                            _daysValue = value;
                            break;
                          case 'Weeks':
                            _weeksValue = value;
                            break;
                          case 'Months':
                            _monthsValue = value;
                            break;
                        }
                      });
                    },
                  ),
                  AssetsStep(
                    googleDriveController: _googleDriveUrlController,
                    dropboxController: _dropboxUrlController,
                    otherController: _otherUrlController,
                  ),
                  SummaryStep(
                    category: _selectedCategory ?? '',
                    title: _titleController.text.trim(),
                    description: _descriptionController.text.trim(),
                    budgetRange: _budgetRange,
                    timeline: _getTimelineString(),
                    assetUrls: [
                      if (_googleDriveUrlController.text.trim().isNotEmpty)
                        _googleDriveUrlController.text.trim(),
                      if (_dropboxUrlController.text.trim().isNotEmpty)
                        _dropboxUrlController.text.trim(),
                      if (_otherUrlController.text.trim().isNotEmpty)
                        _otherUrlController.text.trim(),
                    ],
                  ),
                ],
              ),
            ),
            _buildProgressBar(),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 30),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Save & exit',
              style: TextStyle(
                color: AppStyles.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(_totalSteps, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < _totalSteps - 1 ? 8 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: index <= _currentStep
                  ? AppStyles.textPrimary
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            TextButton(
              onPressed: _previousStep,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              ),
              child: Text(
                'Back',
                style: TextStyle(
                  color: AppStyles.textPrimary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          if (_currentStep == 0)
            Expanded(
              child: ElevatedButton(
                onPressed: _canProceed() ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            ElevatedButton(
              onPressed: _canProceed()
                  ? (_currentStep == _totalSteps - 1 ? _submitTask : _nextStep)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.textPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text(
                _currentStep == _totalSteps - 1 ? 'Submit' : 'Next',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}