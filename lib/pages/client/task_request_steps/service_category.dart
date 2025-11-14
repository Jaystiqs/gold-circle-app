import 'package:cloud_firestore/cloud_firestore.dart';

/// Service Category data model
class ServiceCategory {
  final String id;
  final String name;
  final String displayName;
  final String icon;
  final String description;
  final String? parentId;
  final bool isActive;
  final int sortOrder;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    required this.description,
    this.parentId,
    required this.isActive,
    required this.sortOrder,
  });

  factory ServiceCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceCategory(
      id: doc.id,
      name: data['name'] ?? '',
      displayName: data['displayName'] ?? '',
      icon: data['icon'] ?? '',
      description: data['description'] ?? '',
      parentId: data['parentId'],
      isActive: data['isActive'] ?? true,
      sortOrder: data['sortOrder'] ?? 0,
    );
  }

  bool get isParentCategory => parentId == null;
  bool get isSubCategory => parentId != null;
}