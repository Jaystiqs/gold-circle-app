import 'package:flutter/material.dart';
import '../../../utils/app_styles.dart';

class DescriptionStep extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Describe your task in detail',
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
            'Include key requirements, goals, and any specific details',
            style: AppStyles.bodyMedium.copyWith(
              color: AppStyles.textSecondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: controller,
            maxLines: 8,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText:
              'Describe what you need, any specific requirements, deliverables...',
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
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}