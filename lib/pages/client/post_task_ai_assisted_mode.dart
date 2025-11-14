// import 'package:flutter/material.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import '../../utils/app_styles.dart';
// import 'post_task_request.dart';
//
// class AiAssistedMode extends StatefulWidget {
//   final TextEditingController titleController;
//   final TextEditingController descriptionController;
//   final List<ServiceCategory> categories;
//   final String? selectedCategory;
//   final RangeValues budgetRange;
//   final String selectedTimelineCategory;
//   final String Function() getTimelineString;
//   final Function(String?, String?) onCategorySelected;
//   final Function(RangeValues) onBudgetChanged;
//   final Function(String, double) onTimelineChanged;
//   final VoidCallback onSubmit;
//
//   const AiAssistedMode({
//     super.key,
//     required this.titleController,
//     required this.descriptionController,
//     required this.categories,
//     required this.selectedCategory,
//     required this.budgetRange,
//     required this.selectedTimelineCategory,
//     required this.getTimelineString,
//     required this.onCategorySelected,
//     required this.onBudgetChanged,
//     required this.onTimelineChanged,
//     required this.onSubmit,
//   });
//
//   @override
//   State<AiAssistedMode> createState() => _AiAssistedModeState();
// }
//
// class _AiAssistedModeState extends State<AiAssistedMode> {
//   final _aiInputController = TextEditingController();
//   final ScrollController _aiScrollController = ScrollController();
//
//   bool _isAiProcessing = false;
//   List<Map<String, dynamic>> _aiMessages = [];
//   int _currentAiStep = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _aiMessages.add({
//       'type': 'assistant',
//       'content': 'Hi! I\'ll help you create your task request. Let\'s start with the basics - what task do you need help with?',
//       'timestamp': DateTime.now(),
//     });
//   }
//
//   @override
//   void dispose() {
//     _aiInputController.dispose();
//     _aiScrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _handleAiMessage() async {
//     if (_aiInputController.text.trim().isEmpty) return;
//
//     final userMessage = _aiInputController.text.trim();
//     _aiInputController.clear();
//
//     setState(() {
//       _aiMessages.add({
//         'type': 'user',
//         'content': userMessage,
//         'timestamp': DateTime.now(),
//       });
//       _isAiProcessing = true;
//     });
//
//     _scrollToBottom();
//
//     await Future.delayed(const Duration(seconds: 1));
//
//     String aiResponse = '';
//
//     if (_currentAiStep == 0) {
//       widget.titleController.text = userMessage;
//       aiResponse = 'Great! I\'ve set "${userMessage}" as your task title.\n\nCould you describe what you need in more detail? For example, what\'s the scope, any specific requirements, or deliverables you expect?';
//       _currentAiStep = 1;
//     } else if (_currentAiStep == 1) {
//       widget.descriptionController.text = userMessage;
//       String categoryList = widget.categories.map((cat) => '• ${cat.displayName}').join('\n');
//       aiResponse = 'Perfect! I\'ve added that to your description.\n\nWhat category best fits this task?\n\n$categoryList';
//       _currentAiStep = 2;
//     } else if (_currentAiStep == 2) {
//       final categoryMatch = widget.categories.firstWhere(
//             (cat) => userMessage.toLowerCase().contains(cat.displayName.toLowerCase()) ||
//             userMessage.toLowerCase().contains(cat.name.toLowerCase()),
//         orElse: () => widget.categories.isNotEmpty ? widget.categories[0] : ServiceCategory(
//           id: '',
//           name: '',
//           displayName: 'General',
//           icon: '',
//           description: '',
//           isActive: true,
//           sortOrder: 0,
//         ),
//       );
//       widget.onCategorySelected(categoryMatch.displayName, categoryMatch.id);
//       aiResponse = 'Got it! I\'ve set the category to ${categoryMatch.displayName}.\n\nWhat\'s your budget range for this task? (e.g., "GHS500 to GHS2000")';
//       _currentAiStep = 3;
//     } else if (_currentAiStep == 3) {
//       final budgetNumbers = RegExp(r'\d+').allMatches(userMessage);
//       if (budgetNumbers.length >= 2) {
//         final nums = budgetNumbers.map((m) => int.parse(m.group(0)!)).toList();
//         widget.onBudgetChanged(RangeValues(nums[0].toDouble(), nums[1].toDouble()));
//       }
//       aiResponse = 'Budget set! When do you need this completed?\n\nYou can say something like "in 5 days" or "within 2 weeks"';
//       _currentAiStep = 4;
//     } else if (_currentAiStep == 4) {
//       if (userMessage.toLowerCase().contains('day')) {
//         final match = RegExp(r'\d+').firstMatch(userMessage);
//         if (match != null) {
//           widget.onTimelineChanged('Days', double.parse(match.group(0)!));
//         }
//       } else if (userMessage.toLowerCase().contains('week')) {
//         final match = RegExp(r'\d+').firstMatch(userMessage);
//         if (match != null) {
//           widget.onTimelineChanged('Weeks', double.parse(match.group(0)!));
//         }
//       } else if (userMessage.toLowerCase().contains('month')) {
//         final match = RegExp(r'\d+').firstMatch(userMessage);
//         if (match != null) {
//           widget.onTimelineChanged('Months', double.parse(match.group(0)!));
//         }
//       }
//       aiResponse = '✨ Excellent! I\'ve gathered all the key information:\n\n• Task: ${widget.titleController.text}\n• Category: ${widget.selectedCategory}\n• Budget: GHS${widget.budgetRange.start.round()} - GHS${widget.budgetRange.end.round()}\n• Timeline: ${widget.getTimelineString()}\n\nYou can now review and post your task, or switch to manual mode to add more details like specific skills or location preferences.';
//       _currentAiStep = 5;
//     } else {
//       aiResponse = 'Your task request is ready! You can review it below and click "Post Task Request" when you\'re satisfied, or ask me to change anything.';
//     }
//
//     setState(() {
//       _aiMessages.add({
//         'type': 'assistant',
//         'content': aiResponse,
//         'timestamp': DateTime.now(),
//       });
//       _isAiProcessing = false;
//     });
//
//     _scrollToBottom();
//   }
//
//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_aiScrollController.hasClients) {
//         _aiScrollController.animateTo(
//           _aiScrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             controller: _aiScrollController,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             itemCount: _aiMessages.length + (_isAiProcessing ? 1 : 0),
//             itemBuilder: (context, index) {
//               if (index == _aiMessages.length) {
//                 return _buildTypingIndicator();
//               }
//
//               final message = _aiMessages[index];
//               final isUser = message['type'] == 'user';
//
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//                   children: [
//                     if (!isUser) ...[
//                       Container(
//                         width: 32,
//                         height: 32,
//                         decoration: BoxDecoration(
//                           color: AppStyles.goldPrimary.withOpacity(0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           PhosphorIcons.sparkle(),
//                           size: 16,
//                           color: AppStyles.goldPrimary,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                     ],
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: isUser ? AppStyles.goldPrimary : Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           border: isUser ? null : Border.all(
//                             color: Colors.grey.withOpacity(0.2),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 10,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           message['content'],
//                           style: AppStyles.bodyMedium.copyWith(
//                             color: isUser ? Colors.white : AppStyles.textPrimary,
//                             height: 1.5,
//                           ),
//                         ),
//                       ),
//                     ),
//                     if (isUser) const SizedBox(width: 12),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//         if (widget.titleController.text.isNotEmpty || widget.selectedCategory != null)
//           _buildQuickPreview(),
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border(
//               top: BorderSide(
//                 color: Colors.grey.withOpacity(0.2),
//               ),
//             ),
//           ),
//           child: SafeArea(
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: AppStyles.backgroundGrey,
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     child: TextField(
//                       controller: _aiInputController,
//                       decoration: InputDecoration(
//                         hintText: 'Type your response...',
//                         hintStyle: AppStyles.bodyMedium.copyWith(
//                           color: AppStyles.textLight,
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 12,
//                         ),
//                       ),
//                       maxLines: null,
//                       textCapitalization: TextCapitalization.sentences,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 GestureDetector(
//                   onTap: _isAiProcessing ? null : _handleAiMessage,
//                   child: Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: _aiInputController.text.isEmpty || _isAiProcessing
//                           ? AppStyles.textLight
//                           : AppStyles.goldPrimary,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       PhosphorIcons.paperPlaneRight(),
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTypingIndicator() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 32,
//           height: 32,
//           decoration: BoxDecoration(
//             color: AppStyles.goldPrimary.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             PhosphorIcons.sparkle(),
//             size: 16,
//             color: AppStyles.goldPrimary,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: Colors.grey.withOpacity(0.2),
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildDot(0),
//               const SizedBox(width: 4),
//               _buildDot(1),
//               const SizedBox(width: 4),
//               _buildDot(2),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDot(int index) {
//     return TweenAnimationBuilder(
//       tween: Tween<double>(begin: 0.0, end: 1.0),
//       duration: const Duration(milliseconds: 600),
//       builder: (context, double value, child) {
//         return Opacity(
//           opacity: (value + index * 0.3) % 1.0,
//           child: Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: AppStyles.textSecondary,
//               shape: BoxShape.circle,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildQuickPreview() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppStyles.goldPrimary.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: AppStyles.goldPrimary.withOpacity(0.2),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 PhosphorIcons.eye(),
//                 size: 16,
//                 color: AppStyles.goldPrimary,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Preview',
//                 style: AppStyles.bodySmall.copyWith(
//                   color: AppStyles.goldPrimary,
//                   fontWeight: AppStyles.semiBold,
//                 ),
//               ),
//               const Spacer(),
//               if (_currentAiStep >= 5)
//                 GestureDetector(
//                   onTap: widget.onSubmit,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: AppStyles.goldPrimary,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           'Post Task',
//                           style: AppStyles.bodySmall.copyWith(
//                             color: Colors.white,
//                             fontWeight: AppStyles.semiBold,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Icon(
//                           PhosphorIcons.arrowRight(),
//                           size: 14,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           if (widget.titleController.text.isNotEmpty) ...[
//             Text(
//               widget.titleController.text,
//               style: AppStyles.bodyLarge.copyWith(
//                 fontWeight: AppStyles.semiBold,
//               ),
//             ),
//             const SizedBox(height: 8),
//           ],
//           if (widget.selectedCategory != null) ...[
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     widget.selectedCategory!,
//                     style: AppStyles.bodySmall.copyWith(
//                       color: AppStyles.textPrimary,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'GHS${widget.budgetRange.start.round()} - GHS${widget.budgetRange.end.round()}',
//                   style: AppStyles.bodySmall.copyWith(
//                     color: AppStyles.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }