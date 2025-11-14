import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';

class ProviderJobsPage extends StatefulWidget {
  const ProviderJobsPage({super.key});

  @override
  State<ProviderJobsPage> createState() => _ProviderJobsPageState();
}

class _ProviderJobsPageState extends State<ProviderJobsPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Available', 'My Jobs', 'Applied', 'Completed'];

  bool _isLoading = false;
  List<Map<String, dynamic>> _jobs = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);

    try {
      // Load jobs based on selected filter
      // For now, using mock data
      _jobs = _getMockJobs();

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading jobs: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> _getMockJobs() {
    // Mock available jobs from clients
    if (_selectedFilterIndex == 0) {
      return [
        {
          'id': '1',
          'title': 'E-commerce Website Design',
          'description': 'Looking for a talented designer to create a modern e-commerce website with clean UI/UX.',
          'client': 'Sarah Johnson',
          'clientImage': 'https://avatar.iran.liara.run/public/girl',
          'budget': 2500.0,
          'budgetType': 'fixed',
          'deadline': DateTime.now().add(const Duration(days: 14)),
          'category': 'Web Design',
          'skills': ['UI/UX', 'Figma', 'Responsive Design'],
          'postedDate': DateTime.now().subtract(const Duration(hours: 3)),
          'applicants': 5,
        },
        {
          'id': '2',
          'title': 'Mobile App UI Mockups',
          'description': 'Need high-fidelity mockups for a fitness tracking mobile app. Should include onboarding, dashboard, and workout screens.',
          'client': 'Michael Chen',
          'clientImage': 'https://avatar.iran.liara.run/public/boy',
          'budget': 1200.0,
          'budgetType': 'fixed',
          'deadline': DateTime.now().add(const Duration(days: 7)),
          'category': 'Mobile Design',
          'skills': ['UI Design', 'Mobile', 'Figma'],
          'postedDate': DateTime.now().subtract(const Duration(hours: 8)),
          'applicants': 3,
        },
        {
          'id': '3',
          'title': 'Brand Identity Design',
          'description': 'Startup looking for complete brand identity including logo, color palette, and brand guidelines.',
          'client': 'Emily Davis',
          'clientImage': 'https://avatar.iran.liara.run/public/girl',
          'budget': 3500.0,
          'budgetType': 'fixed',
          'deadline': DateTime.now().add(const Duration(days: 21)),
          'category': 'Branding',
          'skills': ['Logo Design', 'Brand Identity', 'Illustrator'],
          'postedDate': DateTime.now().subtract(const Duration(days: 1)),
          'applicants': 12,
        },
        {
          'id': '4',
          'title': 'Social Media Graphics Pack',
          'description': 'Need 30 Instagram post templates for a fashion brand. Must be trendy and eye-catching.',
          'client': 'James Wilson',
          'clientImage': 'https://avatar.iran.liara.run/public/boy',
          'budget': 800.0,
          'budgetType': 'fixed',
          'deadline': DateTime.now().add(const Duration(days: 5)),
          'category': 'Graphic Design',
          'skills': ['Social Media', 'Canva', 'Design'],
          'postedDate': DateTime.now().subtract(const Duration(hours: 12)),
          'applicants': 8,
        },
      ];
    }
    // Mock active jobs
    else if (_selectedFilterIndex == 1) {
      return [
        {
          'id': '5',
          'title': 'Logo Design for Tech Startup',
          'description': 'Modern logo design for an AI company.',
          'client': 'Sarah Johnson',
          'clientImage': 'https://avatar.iran.liara.run/public/girl',
          'budget': 850.0,
          'status': 'in-progress',
          'progress': 0.65,
          'deadline': DateTime.now().add(const Duration(days: 2)),
          'category': 'Graphic Design',
        },
        {
          'id': '6',
          'title': 'Website Mockup Design',
          'description': 'Landing page mockup for SaaS product.',
          'client': 'Michael Chen',
          'clientImage': 'https://avatar.iran.liara.run/public/boy',
          'budget': 1200.0,
          'status': 'in-progress',
          'progress': 0.30,
          'deadline': DateTime.now().add(const Duration(days: 5)),
          'category': 'UI/UX Design',
        },
      ];
    }
    return [];
  }

  List<Map<String, dynamic>> get filteredJobs {
    if (_searchQuery.isEmpty) return _jobs;

    return _jobs.where((job) {
      final title = (job['title'] as String? ?? '').toLowerCase();
      final description = (job['description'] as String? ?? '').toLowerCase();
      final category = (job['category'] as String? ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();

      return title.contains(query) ||
          description.contains(query) ||
          category.contains(query);
    }).toList();
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // _buildHeader(),
            _buildSearchBar(),
            _buildFilterTabs(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadJobs,
                color: AppStyles.goldPrimary,
                child: _isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
                    strokeWidth: 2,
                  ),
                )
                    : _buildJobsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Jobs',
              style: AppStyles.h1.copyWith(
                color: AppStyles.textPrimary,
                fontWeight: AppStyles.bold,
                letterSpacing: -1.5,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              PhosphorIcons.sliders(),
              color: AppStyles.textPrimary,
            ),
            onPressed: () {
              // Show filter options
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Advanced filters coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppStyles.backgroundGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppStyles.textLight.withOpacity(0.3),
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          style: AppStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: 'Search jobs...',
            hintStyle: AppStyles.bodyLarge.copyWith(
              color: AppStyles.textLight,
            ),
            prefixIcon: Icon(
              PhosphorIcons.magnifyingGlass(),
              color: AppStyles.textLight,
              size: 20,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: Icon(
                PhosphorIcons.x(),
                color: AppStyles.textLight,
                size: 20,
              ),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.asMap().entries.map((entry) {
            final index = entry.key;
            final filter = entry.value;
            final isSelected = index == _selectedFilterIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                  _loadJobs();
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppStyles.textPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? AppStyles.textPrimary : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppStyles.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildJobsList() {
    final jobs = filteredJobs;

    if (jobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIcons.briefcase(),
                size: 64,
                color: AppStyles.textLight,
              ),
              const SizedBox(height: 16),
              Text(
                _searchQuery.isNotEmpty ? 'No jobs found' : 'No jobs available',
                style: AppStyles.bodyLarge.copyWith(
                  color: AppStyles.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_searchQuery.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search',
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppStyles.textLight,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      itemCount: jobs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final job = jobs[index];

        // Show different card based on filter
        if (_selectedFilterIndex == 1) {
          return _buildActiveJobCard(job);
        }
        return _buildAvailableJobCard(job);
      },
    );
  }

  Widget _buildAvailableJobCard(Map<String, dynamic> job) {
    final postedDate = job['postedDate'] as DateTime?;
    final applicants = job['applicants'] as int? ?? 0;
    final skills = job['skills'] as List<dynamic>? ?? [];
    final deadline = job['deadline'] as DateTime?;
    final daysLeft = deadline != null ? deadline.difference(DateTime.now()).inDays : 0;

    return InkWell(
      onTap: () {
        _showJobDetails(job);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppStyles.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppStyles.backgroundGrey,
                  ),
                  child: job['clientImage'] != null
                      ? ClipOval(
                    child: Image.network(
                      job['clientImage'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          PhosphorIcons.user(),
                          color: AppStyles.textLight,
                          size: 20,
                        );
                      },
                    ),
                  )
                      : Icon(
                    PhosphorIcons.user(),
                    color: AppStyles.textLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['client'] ?? 'Client',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppStyles.textPrimary,
                        ),
                      ),
                      if (postedDate != null)
                        Text(
                          _formatTimeAgo(postedDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppStyles.textLight,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppStyles.goldPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'GHS${job['budget']?.toStringAsFixed(0) ?? '0'}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppStyles.goldPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              job['title'] ?? 'Job Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppStyles.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              job['description'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: AppStyles.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (skills.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: skills.take(3).map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppStyles.backgroundGrey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      skill.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppStyles.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  PhosphorIcons.clock(),
                  size: 14,
                  color: AppStyles.textLight,
                ),
                const SizedBox(width: 4),
                Text(
                  '$daysLeft days left',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppStyles.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  PhosphorIcons.users(),
                  size: 14,
                  color: AppStyles.textLight,
                ),
                const SizedBox(width: 4),
                Text(
                  '$applicants applicants',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppStyles.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveJobCard(Map<String, dynamic> job) {
    final progress = (job['progress'] as num?)?.toDouble() ?? 0.0;
    final deadline = job['deadline'] as DateTime?;
    final daysLeft = deadline != null ? deadline.difference(DateTime.now()).inDays : 0;

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job details coming soon')),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppStyles.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppStyles.backgroundGrey,
                  ),
                  child: job['clientImage'] != null
                      ? ClipOval(
                    child: Image.network(
                      job['clientImage'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          PhosphorIcons.user(),
                          color: AppStyles.textLight,
                          size: 20,
                        );
                      },
                    ),
                  )
                      : Icon(
                    PhosphorIcons.user(),
                    color: AppStyles.textLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['title'] ?? 'Job Title',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppStyles.textPrimary,
                        ),
                      ),
                      Text(
                        job['client'] ?? 'Client',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppStyles.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'In Progress',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppStyles.textSecondary,
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(AppStyles.goldPrimary),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  PhosphorIcons.clock(),
                  size: 14,
                  color: daysLeft <= 2 ? Colors.red : AppStyles.textLight,
                ),
                const SizedBox(width: 4),
                Text(
                  '$daysLeft days left',
                  style: TextStyle(
                    fontSize: 13,
                    color: daysLeft <= 2 ? Colors.red : AppStyles.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  'GHS${job['budget']?.toStringAsFixed(0) ?? '0'}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppStyles.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showJobDetails(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'] ?? 'Job Title',
                          style: AppStyles.h3.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppStyles.backgroundGrey,
                              ),
                              child: job['clientImage'] != null
                                  ? ClipOval(
                                child: Image.network(
                                  job['clientImage'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      PhosphorIcons.user(),
                                      color: AppStyles.textLight,
                                    );
                                  },
                                ),
                              )
                                  : Icon(PhosphorIcons.user(), color: AppStyles.textLight),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job['client'] ?? 'Client',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Client',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppStyles.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          job['description'] ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppStyles.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Skills Required',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (job['skills'] as List<dynamic>? ?? []).map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppStyles.backgroundGrey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                skill.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppStyles.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem(
                                'Budget',
                                'GHS${job['budget']?.toStringAsFixed(0) ?? '0'}',
                              ),
                            ),
                            Expanded(
                              child: _buildDetailItem(
                                'Deadline',
                                '${(job['deadline'] as DateTime?)?.difference(DateTime.now()).inDays ?? 0} days',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Apply functionality coming soon')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.goldPrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Apply Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: AppStyles.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppStyles.textPrimary,
          ),
        ),
      ],
    );
  }
}