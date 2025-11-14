// import 'package:flutter/material.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import '../../utils/app_styles.dart';
// import '../../utils/circular_timeline_selector.dart';
// import '../../utils/custom_smooth_slider.dart';
// import 'post_task_request.dart';
//
// class ManualMode extends StatefulWidget {
//   final GlobalKey<FormState> formKey;
//   final TextEditingController titleController;
//   final TextEditingController descriptionController;
//   final List<ServiceCategory> categories;
//   final bool isLoadingCategories;
//   final String? selectedCategory;
//   final String? selectedCategoryId;
//   final RangeValues budgetRange;
//   final String selectedTimelineCategory;
//   final double currentTimelineValue;
//   final List<String> selectedSkills;
//   final List<String> keyDeliverables;
//   final bool isSubmitting;
//   final Function(String?, String?) onCategoryChanged;
//   final Function(RangeValues) onBudgetChanged;
//   final Function(String) onTimelineCategoryChanged;
//   final Function(double) onTimelineValueChanged;
//   final Function(List<String>) onSkillsChanged;
//   final Function(List<String>) onDeliverablesChanged;
//   final VoidCallback onSubmit;
//
//   const ManualMode({
//     super.key,
//     required this.formKey,
//     required this.titleController,
//     required this.descriptionController,
//     required this.categories,
//     required this.isLoadingCategories,
//     required this.selectedCategory,
//     required this.selectedCategoryId,
//     required this.budgetRange,
//     required this.selectedTimelineCategory,
//     required this.currentTimelineValue,
//     required this.selectedSkills,
//     required this.keyDeliverables,
//     required this.isSubmitting,
//     required this.onCategoryChanged,
//     required this.onBudgetChanged,
//     required this.onTimelineCategoryChanged,
//     required this.onTimelineValueChanged,
//     required this.onSkillsChanged,
//     required this.onDeliverablesChanged,
//     required this.onSubmit,
//   });
//
//   @override
//   State<ManualMode> createState() => _ManualModeState();
// }
//
// class _ManualModeState extends State<ManualMode> with SingleTickerProviderStateMixin {
//   final List<String> _availableSkills = [
//     'Photography',
//     'Photo Editing',
//     'Portrait',
//     'Event',
//     'Product',
//     'Graphic Design',
//     'Logo Design',
//     'Branding',
//     'UI/UX',
//     'Video Editing',
//     'Motion Graphics',
//     'Writing',
//     'Copywriting',
//     'Content Writing',
//     'Web Development',
//     'React',
//     'Flutter',
//     'Node.js',
//   ];
//
//   late AnimationController _toggleAnimationController;
//   late Animation<double> _toggleAnimation;
//   String? _categoryValidationError;
//   final TextEditingController _deliverableController = TextEditingController();
//   final FocusNode _deliverableFocusNode = FocusNode();
//   bool _hasDeliverableText = false;
//   bool _isFormValid = false;
//
//   @override
//   void initState() {
//     super.initState();
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
//     // Listen to text changes
//     _deliverableController.addListener(() {
//       final hasText = _deliverableController.text.trim().isNotEmpty;
//       if (hasText != _hasDeliverableText) {
//         setState(() {
//           _hasDeliverableText = hasText;
//         });
//       }
//     });
//
//     // Listen to form field changes
//     widget.titleController.addListener(_validateForm);
//     widget.descriptionController.addListener(_validateForm);
//   }
//
//   @override
//   void didUpdateWidget(ManualMode oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Check if category selection changed
//     if (oldWidget.selectedCategory != widget.selectedCategory) {
//       _validateForm();
//     }
//   }
//
//   void _validateForm() {
//     final isValid = widget.titleController.text.trim().isNotEmpty &&
//         widget.descriptionController.text.trim().length >= 50 &&
//         widget.selectedCategory != null;
//
//     if (isValid != _isFormValid) {
//       setState(() {
//         _isFormValid = isValid;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _toggleAnimationController.dispose();
//     _deliverableController.dispose();
//     _deliverableFocusNode.dispose();
//     widget.titleController.removeListener(_validateForm);
//     widget.descriptionController.removeListener(_validateForm);
//     super.dispose();
//   }
//
//   void _addDeliverable() {
//     final text = _deliverableController.text.trim();
//     if (text.isNotEmpty) {
//       final newDeliverables = List<String>.from(widget.keyDeliverables);
//       newDeliverables.add(text);
//       widget.onDeliverablesChanged(newDeliverables);
//       _deliverableController.clear();
//       _deliverableFocusNode.requestFocus();
//     }
//   }
//
//   void _removeDeliverable(int index) {
//     final newDeliverables = List<String>.from(widget.keyDeliverables);
//     newDeliverables.removeAt(index);
//     widget.onDeliverablesChanged(newDeliverables);
//   }
//
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
//   void _showCategoryBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 8),
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Select Category',
//                       style: AppStyles.h4.copyWith(
//                         fontWeight: AppStyles.semiBold,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: Icon(
//                         PhosphorIconsRegular.x,
//                         color: AppStyles.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Flexible(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   itemCount: widget.categories.length,
//                   itemBuilder: (context, index) {
//                     final category = widget.categories[index];
//                     final isSelected = widget.selectedCategory == category.displayName;
//
//                     return InkWell(
//                       onTap: () {
//                         widget.onCategoryChanged(category.displayName, category.id);
//                         setState(() {
//                           _categoryValidationError = null;
//                         });
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 8),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? AppStyles.goldPrimary.withOpacity(0.1)
//                               : AppStyles.backgroundGrey,
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: isSelected
//                                 ? AppStyles.goldPrimary
//                                 : Colors.transparent,
//                             width: 2,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: isSelected
//                                     ? AppStyles.goldPrimary
//                                     : Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Icon(
//                                 _getCategoryIcon(category.icon),
//                                 size: 24,
//                                 color: isSelected
//                                     ? Colors.white
//                                     : AppStyles.textSecondary,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Text(
//                                 category.displayName,
//                                 style: AppStyles.bodyLarge.copyWith(
//                                   fontWeight: isSelected
//                                       ? AppStyles.semiBold
//                                       : AppStyles.medium,
//                                   color: isSelected
//                                       ? AppStyles.textPrimary
//                                       : AppStyles.textSecondary,
//                                 ),
//                               ),
//                             ),
//                             if (isSelected)
//                               Icon(
//                                 PhosphorIconsRegular.check,
//                                 color: AppStyles.goldPrimary,
//                                 size: 24,
//                               ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: widget.formKey,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               child: Text(
//                 'Creators will review your request\nand send proposals',
//                 style: AppStyles.bodyMedium.copyWith(
//                   color: AppStyles.textSecondary,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 32),
//
//             _buildSectionTitle('Task Title'),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: widget.titleController,
//               decoration: _buildInputDecoration(
//                 hint: 'e.g., Professional headshots for my team',
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Please enter a task title';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 32),
//
//             _buildSectionTitle('Category'),
//             const SizedBox(height: 12),
//             if (widget.isLoadingCategories)
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: AppStyles.backgroundGrey,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Text(
//                       'Loading categories...',
//                       style: AppStyles.bodyMedium.copyWith(
//                         color: AppStyles.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   InkWell(
//                     onTap: _showCategoryBottomSheet,
//                     borderRadius: BorderRadius.circular(16),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: AppStyles.backgroundGrey,
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: _categoryValidationError != null
//                               ? Colors.red.shade300
//                               : Colors.transparent,
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           if (widget.selectedCategory != null) ...[
//                             Icon(
//                               _getCategoryIcon(
//                                 widget.categories
//                                     .firstWhere((cat) => cat.displayName == widget.selectedCategory)
//                                     .icon,
//                               ),
//                               size: 20,
//                               color: AppStyles.textSecondary,
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 widget.selectedCategory!,
//                                 style: AppStyles.bodyMedium.copyWith(
//                                   color: AppStyles.textPrimary,
//                                 ),
//                               ),
//                             ),
//                           ] else
//                             Expanded(
//                               child: Text(
//                                 'Select category',
//                                 style: AppStyles.bodyMedium.copyWith(
//                                   color: AppStyles.textLight,
//                                 ),
//                               ),
//                             ),
//                           Icon(
//                             PhosphorIconsRegular.caretDown,
//                             size: 20,
//                             color: AppStyles.textSecondary,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (_categoryValidationError != null)
//                     Padding(
//                       padding: const EdgeInsets.only(left: 16, top: 8),
//                       child: Text(
//                         _categoryValidationError!,
//                         style: AppStyles.bodySmall.copyWith(
//                           color: Colors.red.shade400,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             const SizedBox(height: 32),
//
//             _buildSectionTitle('Description'),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: widget.descriptionController,
//               maxLines: 6,
//               decoration: _buildInputDecoration(
//                 hint: 'Describe your task in detail...',
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Please enter a description';
//                 }
//                 if (value.trim().length < 50) {
//                   return 'Description should be at least 50 characters';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 32),
//
//             _buildSectionTitle('Key Deliverables'),
//             const SizedBox(height: 8),
//             Text(
//               'List the main deliverables for this task',
//               style: AppStyles.bodyMedium.copyWith(
//                 color: AppStyles.textLight,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _deliverableController,
//                     focusNode: _deliverableFocusNode,
//                     decoration: _buildInputDecoration(
//                       hint: 'e.g., 10 edited photos in high resolution',
//                     ),
//                     onSubmitted: (_) => _addDeliverable(),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Container(
//                   height: 48,
//                   width: 48,
//                   decoration: BoxDecoration(
//                     color: _hasDeliverableText
//                         ? AppStyles.textPrimary
//                         : Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: IconButton(
//                     onPressed: _hasDeliverableText ? _addDeliverable : null,
//                     icon: Icon(
//                       PhosphorIconsRegular.plus,
//                       color: _hasDeliverableText ? Colors.white : Colors.grey.shade500,
//                       size: 24,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (widget.keyDeliverables.isNotEmpty) ...[
//               const SizedBox(height: 16),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: widget.keyDeliverables.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: AppStyles.backgroundGrey,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 24,
//                           height: 24,
//                           decoration: BoxDecoration(
//                             color: AppStyles.goldPrimary.withOpacity(0.2),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Text(
//                               '${index + 1}',
//                               style: AppStyles.bodySmall.copyWith(
//                                 color: AppStyles.goldPrimary,
//                                 fontWeight: AppStyles.semiBold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             widget.keyDeliverables[index],
//                             style: AppStyles.bodyMedium.copyWith(
//                               color: AppStyles.textPrimary,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         InkWell(
//                           onTap: () => _removeDeliverable(index),
//                           borderRadius: BorderRadius.circular(8),
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             child: Icon(
//                               PhosphorIconsRegular.x,
//                               color: AppStyles.textSecondary,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ],
//             const SizedBox(height: 32),
//
//             _buildSectionTitle('Budget Range'),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: AppStyles.backgroundGrey,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 children: [
//                   SmoothRangeSlider(
//                     min: 100,
//                     max: 20000,
//                     values: widget.budgetRange,
//                     activeColor: AppStyles.goldPrimary,
//                     inactiveColor: Colors.grey.shade300,
//                     thumbColor: Colors.white,
//                     thumbBorderColor: Colors.grey.shade400,
//                     onChanged: widget.onBudgetChanged,
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Minimum',
//                             style: AppStyles.bodySmall.copyWith(
//                               color: AppStyles.textLight,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'GHS${widget.budgetRange.start.round()}',
//                             style: AppStyles.h5.copyWith(
//                               fontWeight: AppStyles.semiBold,
//                               color: AppStyles.textPrimary,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             'Maximum',
//                             style: AppStyles.bodySmall.copyWith(
//                               color: AppStyles.textLight,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'GHS${widget.budgetRange.end.round()}',
//                             style: AppStyles.h5.copyWith(
//                               fontWeight: AppStyles.semiBold,
//                               color: AppStyles.textPrimary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//
//             _buildSectionTitle('Timeline'),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: AppStyles.backgroundGrey,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 children: [
//                   _buildTimelineToggle(),
//                   const SizedBox(height: 32),
//                   CircularTimelineSelector(
//                     key: ValueKey(widget.selectedTimelineCategory),
//                     category: widget.selectedTimelineCategory,
//                     initialValue: widget.currentTimelineValue,
//                     activeColor: AppStyles.goldPrimary,
//                     inactiveColor: Colors.grey.shade300,
//                     thumbColor: Colors.white,
//                     size: 180.0,
//                     onChanged: widget.onTimelineValueChanged,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//
//             _buildSectionTitle('Required Skills'),
//             const SizedBox(height: 8),
//             Text(
//               'Select skills relevant to your task',
//               style: AppStyles.bodyMedium.copyWith(
//                 color: AppStyles.textLight,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: _availableSkills.map((skill) {
//                 final isSelected = widget.selectedSkills.contains(skill);
//                 return GestureDetector(
//                   onTap: () {
//                     final newSkills = List<String>.from(widget.selectedSkills);
//                     if (isSelected) {
//                       newSkills.remove(skill);
//                     } else {
//                       newSkills.add(skill);
//                     }
//                     widget.onSkillsChanged(newSkills);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: isSelected ? AppStyles.textPrimary : AppStyles.backgroundGrey,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       skill,
//                       style: AppStyles.bodyMedium.copyWith(
//                         color: isSelected ? Colors.white : AppStyles.textPrimary,
//                         fontWeight: isSelected ? AppStyles.semiBold : AppStyles.medium,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 40),
//
//             SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: ElevatedButton(
//                 onPressed: (widget.isSubmitting || !_isFormValid) ? null : () {
//                   // Validate category selection
//                   if (widget.selectedCategory == null) {
//                     setState(() {
//                       _categoryValidationError = 'Please select a category';
//                     });
//                   } else {
//                     setState(() {
//                       _categoryValidationError = null;
//                     });
//                   }
//                   widget.onSubmit();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _isFormValid ? AppStyles.textPrimary : Colors.grey.shade300,
//                   disabledBackgroundColor: Colors.grey.shade300,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: widget.isSubmitting
//                     ? const SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 )
//                     : Text(
//                   'Post Task Request',
//                   style: AppStyles.bodyLarge.copyWith(
//                     color: _isFormValid ? Colors.white : Colors.grey.shade500,
//                     fontWeight: AppStyles.semiBold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: AppStyles.bodyLarge.copyWith(
//         fontWeight: AppStyles.medium,
//         fontSize: 18,
//         color: AppStyles.textPrimary,
//       ),
//     );
//   }
//
//   InputDecoration _buildInputDecoration({
//     required String hint,
//     IconData? icon,
//     bool hasBorder = true,
//     bool filled = true,
//   }) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: AppStyles.bodyMedium.copyWith(
//         color: AppStyles.textLight,
//       ),
//       prefixIcon: icon != null
//           ? Icon(icon, color: AppStyles.textSecondary, size: 20)
//           : null,
//       border: hasBorder
//           ? OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide.none,
//       )
//           : InputBorder.none,
//       enabledBorder: hasBorder
//           ? OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide.none,
//       )
//           : InputBorder.none,
//       focusedBorder: hasBorder
//           ? OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide(color: AppStyles.textPrimary, width: 2),
//       )
//           : InputBorder.none,
//       errorBorder: hasBorder
//           ? OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide(color: Colors.red.shade300, width: 1),
//       )
//           : InputBorder.none,
//       focusedErrorBorder: hasBorder
//           ? OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide(color: Colors.red.shade400, width: 2),
//       )
//           : InputBorder.none,
//       contentPadding: const EdgeInsets.all(16),
//       filled: filled,
//       fillColor: AppStyles.backgroundGrey,
//     );
//   }
//
//   Widget _buildTimelineToggle() {
//     final categories = ['Days', 'Weeks', 'Months'];
//     final selectedIndex = categories.indexOf(widget.selectedTimelineCategory);
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
//                 color: Colors.white,
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
//                         color: AppStyles.textPrimary,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: categories.asMap().entries.map((entry) {
//                       final category = entry.value;
//                       final isSelected = widget.selectedTimelineCategory == category;
//
//                       return Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             widget.onTimelineCategoryChanged(category);
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
//                                 fontWeight: AppStyles.semiBold,
//                                 color: isSelected ? Colors.white : AppStyles.textSecondary,
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
// }