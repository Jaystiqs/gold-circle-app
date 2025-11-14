import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../utils/app_styles.dart';

class ClientSelfTaskRequestsPage extends StatefulWidget {
  const ClientSelfTaskRequestsPage({super.key});

  @override
  State<ClientSelfTaskRequestsPage> createState() => _ClientSelfTaskRequestsPageState();
}

class _ClientSelfTaskRequestsPageState extends State<ClientSelfTaskRequestsPage> {
  int _selectedFilterIndex = 0;
  final List<Map<String, String>> _filters = [
    {'label': 'All', 'value': 'all'},
    {'label': 'Open', 'value': 'open'},
    {'label': 'In Progress', 'value': 'in-progress'},
    {'label': 'Completed', 'value': 'completed'},
    {'label': 'Cancelled', 'value': 'cancelled'},
  ];

  String get _selectedFilter => _filters[_selectedFilterIndex]['value']!;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppStyles.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppStyles.backgroundWhite,
          elevation: 0,
          leading: IconButton(
            icon: Icon(PhosphorIcons.arrowLeft(), color: AppStyles.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Task Requests',
            style: AppStyles.h2.copyWith(
                color: AppStyles.textSecondary
            ),
          ),
        ),
        body: const Center(
          child: Text('Please log in to view your task requests'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppStyles.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIcons.arrowLeft(), color: AppStyles.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Task Requests',
          style: AppStyles.h3.copyWith(
              color: AppStyles.textPrimary
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _buildTaskRequestsList(user.uid),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
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
                  filter['label']!,
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
      ),
    );
  }

  Widget _buildTaskRequestsList(String userId) {
    Query query = FirebaseFirestore.instance
        .collection('task_requests')
        .where('clientId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    if (_selectedFilter != 'all') {
      query = query.where('status', isEqualTo: _selectedFilter);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildTaskRequestCard(doc.id, data);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.clipboardText(),
              size: 64,
              color: AppStyles.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No task requests yet',
              style: AppStyles.h4.copyWith(
                color: AppStyles.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 'all'
                  ? 'Post your first task request to get started'
                  : 'No ${_selectedFilter.replaceAll('-', ' ')} tasks',
              style: AppStyles.bodyMedium.copyWith(
                color: AppStyles.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskRequestCard(String taskId, Map<String, dynamic> data) {
    final status = data['status'] ?? 'open';
    final proposalCount = data['proposalCount'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppStyles.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showTaskDetails(taskId, data);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data['title'] ?? 'Untitled Task',
                      style: AppStyles.h5.copyWith(
                        fontWeight: AppStyles.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusBadge(status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                data['description'] ?? '',
                style: AppStyles.bodyMedium.copyWith(
                  color: AppStyles.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    PhosphorIcons.folder(),
                    data['category'] ?? 'Uncategorized',
                  ),
                  _buildInfoChip(
                    PhosphorIcons.currencyCircleDollar(),
                    'GHS${(data['budgetMin'] ?? 0).round()} - GHS${(data['budgetMax'] ?? 0).round()}',
                  ),
                  _buildInfoChip(
                    PhosphorIcons.clock(),
                    data['timeline'] ?? 'No timeline',
                  ),
                  if (proposalCount > 0)
                    _buildInfoChip(
                      PhosphorIcons.users(),
                      '$proposalCount ${proposalCount == 1 ? 'proposal' : 'proposals'}',
                      color: AppStyles.goldPrimary,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'open':
        color = Colors.green;
        icon = PhosphorIcons.circleDashed();
        break;
      case 'in-progress':
        color = Colors.blue;
        icon = PhosphorIcons.clockCounterClockwise();
        break;
      case 'completed':
        color = Colors.purple;
        icon = PhosphorIcons.checkCircle();
        break;
      case 'cancelled':
        color = Colors.red;
        icon = PhosphorIcons.xCircle();
        break;
      default:
        color = Colors.grey;
        icon = PhosphorIcons.circle();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status.replaceAll('-', ' ').toUpperCase(),
            style: AppStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppStyles.backgroundGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color ?? AppStyles.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppStyles.bodySmall.copyWith(
              color: color ?? AppStyles.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(String taskId, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppStyles.borderLight),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Task Details',
                      style: AppStyles.h5.copyWith(
                        fontWeight: AppStyles.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(PhosphorIcons.x()),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data['title'] ?? 'Untitled Task',
                            style: AppStyles.h3.copyWith(
                              fontWeight: AppStyles.bold,
                            ),
                          ),
                        ),
                        _buildStatusBadge(data['status'] ?? 'open'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailSection('Category', data['category'] ?? 'Uncategorized'),
                    const SizedBox(height: 16),
                    _buildDetailSection('Budget Range',
                        'GHS${(data['budgetMin'] ?? 0).round()} - GHS${(data['budgetMax'] ?? 0).round()}'),
                    const SizedBox(height: 16),
                    _buildDetailSection('Timeline', data['timeline'] ?? 'No timeline'),
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: AppStyles.h5.copyWith(
                        fontWeight: AppStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data['description'] ?? 'No description provided',
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppStyles.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    if (data['skills'] != null && (data['skills'] as List).isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Required Skills',
                        style: AppStyles.h5.copyWith(
                          fontWeight: AppStyles.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (data['skills'] as List).map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppStyles.goldPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppStyles.goldPrimary),
                            ),
                            child: Text(
                              skill,
                              style: AppStyles.bodySmall.copyWith(
                                color: AppStyles.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const SizedBox(height: 32),
                    if (data['status'] == 'open')
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _cancelTask(taskId);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel Task',
                                style: AppStyles.button.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // View proposals
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppStyles.goldPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'View Proposals (${data['proposalCount'] ?? 0})',
                                style: AppStyles.button.copyWith(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppStyles.bodyMedium.copyWith(
              color: AppStyles.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppStyles.bodyMedium.copyWith(
              color: AppStyles.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _cancelTask(String taskId) async {
    try {
      await FirebaseFirestore.instance
          .collection('task_requests')
          .doc(taskId)
          .update({
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task cancelled successfully'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling task: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}