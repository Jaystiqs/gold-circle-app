import 'package:uuid/uuid.dart';

/// Represents an offer in the Gold Circle app
class Offer {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final DateTime createdAt;
  final String createdBy;
  final List<String> tags;
  final String? imageUrl;
  final bool isActive;

  Offer({
    String? id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    DateTime? createdAt,
    required this.createdBy,
    this.tags = const [],
    this.imageUrl,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Creates a copy of this offer with the given fields replaced with new values
  Offer copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    DateTime? createdAt,
    String? createdBy,
    List<String>? tags,
    String? imageUrl,
    bool? isActive,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Converts offer to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'tags': tags,
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }

  /// Creates an offer from JSON
  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      tags: List<String>.from(json['tags'] as List? ?? []),
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
