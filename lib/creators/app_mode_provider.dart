import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

enum AppMode {
  client,
  creator,
}

class AppModeCreator extends ChangeNotifier {
  AppMode _currentMode = AppMode.client;
  List<String> _activeRoles = ['client'];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<DocumentSnapshot>? _userDocSubscription;

  // NEW: Track if we're in the middle of a manual switch
  bool _isSwitching = false;

  // Getters
  AppMode get currentMode => _currentMode;
  bool get isClientMode => _currentMode == AppMode.client;
  bool get isCreatorMode => _currentMode == AppMode.creator;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get activeRoles => _activeRoles;

  bool hasRole(String role) => _activeRoles.contains(role);
  bool get isCreatorActivated => _activeRoles.contains('creator');
  bool get isClientActivated => _activeRoles.contains('client');

  AppModeCreator() {
    _initializeMode();
  }

  void _initializeMode() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _listenToUserDocument(user.uid);
    }
  }

  void _listenToUserDocument(String userId) {
    _userDocSubscription?.cancel();

    _userDocSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen(
          (snapshot) {
        // IMPROVED: Skip updates if we're actively switching OR loading
        if (_isSwitching || _isLoading) {
          print('⏸️ Skipping Firestore update during switch operation');
          return;
        }

        if (snapshot.exists) {
          final data = snapshot.data();
          if (data != null) {
            final currentRole = data['currentRole'] as String?;
            final activeRolesList = data['activeRoles'] as List<dynamic>?;

            _activeRoles = activeRolesList?.cast<String>() ?? ['client'];

            if (currentRole == 'creator') {
              _currentMode = AppMode.creator;
            } else {
              _currentMode = AppMode.client;
            }

            notifyListeners();
          }
        }
      },
      onError: (error) {
        print('Error listening to user document: $error');
      },
    );
  }

  /// Switch to creator mode with improved coordination
  Future<bool> switchToCreatorMode() async {
    print('🔄 Starting switch to creator mode...');

    // Set flags FIRST
    _isLoading = true;
    _isSwitching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _errorMessage = 'You must be logged in to switch to creator mode';
        return false;
      }

      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final creatorRef = FirebaseFirestore.instance.collection('creators').doc(user.uid);

      // Check if creator profile exists
      final creatorDoc = await creatorRef.get();

      if (!creatorDoc.exists) {
        print('📝 Creating creator profile...');
        await _createCreatorProfile(user.uid, userRef, creatorRef);
      }

      // Update Firestore
      print('💾 Updating Firestore documents...');
      await Future.wait([
        userRef.update({
          'currentRole': 'creator',
          'activeRoles': FieldValue.arrayUnion(['creator']),
          'updatedAt': FieldValue.serverTimestamp(),
        }),
        creatorRef.update({
          'isActive': true,
          'updatedAt': FieldValue.serverTimestamp(),
        }),
      ]);

      print('✅ Firestore updates complete');

      // Update local state IMMEDIATELY after Firestore
      _currentMode = AppMode.creator;
      if (!_activeRoles.contains('creator')) {
        _activeRoles.add('creator');
      }

      // Small delay to ensure Firestore propagation
      await Future.delayed(const Duration(milliseconds: 300));

      print('✅ Switch to creator mode complete');
      return true;

    } catch (e) {
      print('❌ Error switching to creator mode: $e');
      _errorMessage = 'Failed to switch to creator mode: ${e.toString()}';
      return false;
    } finally {
      // IMPORTANT: Reset flags in correct order
      _isLoading = false;

      // Wait a moment before allowing Firestore updates again
      await Future.delayed(const Duration(milliseconds: 100));
      _isSwitching = false;

      notifyListeners();
      print('🏁 Mode switch complete, flags reset');
    }
  }

  /// Switch to client mode with improved coordination
  Future<bool> switchToClientMode() async {
    print('🔄 Starting switch to client mode...');

    // Set flags FIRST
    _isLoading = true;
    _isSwitching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _errorMessage = 'You must be logged in to switch to client mode';
        return false;
      }

      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final clientRef = FirebaseFirestore.instance.collection('clients').doc(user.uid);

      // Check if client profile exists
      final clientDoc = await clientRef.get();

      if (!clientDoc.exists) {
        print('📝 Creating client profile...');
        await _createClientProfile(user.uid, clientRef);
      }

      // Update Firestore
      print('💾 Updating Firestore documents...');
      await Future.wait([
        userRef.update({
          'currentRole': 'client',
          'updatedAt': FieldValue.serverTimestamp(),
        }),
        clientRef.update({
          'isActive': true,
          'updatedAt': FieldValue.serverTimestamp(),
        }),
      ]);

      print('✅ Firestore updates complete');

      // Update local state IMMEDIATELY after Firestore
      _currentMode = AppMode.client;

      // Small delay to ensure Firestore propagation
      await Future.delayed(const Duration(milliseconds: 300));

      print('✅ Switch to client mode complete');
      return true;

    } catch (e) {
      print('❌ Error switching to client mode: $e');
      _errorMessage = 'Failed to switch to client mode: ${e.toString()}';
      return false;
    } finally {
      // IMPORTANT: Reset flags in correct order
      _isLoading = false;

      // Wait a moment before allowing Firestore updates again
      await Future.delayed(const Duration(milliseconds: 100));
      _isSwitching = false;

      notifyListeners();
      print('🏁 Mode switch complete, flags reset');
    }
  }

  Future<void> _createCreatorProfile(
      String uid,
      DocumentReference userRef,
      DocumentReference creatorRef,
      ) async {
    final userDoc = await userRef.get();
    final userData = userDoc.data() as Map<String, dynamic>?;

    final firstName = userData?['firstName'] ?? '';
    final lastName = userData?['lastName'] ?? '';
    final fullName = '$firstName $lastName'.trim();

    await creatorRef.set({
      'uid': uid,
      'displayName': fullName,
      'bio': '',
      'profileImage': null,
      'skills': [],
      'categories': [],
      'portfolio': [],
      'rates': {
        'hourly': 0.0,
        'fixed': 0.0,
      },
      'availability': 'available',
      'rating': 0.0,
      'totalJobs': 0,
      'completedJobs': 0,
      'totalEarnings': 0.0,
      'isActive': true,
      'isVerified': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _createClientProfile(
      String uid,
      DocumentReference clientRef,
      ) async {
    await clientRef.set({
      'uid': uid,
      'preferences': {},
      'savedCreators': [],
      'activeProjects': [],
      'isActive': true,
      'location': 'Accra, Ghana',
      'activeOrders': 0,
      'completedOrders': 0,
      'totalSpent': 0.0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> toggleMode() async {
    if (_currentMode == AppMode.client) {
      return await switchToCreatorMode();
    } else {
      return await switchToClientMode();
    }
  }

  void resetToClientMode() {
    _currentMode = AppMode.client;
    _activeRoles = ['client'];
    _isSwitching = false;
    notifyListeners();
  }

  void onUserLogout() {
    _userDocSubscription?.cancel();
    _currentMode = AppMode.client;
    _activeRoles = ['client'];
    _errorMessage = null;
    _isSwitching = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _userDocSubscription?.cancel();
    super.dispose();
  }
}