import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../utils/app_styles.dart';
import 'offer_steps/category_step.dart';
import 'offer_steps/pricing_step.dart';
import 'offer_steps/subcategory_step.dart';
import 'offer_steps/timeline_step.dart';
import 'offer_steps/title_step.dart';
import 'offer_steps/description_step.dart';

class PostOfferPage extends StatefulWidget {
  const PostOfferPage({super.key});

  @override
  State<PostOfferPage> createState() => _PostOfferPageState();
}

class _PostOfferPageState extends State<PostOfferPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 9;

  // Form data
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedCategoryId;
  String? _selectedSubcategory;
  String? _selectedSubcategoryId;
  double _basePrice = 500;
  double? _originalPrice;
  int _productionDays = 3;
  int _deliveryDays = 5;
  int _revisions = 2;
  List<DeliverableItem> _deliverables = [];
  List<String> _galleryUrls = [];
  List<AddOnItem> _addOns = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to text controllers
    _titleController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pageController.dispose();
    super.dispose();
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
        return _selectedSubcategory != null && _selectedSubcategoryId != null;
      case 2:
        return _titleController.text.trim().isNotEmpty;
      case 3:
        return _descriptionController.text.trim().isNotEmpty;
      case 4:
        return _basePrice > 0;
      case 5:
        return _productionDays > 0 && _deliveryDays > 0;
      case 6:
        return _deliverables.isNotEmpty;
      case 7:
        return _galleryUrls.isNotEmpty;
      case 8:
        return true; // Summary step - ready to submit
      default:
        return false;
    }
  }

  Future<void> _submitOffer() async {
    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data();
      final providerName = userData?['fullName'] ??
          userData?['firstName'] ??
          user.displayName ??
          'Anonymous Provider';

      final offer = {
        'providerId': user.uid,
        'providerName': providerName,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedCategory!,
        'categoryId': _selectedCategoryId!,
        'subcategory': _selectedSubcategory!,
        'subcategoryId': _selectedSubcategoryId!,
        'basePrice': _basePrice,
        'originalPrice': _originalPrice,
        'productionDays': _productionDays,
        'deliveryDays': _deliveryDays,
        'revisions': _revisions,
        'deliverables': _deliverables
            .map((d) => {
          'icon': d.icon,
          'title': d.title,
          'description': d.description,
        })
            .toList(),
        'galleryUrls': _galleryUrls,
        'addOns': _addOns
            .map((a) => {
          'title': a.title,
          'description': a.description,
          'price': a.price,
        })
            .toList(),
        'status': 'active',
        'orderCount': 0,
        'rating': 0.0,
        'reviewCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('offers').add(offer);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(child: Text('Offer published successfully!')),
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
                  OfferCategoryStep(
                    selectedCategoryId: _selectedCategoryId,
                    onCategorySelected: (category, categoryId) {
                      setState(() {
                        _selectedCategory = category;
                        _selectedCategoryId = categoryId;
                        // Reset subcategory when category changes
                        _selectedSubcategory = null;
                        _selectedSubcategoryId = null;
                      });
                    },
                  ),
                  if (_selectedCategoryId != null)
                    OfferSubcategoryStep(
                      categoryId: _selectedCategoryId!,
                      categoryName: _selectedCategory!,
                      selectedSubcategoryId: _selectedSubcategoryId,
                      onSubcategorySelected: (subcategory, subcategoryId) {
                        setState(() {
                          _selectedSubcategory = subcategory;
                          _selectedSubcategoryId = subcategoryId;
                        });
                      },
                    )
                  else
                    Center(
                      child: Text(
                        'Please select a category first',
                        style: AppStyles.bodyLarge,
                      ),
                    ),
                  OfferTitleStep(controller: _titleController),
                  OfferDescriptionStep(controller: _descriptionController),
                  OfferPricingStep(
                    basePrice: _basePrice,
                    onBasePriceChanged: (price) {
                      setState(() => _basePrice = price);
                    },
                  ),
                  OfferTimelineStep(
                    productionDays: _productionDays,
                    deliveryDays: _deliveryDays,
                    revisions: _revisions,
                    onProductionDaysChanged: (days) {
                      setState(() => _productionDays = days);
                    },
                    onDeliveryDaysChanged: (days) {
                      setState(() => _deliveryDays = days);
                    },
                    onRevisionsChanged: (revisions) {
                      setState(() => _revisions = revisions);
                    },
                  ),
                  // TODO: Add remaining steps (delivery time, deliverables, gallery, add-ons, summary)
                  Center(
                    child: Text(
                      'Step ${_currentStep + 1}',
                      style: AppStyles.h3,
                    ),
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
          Text(
            'Create Offer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppStyles.textPrimary,
            ),
          ),
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
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
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
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
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
                  ? (_currentStep == _totalSteps - 1 ? _submitOffer : _nextStep)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.textPrimary,
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                _currentStep == _totalSteps - 1 ? 'Publish Offer' : 'Next',
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

// Data models
class DeliverableItem {
  final String icon;
  final String title;
  final String description;

  DeliverableItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class AddOnItem {
  final String title;
  final String description;
  final double price;

  AddOnItem({
    required this.title,
    required this.description,
    required this.price,
  });
}