import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';

// Data model for tasks
class Task {
  final String id;
  final String clientName;
  final String clientImage;
  final String projectTitle;
  final String category;
  final double progress; // 0.0 to 1.0
  final DateTime deadline;
  final String status; // 'in_progress', 'review', 'revision'
  final double price;

  Task({
    required this.id,
    required this.clientName,
    required this.clientImage,
    required this.projectTitle,
    required this.category,
    required this.progress,
    required this.deadline,
    required this.status,
    required this.price,
  });
}

class ProviderTasksPage extends StatefulWidget {
  const ProviderTasksPage({super.key});

  @override
  State<ProviderTasksPage> createState() => _ProviderTasksPageState();
}

class _ProviderTasksPageState extends State<ProviderTasksPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'In Progress', 'Review', 'Revision'];

  // Mock tasks - replace with Firestore data
  final List<Task> _allTasks = [
    Task(
      id: '1',
      clientName: 'Michael Chen',
      clientImage: 'https://avatar.iran.liara.run/public/boy',
      projectTitle: 'Social Media Marketing',
      category: 'Social Media',
      progress: 0.65,
      deadline: DateTime.now().add(const Duration(days: 3)),
      status: 'in_progress',
      price: 2500,
    ),
    Task(
      id: '2',
      clientName: 'Emily Davis',
      clientImage: 'https://avatar.iran.liara.run/public/girl',
      projectTitle: 'Logo design',
      category: 'Commercial',
      progress: 0.85,
      deadline: DateTime.now().add(const Duration(days: 1)),
      status: 'review',
      price: 800,
    ),
    Task(
      id: '3',
      clientName: 'Sarah Johnson',
      clientImage: 'https://avatar.iran.liara.run/public/girl',
      projectTitle: 'Thesis Writing',
      category: 'Events',
      progress: 0.40,
      deadline: DateTime.now().add(const Duration(days: 7)),
      status: 'in_progress',
      price: 1500,
    ),
    Task(
      id: '4',
      clientName: 'David Williams',
      clientImage: 'https://avatar.iran.liara.run/public/boy',
      projectTitle: 'Social Media Ad',
      category: 'Portrait',
      progress: 0.95,
      deadline: DateTime.now().add(const Duration(hours: 12)),
      status: 'review',
      price: 650,
    ),
    Task(
      id: '5',
      clientName: 'Jessica Martinez',
      clientImage: 'https://avatar.iran.liara.run/public/girl',
      projectTitle: 'Proofreading',
      category: 'Commercial',
      progress: 0.30,
      deadline: DateTime.now().add(const Duration(days: 5)),
      status: 'in_progress',
      price: 1200,
    ),
    Task(
      id: '6',
      clientName: 'Robert Brown',
      clientImage: 'https://avatar.iran.liara.run/public/boy',
      projectTitle: 'Food Menu Design',
      category: 'Commercial',
      progress: 0.55,
      deadline: DateTime.now().add(const Duration(days: 2)),
      status: 'revision',
      price: 450,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Load tasks from Firestore
        // For now, using mock data
      }

      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading tasks: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Task> get _filteredTasks {
    if (_selectedFilterIndex == 0) return _allTasks; // All

    String statusFilter;
    switch (_selectedFilterIndex) {
      case 1:
        statusFilter = 'in_progress';
        break;
      case 2:
        statusFilter = 'review';
        break;
      case 3:
        statusFilter = 'revision';
        break;
      default:
        return _allTasks;
    }

    return _allTasks.where((task) => task.status == statusFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterSection(),
            Expanded(
              child: _isLoading
                  ? Center(
                child: SizedBox(
                  height: 70,
                  child: Lottie.asset(
                    'assets/animations/gc_main_loader.json',
                    repeat: true,
                    animate: true,
                  ),
                ),
              )
                  : RefreshIndicator(
                onRefresh: _loadTasks,
                color: AppStyles.goldPrimary,
                child: _filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  itemCount: _filteredTasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom:
                        index == _filteredTasks.length - 1 ? 0 : 0,
                      ),
                      child: _buildTaskCard(_filteredTasks[index]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 16.0, 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Tasks',
              style: AppStyles.h1.copyWith(
                  color: AppStyles.textPrimary,
                  fontWeight: AppStyles.bold,
                  letterSpacing: -1.5
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              PhosphorIcons.funnelSimple(),
              color: AppStyles.textPrimary,
              size: 24,
            ),
            onPressed: () {
              // Show filter bottom sheet
              _showFilterBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
      child: _buildFilterTabs(),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
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
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppStyles.textPrimary
                    : AppStyles.backgroundGrey,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                filter,
                style: AppStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.white : AppStyles.textPrimary,
                  fontWeight:
                  isSelected ? AppStyles.semiBold : AppStyles.medium,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    final daysRemaining = task.deadline.difference(DateTime.now()).inDays;
    final hoursRemaining = task.deadline.difference(DateTime.now()).inHours;

    String timeText;
    Color timeColor;

    if (daysRemaining > 0) {
      timeText = '$daysRemaining day${daysRemaining == 1 ? '' : 's'} left';
      timeColor = daysRemaining <= 2 ? Colors.orange : AppStyles.textSecondary;
    } else if (hoursRemaining > 0) {
      timeText = '$hoursRemaining hour${hoursRemaining == 1 ? '' : 's'} left';
      timeColor = Colors.red;
    } else {
      timeText = 'Due now';
      timeColor = Colors.red;
    }

    return GestureDetector(
      onTap: () {
        // Navigate to task details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${task.projectTitle}')),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppStyles.backgroundGrey,
              ),
              child: ClipOval(
                child: Image.network(
                  task.clientImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      PhosphorIcons.user(),
                      color: AppStyles.textLight,
                      size: 24,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Task details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task title
                  Text(
                    task.projectTitle,
                    style: AppStyles.bodyLarge.copyWith(
                      fontWeight: AppStyles.semiBold,
                      color: AppStyles.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Client name and status
                  Row(
                    children: [
                      Text(
                        task.clientName,
                        style: AppStyles.bodySmall.copyWith(
                          color: AppStyles.textSecondary,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: AppStyles.bodySmall.copyWith(
                          color: AppStyles.textLight,
                        ),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(task.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getStatusText(task.status),
                          style: AppStyles.bodySmall.copyWith(
                            color: _getStatusColor(task.status),
                            fontSize: 11,
                            fontWeight: AppStyles.medium,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: task.progress,
                      backgroundColor: Colors.grey.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        task.progress >= 0.8
                            ? const Color(0xFF1BC5BD)
                            : task.progress >= 0.5
                            ? const Color(0xFFFFA800)
                            : AppStyles.goldPrimary,
                      ),
                      minHeight: 4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Progress percentage and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(task.progress * 100).toInt()}% complete',
                        style: AppStyles.bodySmall.copyWith(
                          color: AppStyles.textSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            PhosphorIcons.clock(),
                            size: 12,
                            color: timeColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeText,
                            style: AppStyles.bodySmall.copyWith(
                              color: timeColor,
                            ),
                          ),
                        ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.folder(),
            size: 80,
            color: AppStyles.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: AppStyles.h5.copyWith(
              color: AppStyles.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tasks matching your filter will appear here',
            style: AppStyles.bodyMedium.copyWith(
              color: AppStyles.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort & Filter',
                    style: AppStyles.h4.copyWith(
                      fontWeight: AppStyles.semiBold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.x(),
                      color: AppStyles.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildFilterOption('Sort by deadline', PhosphorIcons.calendar()),
              _buildFilterOption('Sort by progress', PhosphorIcons.chartLine()),
              _buildFilterOption('Sort by client', PhosphorIcons.user()),
              _buildFilterOption(
                  'Sort by price', PhosphorIcons.currencyDollar()),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title coming soon')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.15),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppStyles.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppStyles.bodyMedium.copyWith(
                color: AppStyles.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      case 'review':
        return 'In Review';
      case 'revision':
        return 'Revision';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'in_progress':
        return const Color(0xFF1BC5BD);
      case 'review':
        return const Color(0xFFFFA800);
      case 'revision':
        return Colors.orange;
      default:
        return AppStyles.textSecondary;
    }
  }
}