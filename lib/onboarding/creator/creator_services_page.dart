import 'package:flutter/material.dart';
import '../../utils/app_styles.dart';

class CreatorServicesPage extends StatefulWidget {
  final Function(String service) onServiceSelected;

  const CreatorServicesPage({
    super.key,
    required this.onServiceSelected,
  });

  @override
  State<CreatorServicesPage> createState() => _CreatorServicesPageState();
}

class _CreatorServicesPageState extends State<CreatorServicesPage> {
  String? _selectedService;

  final List<ServiceOption> _services = [
    ServiceOption(
      id: 'design',
      title: 'Design & Creative',
      icon: Icons.palette_outlined,
      color: Color(0xFFE3F2FD),
    ),
    ServiceOption(
      id: 'development',
      title: 'Development & Tech',
      icon: Icons.code,
      color: Color(0xFFF3E5F5),
    ),
    // ServiceOption(
    //   id: 'writing',
    //   title: 'Writing & Content',
    //   icon: Icons.edit_note,
    //   color: Color(0xFFFFF3E0),
    // ),
    // ServiceOption(
    //   id: 'marketing',
    //   title: 'Marketing & Sales',
    //   icon: Icons.trending_up,
    //   color: Color(0xFFE8F5E9),
    // ),
    ServiceOption(
      id: 'social_media',
      title: 'Social Media Mgt\n& UGC',
      icon: Icons.business_center_outlined,
      color: Color(0xFFFCE4EC),
    ),
  ];

  void _selectService(String serviceId) {
    setState(() {
      _selectedService = serviceId;
    });
    widget.onServiceSelected(serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Static Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Text(
              'What service will you\nprovide on Gold Circle?',
              style: AppStyles.h1.copyWith(
                height: 1.2,
                fontSize: 28,
                color: AppStyles.textPrimary,
                fontWeight: AppStyles.semiBold,
                letterSpacing: -1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 32),


        // Scrollable Service Grid
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                final isSelected = _selectedService == service.id;

                return GestureDetector(
                  onTap: () => _selectService(service.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppStyles.backgroundWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppStyles.goldPrimary
                            : Colors.grey.withOpacity(0.2),
                        width: isSelected ? 2.5 : 1,
                      ),
                      boxShadow: [
                        if (!isSelected)
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon Container
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: service.color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            service.icon,
                            size: 36,
                            color: AppStyles.textPrimary.withOpacity(0.8),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            service.title,
                            style: AppStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppStyles.textBlack,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ServiceOption {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  ServiceOption({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}