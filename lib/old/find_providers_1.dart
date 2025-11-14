// import 'package:flutter/material.dart';
// import 'package:goldcircle/pages/client/client_creators_list.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:math' as math;
// import '../../app_styles.dart';
// import '../../utils/circular_timeline_selector.dart';
// import '../../utils/custom_smooth_slider.dart';
//
// // Data model for passing search criteria between pages
// class SearchCriteria {
//   final String selectedCategory;
//   final String selectedCategoryId;
//   final String selectedBudget;
//   final RangeValues budgetRange;
//   final String selectedTimeline;
//   final String timelineCategory;
//   final double timelineValue;
//   final String? projectDescription;
//   final String? searchQuery;
//
//   SearchCriteria({
//     required this.selectedCategory,
//     required this.selectedCategoryId,
//     required this.selectedBudget,
//     required this.budgetRange,
//     required this.selectedTimeline,
//     required this.timelineCategory,
//     required this.timelineValue,
//     this.projectDescription,
//     this.searchQuery,
//   });
// }
//
// // Data models
// class ServiceCategory {
//   final String id;
//   final String name;
//   final String displayName;
//   final String icon;
//   final String description;
//   final String? parentId;
//   final bool isActive;
//   final int sortOrder;
//
//   // Mock data for display purposes - in real app these would come from provider aggregation
//   final int available;
//   final double rating;
//
//   ServiceCategory({
//     required this.id,
//     required this.name,
//     required this.displayName,
//     required this.icon,
//     required this.description,
//     this.parentId,
//     required this.isActive,
//     required this.sortOrder,
//     this.available = 0,
//     this.rating = 4.5,
//   });
//
//   factory ServiceCategory.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return ServiceCategory(
//       id: doc.id,
//       name: data['name'] ?? '',
//       displayName: data['displayName'] ?? '',
//       icon: data['icon'] ?? '',
//       description: data['description'] ?? '',
//       parentId: data['parentId'],
//       isActive: data['isActive'] ?? true,
//       sortOrder: data['sortOrder'] ?? 0,
//       available: math.Random().nextInt(20) + 1, // Mock data
//       rating: 4.0 + math.Random().nextDouble(), // Mock data
//     );
//   }
//
//   bool get isParentCategory => parentId == null;
//   bool get isSubCategory => parentId != null;
// }
//
// class FindProvidersPage extends StatefulWidget {
//   const FindProvidersPage({super.key});
//
//   @override
//   State<FindProvidersPage> createState() => _FindProvidersPageState();
// }
//
// class _FindProvidersPageState extends State<FindProvidersPage>
//     with TickerProviderStateMixin {
//   int _currentStep = 0;
//
//   // Form data
//   String? selectedCategory;
//   String? selectedTimeline;
//   String? projectDescription;
//
//   // Budget range slider values
//   RangeValues budgetRange = const RangeValues(200, 5000);
//   static const double minBudget = 100;
//   static const double maxBudget = 20000;
//
//   // Expanded states for each section
//   bool isCategoryExpanded = true;
//   bool isBudgetExpanded = false;
//   bool isTimelineExpanded = false;
//   bool isDetailsExpanded = false;
//
//   // Timeline toggle state
//   String selectedTimelineCategory = 'Days'; // 'Days', 'Weeks', 'Months'
//
//   // Timeline values for each category
//   double daysValue = 7.0;
//   double weeksValue = 2.0;
//   double monthsValue = 3.0;
//
//   // Simplified animation properties
//   bool _isFullScreenMode = false;
//   String _searchQuery = '';
//   late AnimationController _expansionController;
//   late Animation<double> _scaleAnimation;
//
//   // Timeline toggle animation
//   late AnimationController _toggleAnimationController;
//   late Animation<double> _toggleAnimation;
//
//   // AI Search properties
//   bool _isAiSearchActive = false;
//   bool _isAiSearching = false;
//   List<ServiceCategory> _aiRecommendedCategories = [];
//   Timer? _aiSearchTimer;
//   late AnimationController _aiSearchAnimationController;
//   late Animation<double> _aiSearchSlideAnimation;
//   late Animation<double> _aiSearchFadeAnimation;
//
//   // Firestore data
//   List<ServiceCategory> _categories = [];
//   bool _isLoadingData = false;
//   String? _dataError;
//
//   // Recent searches
//   List<String> _recentSearches = [];
//   static const int _maxRecentSearches = 3;
//   static const String _recentSearchesKey = 'recent_searches';
//   bool _isLoadingRecentSearches = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _loadFirestoreData();
//     _updateTimelineFromCurrentValue();
//     _loadRecentSearches();
//   }
//
//   // Recent searches methods
//   Future<void> _loadRecentSearches() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//
//       if (user != null) {
//         await _loadRecentSearchesFromFirestore(user);
//       } else {
//         await _loadRecentSearchesFromLocal();
//       }
//     } catch (e) {
//       print('Error loading recent searches: $e');
//       setState(() {
//         _isLoadingRecentSearches = false;
//       });
//     }
//   }
//
//   Future<void> _loadRecentSearchesFromFirestore(User user) async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .collection('recent_searches')
//           .orderBy('timestamp', descending: true)
//           .limit(_maxRecentSearches)
//           .get();
//
//       final searches = snapshot.docs.map((doc) => doc.data()['query'] as String).toList();
//
//       setState(() {
//         _recentSearches = searches;
//         _isLoadingRecentSearches = false;
//       });
//     } catch (e) {
//       print('Error loading recent searches from Firestore: $e');
//       setState(() {
//         _isLoadingRecentSearches = false;
//       });
//     }
//   }
//
//   Future<void> _loadRecentSearchesFromLocal() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final searchesJson = prefs.getStringList(_recentSearchesKey) ?? [];
//
//       setState(() {
//         _recentSearches = searchesJson.take(_maxRecentSearches).toList();
//         _isLoadingRecentSearches = false;
//       });
//     } catch (e) {
//       print('Error loading recent searches from local storage: $e');
//       setState(() {
//         _isLoadingRecentSearches = false;
//       });
//     }
//   }
//
//   Future<void> _addToRecentSearches(String query) async {
//     if (query.trim().isEmpty) return;
//
//     String trimmedQuery = query.trim();
//
//     // Remove if already exists to avoid duplicates
//     _recentSearches.remove(trimmedQuery);
//
//     // Add to beginning
//     _recentSearches.insert(0, trimmedQuery);
//
//     // Keep only the last 3 searches
//     if (_recentSearches.length > _maxRecentSearches) {
//       _recentSearches = _recentSearches.take(_maxRecentSearches).toList();
//     }
//
//     setState(() {});
//
//     // Save to appropriate storage
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await _saveRecentSearchToFirestore(trimmedQuery, user);
//     } else {
//       await _saveRecentSearchToLocal();
//     }
//   }
//
//   Future<void> _saveRecentSearchToFirestore(String query, User user) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .collection('recent_searches')
//           .doc(query.toLowerCase().replaceAll(' ', '_'))
//           .set({
//         'query': query,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       // Clean up old searches (keep only the latest 10 in Firestore for buffer)
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .collection('recent_searches')
//           .orderBy('timestamp', descending: true)
//           .get();
//
//       if (snapshot.docs.length > 10) {
//         final docsToDelete = snapshot.docs.skip(10);
//         final batch = FirebaseFirestore.instance.batch();
//
//         for (final doc in docsToDelete) {
//           batch.delete(doc.reference);
//         }
//
//         await batch.commit();
//       }
//     } catch (e) {
//       print('Error saving recent search to Firestore: $e');
//     }
//   }
//
//   Future<void> _saveRecentSearchToLocal() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setStringList(_recentSearchesKey, _recentSearches);
//     } catch (e) {
//       print('Error saving recent searches to local storage: $e');
//     }
//   }
//
//   void _executeRecentSearch(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//     _startAiSearch(query);
//   }
//
//   // Animation and UI methods
//   void _initializeAnimations() {
//     _expansionController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _expansionController,
//       curve: Curves.easeOutCubic,
//     ));
//
//     _toggleAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//
//     _toggleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _toggleAnimationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _aiSearchAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//
//     _aiSearchSlideAnimation = Tween<double>(
//       begin: -50.0,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _aiSearchAnimationController,
//       curve: Curves.easeOutCubic,
//     ));
//
//     _aiSearchFadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _aiSearchAnimationController,
//       curve: Curves.easeOutCubic,
//     ));
//   }
//
//   Future<void> _loadFirestoreData() async {
//     try {
//       await _loadCategories();
//
//       if (mounted) {
//         setState(() {
//           // Data loaded successfully
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _dataError = 'Failed to load data: $e';
//         });
//       }
//       print('Error loading Firestore data: $e');
//     }
//   }
//
//   Future<void> _loadCategories() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('categories')
//         .where('isActive', isEqualTo: true)
//         .orderBy('sortOrder')
//         .get();
//
//     _categories = snapshot.docs.map((doc) => ServiceCategory.fromFirestore(doc)).toList();
//   }
//
//   // Map category icon strings to Phosphor icons
//   IconData _getCategoryIcon(String iconName) {
//     const iconMap = {
//       'paintBrush': PhosphorIconsRegular.paintBrush,
//       'monitor': PhosphorIconsRegular.monitor,
//       'devices': PhosphorIconsRegular.devices,
//       'pencilCircle': PhosphorIconsRegular.pencilCircle,
//       'cube': PhosphorIconsRegular.cube,
//       'printer': PhosphorIconsRegular.printer,
//       'tShirt': PhosphorIconsRegular.tShirt,
//       'identificationBadge': PhosphorIconsRegular.identificationBadge,
//       'globe': PhosphorIconsRegular.globe,
//       'deviceMobile': PhosphorIconsRegular.deviceMobile,
//       'terminal': PhosphorIconsRegular.terminal,
//       'gameController': PhosphorIconsRegular.gameController,
//       'database': PhosphorIconsRegular.database,
//       'article': PhosphorIconsRegular.article,
//       'megaphone': PhosphorIconsRegular.megaphone,
//       'fileDoc': PhosphorIconsRegular.fileDoc,
//       'feather': PhosphorIconsRegular.feather,
//       'textAa': PhosphorIconsRegular.textAa,
//       'handCoins': PhosphorIconsRegular.handCoins,
//       'user': PhosphorIconsRegular.user,
//       'chartLineUp': PhosphorIconsRegular.chartLineUp,
//       'shareNetwork': PhosphorIconsRegular.shareNetwork,
//       'envelope': PhosphorIconsRegular.envelope,
//       'newspaper': PhosphorIconsRegular.newspaper,
//       'users': PhosphorIconsRegular.users,
//       'target': PhosphorIconsRegular.target,
//       'filmStrip': PhosphorIconsRegular.filmStrip,
//       'play': PhosphorIconsRegular.play,
//       'camera': PhosphorIconsRegular.camera,
//       'waveform': PhosphorIconsRegular.waveform,
//       'microphone': PhosphorIconsRegular.microphone,
//       'broadcast': PhosphorIconsRegular.broadcast,
//     };
//
//     return iconMap[iconName] ?? PhosphorIconsRegular.briefcase;
//   }
//
//   @override
//   void dispose() {
//     _expansionController.dispose();
//     _toggleAnimationController.dispose();
//     _aiSearchAnimationController.dispose();
//     _aiSearchTimer?.cancel();
//     super.dispose();
//   }
//
//   // Budget ranges
//   final List<Map<String, dynamic>> commonBudgetRanges = [
//     {'label': 'Under GHS500', 'min': 100.0, 'max': 500.0},
//     {'label': 'GHS500-1K', 'min': 500.0, 'max': 1000.0},
//     {'label': 'GHS1K-3K', 'min': 1000.0, 'max': 3000.0},
//     {'label': 'GHS3K-5K', 'min': 3000.0, 'max': 5000.0},
//     {'label': 'GHS5K-10K', 'min': 5000.0, 'max': 10000.0},
//     {'label': 'GHS10K+', 'min': 10000.0, 'max': 20000.0},
//     {'label': 'Any Price', 'min': 100.0, 'max': 20000.0},
//   ];
//
//   void _startAiSearch(String query) {
//     if (query.isEmpty) {
//       _stopAiSearch();
//       return;
//     }
//
//     setState(() {
//       _isAiSearchActive = true;
//       _isAiSearching = true;
//     });
//
//     _aiSearchAnimationController.forward();
//
//     _aiSearchTimer?.cancel();
//
//     _aiSearchTimer = Timer(const Duration(milliseconds: 1500), () {
//       if (mounted) {
//         _generateAiRecommendations(query);
//       }
//     });
//   }
//
//   void _stopAiSearch() {
//     setState(() {
//       _isAiSearchActive = false;
//       _isAiSearching = false;
//       _aiRecommendedCategories.clear();
//     });
//     _aiSearchAnimationController.reverse();
//     _aiSearchTimer?.cancel();
//   }
//
//   void _generateAiRecommendations(String query) {
//     List<ServiceCategory> recommendations = [];
//     String queryLower = query.toLowerCase();
//
//     for (var category in _categories) {
//       int relevanceScore = 0;
//
//       if (category.name.toLowerCase().contains(queryLower) ||
//           category.displayName.toLowerCase().contains(queryLower)) {
//         relevanceScore += 100;
//       }
//
//       if (category.description.toLowerCase().contains(queryLower)) {
//         relevanceScore += 25;
//       }
//
//       if (relevanceScore > 0) {
//         recommendations.add(category);
//       }
//     }
//
//     recommendations.sort((a, b) => b.rating.compareTo(a.rating));
//
//     setState(() {
//       _isAiSearching = false;
//       _aiRecommendedCategories = recommendations.take(3).toList();
//     });
//   }
//
//   double get currentTimelineValue {
//     switch (selectedTimelineCategory) {
//       case 'Days':
//         return daysValue;
//       case 'Weeks':
//         return weeksValue;
//       case 'Months':
//         return monthsValue;
//       default:
//         return daysValue;
//     }
//   }
//
//   void setCurrentTimelineValue(double value) {
//     switch (selectedTimelineCategory) {
//       case 'Days':
//         daysValue = value;
//         break;
//       case 'Weeks':
//         weeksValue = value;
//         break;
//       case 'Months':
//         monthsValue = value;
//         break;
//     }
//   }
//
//   void _updateTimelineFromCurrentValue() {
//     final value = currentTimelineValue.round();
//     String unit;
//     switch (selectedTimelineCategory) {
//       case 'Days':
//         unit = value == 1 ? 'day' : 'days';
//         break;
//       case 'Weeks':
//         unit = value == 1 ? 'week' : 'weeks';
//         break;
//       case 'Months':
//         unit = value == 1 ? 'month' : 'months';
//         break;
//       default:
//         unit = 'days';
//     }
//     selectedTimeline = '$value $unit';
//   }
//
//   List<ServiceCategory> get filteredCategories {
//     if (_searchQuery.isEmpty) {
//       return _categories;
//     }
//
//     String queryLower = _searchQuery.toLowerCase();
//     return _categories.where((category) {
//       return category.name.toLowerCase().contains(queryLower) ||
//           category.displayName.toLowerCase().contains(queryLower) ||
//           category.description.toLowerCase().contains(queryLower);
//     }).toList();
//   }
//
//   String get selectedBudget {
//     return '${budgetRange.start.toCurrency()} - ${budgetRange.end.toCurrency()}';
//   }
//
//   void _expandSection(int section) {
//     setState(() {
//       isCategoryExpanded = section == 0;
//       isBudgetExpanded = section == 1;
//       isTimelineExpanded = section == 2;
//       isDetailsExpanded = section == 3;
//       _currentStep = section;
//     });
//   }
//
//   void _goToFullScreen() {
//     setState(() {
//       _isFullScreenMode = true;
//     });
//   }
//
//   void _exitFullScreen({bool collapseCategories = false}) {
//     setState(() {
//       _isFullScreenMode = false;
//       _searchQuery = '';
//     });
//     _stopAiSearch();
//     _expansionController.reverse().then((_) {
//       setState(() {
//         isCategoryExpanded = !collapseCategories;
//       });
//     });
//   }
//
//   Widget _buildRecentSearches() {
//     if (_isLoadingRecentSearches) {
//       return const SizedBox.shrink();
//     }
//
//     if (_recentSearches.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Recent searches',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: AppStyles.textPrimary,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ..._recentSearches.map((searchQuery) => _buildRecentSearchItem(searchQuery)),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
//
//   Widget _buildRecentSearchItem(String searchQuery) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       child: InkWell(
//         onTap: () => _executeRecentSearch(searchQuery),
//         borderRadius: BorderRadius.circular(8),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//           child: Row(
//             children: [
//               Icon(
//                 PhosphorIconsRegular.clockCounterClockwise,
//                 size: 16,
//                 color: AppStyles.textLight,
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   searchQuery,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: AppStyles.textSecondary,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               Icon(
//                 PhosphorIconsRegular.arrowUpRight,
//                 size: 14,
//                 color: AppStyles.textLight,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Navigation method to results page
//   void _navigateToResults() {
//     final searchCriteria = SearchCriteria(
//       selectedCategory: selectedCategory!,
//       selectedCategoryId: _categories.firstWhere((cat) => cat.displayName == selectedCategory).id,
//       selectedBudget: selectedBudget,
//       budgetRange: budgetRange,
//       selectedTimeline: selectedTimeline!,
//       timelineCategory: selectedTimelineCategory,
//       timelineValue: currentTimelineValue,
//       projectDescription: projectDescription,
//       searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
//     );
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProvidersListPage(searchCriteria: searchCriteria),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_dataError != null) {
//       return Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   size: 64,
//                   color: Colors.red.shade400,
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   'Error loading data',
//                   style: AppStyles.h4.copyWith(
//                     color: AppStyles.textSecondary,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   _dataError!,
//                   style: AppStyles.bodyMedium.copyWith(
//                     color: AppStyles.textLight,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 32),
//                 ElevatedButton(
//                   onPressed: _loadFirestoreData,
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//
//     return WillPopScope(
//       onWillPop: () async {
//         if (_isFullScreenMode) {
//           _exitFullScreen();
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Stack(
//           children: [
//             SafeArea(
//               child: Column(
//                 children: [
//                   _buildHeader(),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       physics: isTimelineExpanded
//                           ? const NeverScrollableScrollPhysics()
//                           : const BouncingScrollPhysics(),
//                       child: Column(
//                         children: [
//                           _buildCategorySection(),
//                           _buildBudgetSection(),
//                           _buildTimelineSection(),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//                   _buildBottomBar(),
//                 ],
//               ),
//             ),
//             if (_isFullScreenMode) _buildFullScreenOverlay(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(24.0, 24.0, 16.0, 16.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Find Providers',
//                 style: AppStyles.h1.copyWith(
//                     color: AppStyles.textPrimary,
//                     fontWeight: AppStyles.bold,
//                     letterSpacing: -1.5),
//               ),
//             ),
//             IconButton(
//               icon: Icon(
//                 PhosphorIcons.x(),
//                 color: AppStyles.textPrimary,
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCategorySection() {
//     return _buildCollapsibleSection(
//       title: 'What do you need?',
//       subtitle: selectedCategory ?? 'Select a category',
//       icon: PhosphorIconsRegular.briefcase,
//       isExpanded: isCategoryExpanded && !_isFullScreenMode,
//       isCompleted: selectedCategory != null,
//       onTap: () => _expandSection(0),
//       child: (isCategoryExpanded && !_isFullScreenMode) ? _buildCategoryList() : null,
//     );
//   }
//
//   Widget _buildCategoryList() {
//     return AnimatedBuilder(
//       animation: _expansionController,
//       builder: (context, child) {
//         final screenHeight = MediaQuery.of(context).size.height;
//         final expandedHeight = screenHeight * _scaleAnimation.value;
//
//         return Container(
//           constraints: BoxConstraints(maxHeight: expandedHeight),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.25),
//                 blurRadius: 12,
//                 offset: const Offset(0, 4),
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     Text(
//                       'What do you need?',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w600,
//                         color: AppStyles.textPrimary,
//                         letterSpacing: -0.4,
//                       ),
//                     ),
//                     const Spacer(),
//                     GestureDetector(
//                       onTap: () => setState(() {
//                         isCategoryExpanded = false;
//                         _expansionController.reset();
//                       }),
//                       child: Icon(
//                         PhosphorIconsRegular.caretUp,
//                         size: 20,
//                         color: AppStyles.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: _goToFullScreen,
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey.shade800, width: 0.8),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(PhosphorIconsRegular.magnifyingGlass,
//                           color: Colors.grey.shade500, size: 20),
//                       const SizedBox(width: 12),
//                       Text(
//                         'Search categories',
//                         style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: NotificationListener<ScrollNotification>(
//                   onNotification: (scrollNotification) {
//                     if (scrollNotification is ScrollUpdateNotification) {
//                       if (scrollNotification.scrollDelta != null &&
//                           scrollNotification.scrollDelta! > 20) {
//                         _goToFullScreen();
//                       }
//                     }
//                     return false;
//                   },
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildRecentSearches(),
//                           if (_categories.isEmpty)
//                             Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(40.0),
//                                 child: Column(
//                                   children: [
//                                     SizedBox(
//                                       width: 24,
//                                       height: 24,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     Text(
//                                       'Loading categories...',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: AppStyles.textSecondary,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           else
//                             ..._categories.take(6).map((category) => _buildCategoryItem(category)),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildFullScreenOverlay() {
//     return Positioned.fill(
//       child: Container(
//         color: Colors.white,
//         child: SafeArea(
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     Text(
//                       'What do you need?',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w600,
//                         color: AppStyles.textPrimary,
//                         letterSpacing: -0.4,
//                       ),
//                     ),
//                     const Spacer(),
//                     GestureDetector(
//                       onTap: _exitFullScreen,
//                       child: Icon(
//                         PhosphorIconsRegular.x,
//                         size: 24,
//                         color: AppStyles.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 child: TextField(
//                   autofocus: true,
//                   onChanged: (value) {
//                     setState(() => _searchQuery = value);
//                     _startAiSearch(value);
//                   },
//                   decoration: InputDecoration(
//                     hintText: 'Search categories',
//                     hintStyle: TextStyle(color: Colors.grey.shade500),
//                     prefixIcon: Icon(PhosphorIconsRegular.magnifyingGlass,
//                         color: Colors.grey.shade500, size: 20),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(color: Colors.grey.shade200),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: BorderSide(color: Colors.grey.shade400),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey.shade50,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                   ),
//                 ),
//               ),
//               if (_isAiSearchActive) _buildAiSearchWindow(),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (_searchQuery.isEmpty && !_isLoadingRecentSearches && _recentSearches.isNotEmpty) ...[
//                         _buildRecentSearches(),
//                         const SizedBox(height: 8),
//                       ],
//                       Text(
//                         'All categories',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: AppStyles.textPrimary,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: filteredCategories.length,
//                           itemBuilder: (context, index) {
//                             return _buildCategoryItem(filteredCategories[index]);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAiSearchWindow() {
//     return AnimatedBuilder(
//       animation: _aiSearchAnimationController,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, _aiSearchSlideAnimation.value),
//           child: Opacity(
//             opacity: _aiSearchFadeAnimation.value,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     AppStyles.goldPrimary.withOpacity(0.1),
//                     Colors.purple.withOpacity(0.05),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: AppStyles.goldPrimary.withOpacity(0.3),
//                   width: 1,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppStyles.goldPrimary.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: AppStyles.goldPrimary.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(
//                           PhosphorIconsRegular.robot,
//                           size: 20,
//                           color: AppStyles.goldPrimary,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         'AI Assistant',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppStyles.textPrimary,
//                         ),
//                       ),
//                       if (_isAiSearching) ...[
//                         const SizedBox(width: 12),
//                         SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   if (_isAiSearching) ...[
//                     Text(
//                       'Analyzing your request and finding the best matching categories...',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: AppStyles.textSecondary,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   ] else if (_aiRecommendedCategories.isNotEmpty) ...[
//                     Text(
//                       'Top AI Recommendations:',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: AppStyles.textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     ..._aiRecommendedCategories.map((category) => _buildAiRecommendationItem(category)),
//                   ] else ...[
//                     Text(
//                       'I couldn\'t find specific matches for "$_searchQuery". Try different keywords or browse all categories below.',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: AppStyles.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildAiRecommendationItem(ServiceCategory category) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.8),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: AppStyles.goldPrimary.withOpacity(0.2)),
//       ),
//       child: InkWell(
//         onTap: () {
//           if (_searchQuery.trim().isNotEmpty) {
//             _addToRecentSearches(_searchQuery.trim());
//           }
//
//           setState(() {
//             selectedCategory = category.displayName;
//             _exitFullScreen(collapseCategories: true);
//             Future.delayed(const Duration(milliseconds: 300), () {
//               _expandSection(1);
//             });
//           });
//         },
//         child: Row(
//           children: [
//             Icon(
//               _getCategoryIcon(category.icon),
//               size: 20,
//               color: AppStyles.goldPrimary,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     category.displayName,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: AppStyles.textPrimary,
//                     ),
//                   ),
//                   Text(
//                     '⭐ ${category.rating.toStringAsFixed(1)} • ${category.available} available',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: AppStyles.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               PhosphorIconsRegular.arrowRight,
//               size: 16,
//               color: AppStyles.textSecondary,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCategoryItem(ServiceCategory category) {
//     final isSelected = selectedCategory == category.displayName;
//
//     return GestureDetector(
//       onTap: () {
//         if (_searchQuery.trim().isNotEmpty) {
//           _addToRecentSearches(_searchQuery.trim());
//         }
//
//         setState(() {
//           selectedCategory = category.displayName;
//           if (_isFullScreenMode) {
//             _exitFullScreen(collapseCategories: true);
//             Future.delayed(const Duration(milliseconds: 300), () {
//               _expandSection(1);
//             });
//           } else {
//             _expandSection(1);
//           }
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.grey.shade100 : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? Colors.grey.shade500 : Colors.grey.shade200,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.grey.shade200 : Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 _getCategoryIcon(category.icon),
//                 size: 24,
//                 color: isSelected ? AppStyles.textPrimary : AppStyles.textSecondary,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     category.displayName,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: AppStyles.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     category.description,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: AppStyles.textSecondary,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               Icon(
//                 PhosphorIconsRegular.checkCircle,
//                 color: AppStyles.textPrimary,
//                 size: 24,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBudgetSection() {
//     return _buildCollapsibleSection(
//       title: 'What\'s your budget?',
//       subtitle: selectedBudget,
//       icon: PhosphorIconsRegular.currencyCircleDollar,
//       isExpanded: isBudgetExpanded,
//       isCompleted: true,
//       onTap: () => _expandSection(1),
//       child: isBudgetExpanded ? _buildBudgetRangeSlider() : null,
//     );
//   }
//
//   Widget _buildBudgetRangeSlider() {
//     return Container(
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height * 0.55,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.25),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Text(
//                   'What\'s your budget?',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w600,
//                     color: AppStyles.textPrimary,
//                     letterSpacing: -0.4,
//                   ),
//                 ),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: () => setState(() {
//                     isBudgetExpanded = false;
//                   }),
//                   child: Icon(
//                     PhosphorIconsRegular.caretUp,
//                     size: 20,
//                     color: AppStyles.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             'Pricing, includes all fees',
//             style: TextStyle(
//                 fontSize: 15,
//                 color: AppStyles.textSecondary,
//                 letterSpacing: -0.3),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 30),
//                     SmoothRangeSlider(
//                       min: minBudget,
//                       max: maxBudget,
//                       values: budgetRange,
//                       activeColor: AppStyles.goldPrimary,
//                       inactiveColor: Colors.grey.shade300,
//                       thumbColor: Colors.white,
//                       thumbBorderColor: Colors.grey.shade400,
//                       thumbRadius: 15,
//                       thumbBorderWidth: 1.5,
//                       trackHeight: 3,
//                       onChanged: (RangeValues values) {
//                         setState(() {
//                           budgetRange = values;
//                         });
//                       },
//                       onChangeStart: (values) {
//                         // Optional: Add haptic feedback
//                       },
//                       onChangeEnd: (values) {
//                         // Optional: Save to preferences or analytics
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             'Minimum',
//                             textAlign: TextAlign.left,
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: AppStyles.textSecondary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             'Maximum',
//                             textAlign: TextAlign.right,
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: AppStyles.textSecondary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _buildBudgetDisplayCard(budgetRange.start.toCurrency()),
//                         const SizedBox(width: 20),
//                         _buildBudgetDisplayCard(
//                             budgetRange.end >= maxBudget
//                                 ? '${budgetRange.end.toCurrency()}+'
//                                 : budgetRange.end.toCurrency()),
//                       ],
//                     ),
//                     const SizedBox(height: 30),
//                     Text(
//                       'Suggested ranges',
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           color: AppStyles.textPrimary,
//                           letterSpacing: -0.3),
//                     ),
//                     const SizedBox(height: 12),
//                     Container(
//                       height: 52,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         physics: const BouncingScrollPhysics(),
//                         padding: const EdgeInsets.symmetric(horizontal: 4),
//                         child: Row(
//                           children: commonBudgetRanges.asMap().entries.map((entry) {
//                             final index = entry.key;
//                             final range = entry.value;
//                             final isSelected = budgetRange.start == range['min'] &&
//                                 budgetRange.end == range['max'];
//
//                             return Container(
//                               margin: EdgeInsets.only(
//                                 right: index == commonBudgetRanges.length - 1 ? 0 : 12,
//                               ),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     budgetRange = RangeValues(range['min'], range['max']);
//                                   });
//                                 },
//                                 child: AnimatedContainer(
//                                   duration: const Duration(milliseconds: 250),
//                                   curve: Curves.easeInOutCubic,
//                                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                   decoration: BoxDecoration(
//                                     color: isSelected ? AppStyles.blackMedium : Colors.white,
//                                     borderRadius: BorderRadius.circular(32),
//                                     border: Border.all(
//                                       color: isSelected ? AppStyles.blackMedium : Colors.grey.shade300,
//                                       width: isSelected ? 2 : 1.5,
//                                     ),
//                                     boxShadow: isSelected
//                                         ? [
//                                       BoxShadow(
//                                         color: AppStyles.textPrimary.withOpacity(0.25),
//                                         blurRadius: 8,
//                                         offset: const Offset(0, 3),
//                                       ),
//                                     ]
//                                         : [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.1),
//                                         blurRadius: 4,
//                                         offset: const Offset(0, 2),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Text(
//                                     range['label'],
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                       color: isSelected ? Colors.white : AppStyles.blackMedium,
//                                       letterSpacing: -0.1,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       budgetRange = const RangeValues(minBudget, maxBudget);
//                     });
//                   },
//                   child: Text(
//                     'Clear',
//                     style: TextStyle(
//                       color: AppStyles.textSecondary,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     _expandSection(2);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppStyles.black,
//                     disabledBackgroundColor: Colors.grey.shade300,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Next',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: AppStyles.textWhite,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBudgetDisplayCard(String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppStyles.borderMedium, width: 0.8),
//       ),
//       child: Text(
//         value,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w600,
//           color: AppStyles.textPrimary,
//           letterSpacing: -0.2,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimelineSection() {
//     String subtitle = selectedTimeline ?? 'Select timeline';
//
//     return _buildCollapsibleSection(
//       title: 'What\'s your timeline?',
//       subtitle: subtitle,
//       icon: PhosphorIconsRegular.calendar,
//       isExpanded: isTimelineExpanded,
//       isCompleted: selectedTimeline != null,
//       onTap: () => _expandSection(2),
//       child: isTimelineExpanded ? _buildTimelineSelector() : null,
//     );
//   }
//
//   Widget _buildTimelineSelector() {
//     return Container(
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height * 0.45,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.25),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Text(
//                   'What\'s your timeline?',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w600,
//                     color: AppStyles.textPrimary,
//                     letterSpacing: -0.4,
//                   ),
//                 ),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: () => setState(() {
//                     isTimelineExpanded = false;
//                   }),
//                   child: Icon(
//                     PhosphorIconsRegular.caretUp,
//                     size: 20,
//                     color: AppStyles.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             child: _buildTimelineToggle(),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: Container(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   CircularTimelineSelector(
//                     key: ValueKey(selectedTimelineCategory),
//                     category: selectedTimelineCategory,
//                     initialValue: currentTimelineValue,
//                     activeColor: AppStyles.goldPrimary,
//                     inactiveColor: Colors.grey.shade300,
//                     thumbColor: Colors.white,
//                     size: 180.0,
//                     onChanged: (value) {
//                       setCurrentTimelineValue(value);
//                       _updateTimelineFromCurrentValue();
//                       setState(() {});
//                     },
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTimelineToggle() {
//     final categories = ['Days', 'Weeks', 'Months'];
//     final selectedIndex = categories.indexOf(selectedTimelineCategory);
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final itemWidth = constraints.maxWidth / 3;
//
//         return AnimatedBuilder(
//           animation: _toggleAnimation,
//           builder: (context, child) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: Stack(
//                 children: [
//                   AnimatedPositioned(
//                     duration: const Duration(milliseconds: 300),
//                     curve: Curves.easeInOut,
//                     left: itemWidth * selectedIndex + 4,
//                     top: 4,
//                     bottom: 4,
//                     width: itemWidth - 8,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.2),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: categories.asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final category = entry.value;
//                       final isSelected = selectedTimelineCategory == category;
//
//                       return Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedTimelineCategory = category;
//                               _updateTimelineFromCurrentValue();
//                             });
//
//                             _toggleAnimationController.reset();
//                             _toggleAnimationController.forward();
//                           },
//                           child: Container(
//                             margin: const EdgeInsets.all(4),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: AnimatedDefaultTextStyle(
//                               duration: const Duration(milliseconds: 200),
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                                 color: isSelected ? AppStyles.textPrimary : AppStyles.textSecondary,
//                               ),
//                               child: Text(
//                                 category,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildCollapsibleSection({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required bool isExpanded,
//     required bool isCompleted,
//     required VoidCallback onTap,
//     Widget? child,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.6),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//             spreadRadius: 0,
//           ),
//         ],
//       ),
//       child: AnimatedSize(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOutCubic,
//         child: isExpanded && child != null
//             ? child
//             : InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: isCompleted ? Colors.grey.shade200 : Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     icon,
//                     size: 20,
//                     color: isCompleted ? AppStyles.textPrimary : AppStyles.textSecondary,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: AppStyles.textSecondary,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
//                           color: isCompleted ? AppStyles.textPrimary : AppStyles.textLight,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   PhosphorIconsRegular.caretDown,
//                   size: 20,
//                   color: AppStyles.textSecondary,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomBar() {
//     final isReady = selectedCategory != null && selectedTimeline != null;
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 selectedCategory = null;
//                 selectedTimeline = null;
//                 projectDescription = null;
//                 budgetRange = const RangeValues(200, 5000);
//                 selectedTimelineCategory = 'Days';
//                 daysValue = 7.0;
//                 weeksValue = 2.0;
//                 monthsValue = 3.0;
//                 _expandSection(0);
//               });
//             },
//             child: Text(
//               'Clear all',
//               style: TextStyle(
//                 color: AppStyles.textSecondary,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           ElevatedButton(
//             onPressed: isReady ? _navigateToResults : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppStyles.goldPrimary,
//               disabledBackgroundColor: Colors.grey.shade300,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 0,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 40.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     PhosphorIconsRegular.magnifyingGlass,
//                     size: 20,
//                     color: AppStyles.textWhite,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Search',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: AppStyles.textWhite,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }