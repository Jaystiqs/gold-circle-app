import 'package:flutter/material.dart';
import '../../../utils/app_styles.dart';

class TitleStep extends StatefulWidget {
  final TextEditingController controller;

  const TitleStep({super.key, required this.controller});

  @override
  State<TitleStep> createState() => _TitleStepState();
}

class _TitleStepState extends State<TitleStep> {
  bool _showRefineButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _showRefineButton = widget.controller.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _showRefineButton) {
      setState(() {
        _showRefineButton = hasText;
      });
    }
  }

  void _refineWithAI() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RefineBottomSheet(
        originalText: widget.controller.text,
        onApply: (refinedText) {
          widget.controller.text = refinedText;
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Give your task a title',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppStyles.textPrimary,
              height: 1.0,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A clear, descriptive title helps attract the right creators',
            style: AppStyles.bodyMedium.copyWith(
              color: AppStyles.textSecondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: widget.controller,
            maxLength: 100,
            decoration: InputDecoration(
              hintText: 'e.g., Build a mobile app for food delivery',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppStyles.textPrimary, width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: TextStyle(
              fontSize: 16,
              color: AppStyles.textPrimary,
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _showRefineButton
                ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: OutlinedButton.icon(
                onPressed: _refineWithAI,
                icon: Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: AppStyles.textPrimary,
                ),
                label: Text(
                  'Refine with AI',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppStyles.textPrimary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  side: BorderSide(color: AppStyles.textPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _RefineBottomSheet extends StatefulWidget {
  final String originalText;
  final Function(String) onApply;

  const _RefineBottomSheet({
    required this.originalText,
    required this.onApply,
  });

  @override
  State<_RefineBottomSheet> createState() => _RefineBottomSheetState();
}

class _RefineBottomSheetState extends State<_RefineBottomSheet> {
  bool _isLoading = true;
  String _refinedText = '';

  @override
  void initState() {
    super.initState();
    _generateRefinedText();
  }

  Future<void> _generateRefinedText() async {
    // TODO: Implement actual AI API call here
    // Simulating API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _refinedText = _mockRefineText(widget.originalText);
      _isLoading = false;
    });
  }

  String _mockRefineText(String text) {
    // Mock refinement - replace with actual AI call
    return 'Professional ${text.trim()} Service';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: AppStyles.textPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'AI Refinement',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _isLoading
                      ? Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppStyles.textPrimary),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: AppStyles.textPrimary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Refining your title...',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppStyles.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppStyles.textPrimary),
                    ),
                    child: Text(
                      _refinedText,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppStyles.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  if (!_isLoading)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppStyles.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => widget.onApply(_refinedText),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppStyles.textPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}