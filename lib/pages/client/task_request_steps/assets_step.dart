import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../utils/app_styles.dart';

class AssetsStep extends StatelessWidget {
  final TextEditingController googleDriveController;
  final TextEditingController dropboxController;
  final TextEditingController otherController;

  const AssetsStep({
    super.key,
    required this.googleDriveController,
    required this.dropboxController,
    required this.otherController,
  });

  void _showUrlBottomSheet(
      BuildContext context, String title, TextEditingController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppStyles.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      PhosphorIconsRegular.x,
                      color: AppStyles.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                    BorderSide(color: AppStyles.textPrimary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                keyboardType: TextInputType.url,
                style: TextStyle(
                  fontSize: 16,
                  color: AppStyles.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            'Add assets or reference files',
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
            'Share links to relevant files, documents, or inspiration (optional)',
            style: AppStyles.bodyMedium.copyWith(
              color: AppStyles.textSecondary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 32),
          UrlButton(
            icon: PhosphorIconsRegular.googleDriveLogo,
            label: 'Google Drive URL',
            onTap: () => _showUrlBottomSheet(
                context, 'Google Drive URL', googleDriveController),
            hasUrl: googleDriveController.text.isNotEmpty,
          ),
          const SizedBox(height: 12),
          UrlButton(
            icon: PhosphorIconsRegular.dropboxLogo,
            label: 'Dropbox URL',
            onTap: () =>
                _showUrlBottomSheet(context, 'Dropbox URL', dropboxController),
            hasUrl: dropboxController.text.isNotEmpty,
          ),
          const SizedBox(height: 12),
          UrlButton(
            icon: PhosphorIconsRegular.link,
            label: 'Other URL',
            onTap: () =>
                _showUrlBottomSheet(context, 'Other URL', otherController),
            hasUrl: otherController.text.isNotEmpty,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class UrlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hasUrl;

  const UrlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.hasUrl = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: AppStyles.textPrimary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppStyles.textPrimary,
                  ),
                ),
              ),
              if (hasUrl)
                Icon(
                  PhosphorIconsRegular.check,
                  size: 20,
                  color: Colors.green,
                ),
            ],
          ),
        ),
      ),
    );
  }
}