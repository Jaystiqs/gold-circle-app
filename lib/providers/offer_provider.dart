import 'package:flutter/foundation.dart';
import '../models/offer.dart';

/// Provider for managing offers state
class OfferProvider with ChangeNotifier {
  final List<Offer> _offers = [];
  bool _isLoading = false;
  String? _error;

  List<Offer> get offers => List.unmodifiable(_offers);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Categories available for offers
  static const List<String> categories = [
    'Services',
    'Products',
    'Events',
    'Education',
    'Health & Wellness',
    'Technology',
    'Other',
  ];

  /// Adds a new offer
  Future<void> addOffer(Offer offer) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      _offers.insert(0, offer);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add offer: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Updates an existing offer
  Future<void> updateOffer(String id, Offer updatedOffer) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _offers.indexWhere((offer) => offer.id == id);
      if (index != -1) {
        _offers[index] = updatedOffer;
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Offer not found');
      }
    } catch (e) {
      _error = 'Failed to update offer: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Deletes an offer
  Future<void> deleteOffer(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _offers.removeWhere((offer) => offer.id == id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete offer: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Gets a single offer by ID
  Offer? getOfferById(String id) {
    try {
      return _offers.firstWhere((offer) => offer.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filters offers by category
  List<Offer> getOffersByCategory(String category) {
    return _offers.where((offer) => offer.category == category).toList();
  }

  /// Searches offers by title or description
  List<Offer> searchOffers(String query) {
    final lowerQuery = query.toLowerCase();
    return _offers.where((offer) {
      return offer.title.toLowerCase().contains(lowerQuery) ||
          offer.description.toLowerCase().contains(lowerQuery) ||
          offer.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Clears any error messages
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
