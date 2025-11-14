import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import '../../utils/app_styles.dart';
import '../../creators/user_provider.dart';

// Data model for ongoing projects
class OngoingProject {
  final String id;
  final String clientName;
  final String clientImage;
  final String projectTitle;
  final String category;
  final double progress; // 0.0 to 1.0
  final DateTime deadline;
  final String status; // 'in_progress', 'review', 'revision'
  final double price;

  OngoingProject({
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

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  State<ProviderHomePage> createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  Map<String, dynamic>? _providerData;

  // Mock ongoing projects - replace with Firestore data
  final List<OngoingProject> _ongoingProjects = [
    OngoingProject(
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
    OngoingProject(
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
    OngoingProject(
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
  ];

  @override
  void initState() {
    super.initState();
    _loadProviderData();
  }

  Future<void> _loadProviderData() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final providerDoc = await _firestore.collection('creators').doc(user.uid).get();
        _providerData = providerDoc.data();
      }

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading provider data: $e');
      setState(() => _isLoading = false);
    }
  }

  String get firstName {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.userModel?.firstName ?? 'Provider';
  }

  String get fullName {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.userModel?.firstName ?? 'Provider';
  }

  double get rating => (_providerData?['rating'] ?? 4.8).toDouble();
  int get completedJobs => _providerData?['completedJobs'] ?? 24;
  double get totalEarnings => (_providerData?['totalEarnings'] ?? 835.25).toDouble();
  double get monthlyTarget => 1000.0;
  double get responseRate => 0.80;
  double get completionRate => 0.60;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppStyles.backgroundWhite,
        body: Center(
          child: Container(
            height: 70,
            child: Lottie.asset(
              'assets/animations/gc_main_loader.json',
              repeat: true,
              animate: true,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadProviderData,
          color: AppStyles.goldPrimary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildProfileHeader(),
                const SizedBox(height: 32),
                _buildEarningsCard(),
                const SizedBox(height: 24),
                _buildQuickActionsRow(),
                // const SizedBox(height: 24),
                // _buildStatsRow(),
                const SizedBox(height: 40),
                _buildOngoingProjectsSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final photoUrl = userProvider.firebaseUser?.photoURL ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          // Container(
          //   width: 52,
          //   height: 52,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: AppStyles.backgroundGrey,
          //     image: photoUrl.isNotEmpty
          //         ? DecorationImage(
          //       image: NetworkImage(photoUrl),
          //       fit: BoxFit.cover,
          //     )
          //         : null,
          //   ),
          //   child: photoUrl.isEmpty
          //       ? Center(
          //     child: Text(
          //       firstName.isNotEmpty ? firstName[0].toUpperCase() : 'P',
          //       style: AppStyles.h5.copyWith(
          //         color: AppStyles.textSecondary,
          //       ),
          //     ),
          //   )
          //       : null,
          // ),
          // const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Hi, ",
                      style: AppStyles.h2.copyWith(
                        color: AppStyles.textSecondary
                      ),
                    ),
                    Text(
                      firstName,
                      style: AppStyles.h2.copyWith(
                          color: AppStyles.goldPrimary
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              PhosphorIcons.bell(),
              color: AppStyles.textPrimary,
              size: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.withOpacity(0.20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have earned',
                style: AppStyles.h2.copyWith(
                  color: AppStyles.textSecondary,
                  fontSize: 23,
                  fontWeight: AppStyles.medium,
                ),
              ),
              const SizedBox(height: 0),
              Text(
                'GHS${totalEarnings.toStringAsFixed(2)}',
                style: AppStyles.h1.copyWith(
                  fontWeight: AppStyles.bold,
                  fontSize: 43,
                  color: AppStyles.textBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildEarningsCard() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //     child: Container(
  //       padding: const EdgeInsets.all(24),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20),
  //         border: Border.all(
  //           color: Colors.grey.withOpacity(0.15),
  //         ),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.08),
  //             blurRadius: 20,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           // Left side - Earnings
  //           Expanded(
  //             flex: 3,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'You have earned',
  //                   style: AppStyles.bodyMedium.copyWith(
  //                     color: AppStyles.textSecondary,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Text(
  //                   'GHS${totalEarnings.toStringAsFixed(2)}',
  //                   style: AppStyles.h2.copyWith(
  //                     fontWeight: AppStyles.bold,
  //                     color: AppStyles.goldPrimary,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //
  //           const SizedBox(width: 16),
  //
  //           // Right side - Stats
  //           Expanded(
  //             flex: 2,
  //             child: Column(
  //               children: [
  //                 _buildEarningsStatItem(
  //                   '${(responseRate * 100).toInt()}%',
  //                   'Response time',
  //                 ),
  //                 const SizedBox(height: 16),
  //                 _buildEarningsStatItem(
  //                   '${rating.toStringAsFixed(1)}★',
  //                   'Rating',
  //                 ),
  //                 const SizedBox(height: 16),
  //                 _buildEarningsStatItem(
  //                   '${_ongoingProjects.length}',
  //                   'Active projects',
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildEarningsStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppStyles.h5.copyWith(
            fontWeight: AppStyles.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildQuickActionsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              image: 'assets/images/find_tasks.png',
              title: 'Find tasks to\nwork on',
              subtitle: 'to work on',
              icon: PhosphorIcons.magnifyingGlass(),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Find projects coming soon')),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              image: 'assets/images/rewards.png',
              title: 'Unlock\nrewards',
              subtitle: 'rewards',
              icon: PhosphorIcons.gift(),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rewards coming soon')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String image,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for image - you can replace with your own images
            Center(
              child: Container(
                width: 44,
                height: 44,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                title,
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: AppStyles.medium,
                  height: 1
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Center(
            //   child: Text(
            //     subtitle,
            //     style: AppStyles.h6.copyWith(
            //       fontWeight: AppStyles.semiBold,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _buildStatsRow() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: _buildStatCard(
  //             label: 'Response\nOn-time rate',
  //             value: '${(responseRate * 100).toInt()}%',
  //             color: Color(0xFF1BC5BD),
  //             icon: Icons.trending_up,
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: _buildStatCard(
  //             label: 'Order\nCompletion',
  //             value: '${(completionRate * 100).toInt()}%',
  //             color: Color(0xFFFFA800),
  //             icon: Icons.check_circle_outline,
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: _buildStatCard(
  //             label: 'Positive\nRating',
  //             value: '${rating.toStringAsFixed(1)}/5.0',
  //             color: Color(0xFFFFC107),
  //             icon: Icons.star,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildStatCard({
  //   required String label,
  //   required String value,
  //   required Color color,
  //   required IconData icon,
  // }) {
  //   double percentage = 0.0;
  //   if (value.contains('%')) {
  //     percentage = double.tryParse(value.replaceAll('%', '')) ?? 0.0;
  //     percentage = percentage / 100;
  //   } else if (value.contains('/')) {
  //     final parts = value.split('/');
  //     if (parts.length == 2) {
  //       final current = double.tryParse(parts[0]) ?? 0.0;
  //       final max = double.tryParse(parts[1]) ?? 5.0;
  //       percentage = current / max;
  //     }
  //   }
  //
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: AppStyles.backgroundWhite,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: Colors.grey.withOpacity(0.15),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.03),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: 48,
  //           height: 48,
  //           child: Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               SizedBox(
  //                 width: 48,
  //                 height: 48,
  //                 child: CircularProgressIndicator(
  //                   value: percentage,
  //                   strokeWidth: 4,
  //                   backgroundColor: color.withOpacity(0.15),
  //                   valueColor: AlwaysStoppedAnimation<Color>(color),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         Text(
  //           value,
  //           style: AppStyles.h5.copyWith(
  //             fontWeight: AppStyles.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           label,
  //           style: AppStyles.bodySmall,
  //           maxLines: 2,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildOngoingProjectsSection() {
    if (_ongoingProjects.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Ongoing tasks',
                    style: AppStyles.h4.copyWith(
                      fontWeight: AppStyles.medium
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Icon(
                    Icons.chevron_right,
                    color: AppStyles.textSecondary,
                    size: 20.0,
                  ),
                ],
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Navigate to all projects
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('View all projects coming soon')),
              //     );
              //   },
              //   child: Text(
              //     'View all',
              //     style: AppStyles.bodyMedium.copyWith(
              //       color: AppStyles.textSecondary,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: _ongoingProjects.map((project) {
              final index = _ongoingProjects.indexOf(project);
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == _ongoingProjects.length - 1 ? 0 : 16,
                ),
                child: _buildProjectCard(project),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(OngoingProject project) {
    final daysRemaining = project.deadline.difference(DateTime.now()).inDays;
    final hoursRemaining = project.deadline.difference(DateTime.now()).inHours;

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
        // Navigate to project details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${project.projectTitle}')),
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
                  project.clientImage,
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

            // Project details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project title
                  Text(
                    project.projectTitle,
                    style: AppStyles.bodyLarge.copyWith(
                      fontWeight: AppStyles.semiBold,
                      color: AppStyles.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Client name and category
                  Row(
                    children: [
                      Text(
                        project.clientName,
                        style: AppStyles.bodySmall.copyWith(
                          color: AppStyles.textSecondary,
                        ),
                      ),
                      // Text(
                      //   ' • ',
                      //   style: AppStyles.bodySmall.copyWith(
                      //     color: AppStyles.textLight,
                      //   ),
                      // ),
                      // Text(
                      //   project.category,
                      //   style: AppStyles.bodySmall.copyWith(
                      //     color: AppStyles.textSecondary,
                      //   ),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: project.progress,
                      backgroundColor: Colors.grey.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        project.progress >= 0.8
                            ? Color(0xFF1BC5BD)
                            : project.progress >= 0.5
                            ? Color(0xFFFFA800)
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
                        '${(project.progress * 100).toInt()}% complete',
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
        return Color(0xFF1BC5BD);
      case 'review':
        return Color(0xFFFFA800);
      case 'revision':
        return Colors.orange;
      default:
        return AppStyles.textSecondary;
    }
  }
}