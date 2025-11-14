import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceCategory {
  final String id;
  final String displayName;
  final String description;
  final String icon;
  final bool isParentCategory;
  final int sortOrder;

  ServiceCategory({
    required this.id,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.isParentCategory,
    required this.sortOrder,
  });

  factory ServiceCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceCategory(
      id: doc.id,
      displayName: data['displayName'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? 'briefcase',
      isParentCategory: data['isParentCategory'] ?? false,
      sortOrder: data['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'description': description,
      'icon': icon,
      'isParentCategory': isParentCategory,
      'sortOrder': sortOrder,
    };
  }
}