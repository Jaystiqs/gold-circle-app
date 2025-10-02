import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

// User model to represent the complete user data
class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final DateTime? birthDate;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Add any additional fields you need
  final String? profileImageUrl;
  final String? phoneNumber;
  final Map<String, dynamic>? preferences;
  final List<String>? skills;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.birthDate,
    required this.emailVerified,
    this.createdAt,
    this.updatedAt,
    this.profileImageUrl,
    this.phoneNumber,
    this.preferences,
    this.skills,
  });

  // Create UserModel from Firebase Auth User (fallback when Firestore data unavailable)
  factory UserModel.fromFirebaseUser(User user) {
    final displayName = user.displayName ?? '';
    final nameParts = displayName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      firstName: firstName,
      lastName: lastName,
      fullName: displayName,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
      profileImageUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  // Create UserModel from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      fullName: data['fullName'] ?? '',
      birthDate: data['birthDate'] != null
          ? (data['birthDate'] as Timestamp).toDate()
          : null,
      emailVerified: data['emailVerified'] ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      profileImageUrl: data['profileImageUrl'],
      phoneNumber: data['phoneNumber'],
      preferences: data['preferences'] != null
          ? Map<String, dynamic>.from(data['preferences'])
          : null,
      skills: data['skills'] != null
          ? List<String>.from(data['skills'])
          : null,
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'birthDate': birthDate != null ? Timestamp.fromDate(birthDate!) : null,
      'emailVerified': emailVerified,
      'updatedAt': FieldValue.serverTimestamp(),
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'preferences': preferences,
      'skills': skills,
    };
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? fullName,
    DateTime? birthDate,
    bool? emailVerified,
    String? profileImageUrl,
    String? phoneNumber,
    Map<String, dynamic>? preferences,
    List<String>? skills,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      preferences: preferences ?? this.preferences,
      skills: skills ?? this.skills,
    );
  }
}

enum UserState {
  loading,
  authenticated,
  unauthenticated,
  unverified,
  error,
}

class UserProvider extends ChangeNotifier {
  // Private fields
  User? _firebaseUser;
  UserModel? _userModel;
  UserState _userState = UserState.loading;
  String? _errorMessage;
  bool _hasAttemptedDocumentCreation = false;

  // Stream subscriptions
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<DocumentSnapshot>? _userDocSubscription;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  UserState get userState => _userState;
  String? get errorMessage => _errorMessage;

  // Convenience getters
  bool get isLoggedIn => _firebaseUser != null && _firebaseUser!.emailVerified;
  bool get isEmailVerified => _firebaseUser?.emailVerified ?? false;
  String get displayName => _userModel?.fullName ?? _firebaseUser?.displayName ?? 'User';
  String get email => _userModel?.email ?? _firebaseUser?.email ?? '';

  UserProvider() {
    _initializeUser();
  }

  void _initializeUser() {
    print('🚀 UserProvider: Initializing user state management');

    // Listen to Firebase Auth changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen(
      _handleAuthStateChange,
      onError: (error) {
        print('❌ Auth state change error: $error');
        _setErrorState('Authentication error: ${error.toString()}');
      },
    );
  }

  Future<void> _handleAuthStateChange(User? user) async {
    print('🔄 UserProvider: Auth state changed - User: ${user?.uid}');

    _firebaseUser = user;
    _hasAttemptedDocumentCreation = false; // Reset flag for new user

    // Cancel existing user document subscription
    await _userDocSubscription?.cancel();
    _userDocSubscription = null;

    if (user == null) {
      // User signed out
      _userModel = null;
      _userState = UserState.unauthenticated;
      _errorMessage = null;
      print('👋 User signed out');
    } else if (!user.emailVerified) {
      // User not verified
      _userModel = UserModel.fromFirebaseUser(user); // Use Firebase data as fallback
      _userState = UserState.unverified;
      _errorMessage = null;
      print('📧 User not verified: ${user.email}');
    } else {
      // User is authenticated and verified
      _userState = UserState.authenticated;
      _errorMessage = null;

      // Start with Firebase user data as fallback
      _userModel = UserModel.fromFirebaseUser(user);

      // Try to get enhanced data from Firestore
      await _setupUserDocumentListener(user.uid);
    }

    notifyListeners();
  }

  Future<void> _setupUserDocumentListener(String uid) async {
    print('📖 UserProvider: Setting up user document listener for: $uid');

    try {
      _userDocSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots()
          .listen(
        _handleUserDocumentChange,
        onError: (error) {
          print('❌ User document stream error: $error');
          // Don't set error state - we have Firebase auth data as fallback
          _handleOfflineMode();
        },
      );
    } catch (e) {
      print('⚠️ Could not set up Firestore listener: $e');
      _handleOfflineMode();
    }
  }

  void _handleUserDocumentChange(DocumentSnapshot doc) {
    print('📄 UserProvider: User document changed - Exists: ${doc.exists}');

    if (doc.exists) {
      try {
        _userModel = UserModel.fromFirestore(doc);
        _userState = UserState.authenticated;
        _errorMessage = null;
        print('✅ User data loaded from Firestore: ${_userModel?.fullName}');
      } catch (e) {
        print('❌ Error parsing user document: $e');
        // Keep using Firebase auth data, don't crash
        print('🔄 Continuing with Firebase auth data as fallback');
      }
    } else {
      // Document doesn't exist for verified user
      print('⚠️ User document not found for verified user');
      _handleMissingDocument();
    }

    notifyListeners();
  }

  void _handleMissingDocument() {
    // Only attempt to create document once per session
    if (!_hasAttemptedDocumentCreation && _firebaseUser != null) {
      _hasAttemptedDocumentCreation = true;
      print('🔧 Attempting to create missing user document...');
      _attemptDocumentCreation();
    } else {
      print('📱 Using Firebase auth data (Firestore document unavailable)');
      // Continue using Firebase auth data - this is perfectly fine
      _userState = UserState.authenticated;
      _errorMessage = null;
    }
  }

  Future<void> _attemptDocumentCreation() async {
    if (_firebaseUser == null) return;

    try {
      print('📝 Creating user document for existing user...');

      final userData = {
        'email': _firebaseUser!.email?.toLowerCase() ?? '',
        'firstName': _userModel?.firstName ?? '',
        'lastName': _userModel?.lastName ?? '',
        'fullName': _userModel?.fullName ?? _firebaseUser!.displayName ?? '',
        'emailVerified': _firebaseUser!.emailVerified,
        'createdAt': _firebaseUser!.metadata.creationTime != null
            ? Timestamp.fromDate(_firebaseUser!.metadata.creationTime!)
            : FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'profileImageUrl': _firebaseUser!.photoURL,
        'phoneNumber': _firebaseUser!.phoneNumber,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseUser!.uid)
          .set(userData, SetOptions(merge: true));

      // Also create email tracking document
      if (_firebaseUser!.email != null) {
        await FirebaseFirestore.instance
            .collection('user_emails')
            .doc(_firebaseUser!.email!.toLowerCase())
            .set({
          'userId': _firebaseUser!.uid,
          'exists': true,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      print('✅ Successfully created missing user document');
    } catch (e) {
      print('⚠️ Could not create user document: $e');
      // This is fine - we'll continue with Firebase auth data
      print('📱 Continuing with Firebase auth data only');
    }
  }

  void _handleOfflineMode() {
    print('📱 Handling offline mode - using cached Firebase auth data');
    _userState = UserState.authenticated; // Keep user logged in
    _errorMessage = null;
    // Keep existing _userModel (from Firebase auth)
  }

  void _setErrorState(String error) {
    // Only set error state for critical auth issues, not Firestore issues
    if (error.contains('Authentication error') || error.contains('Permission denied')) {
      _userState = UserState.error;
      _errorMessage = error;
      print('💥 UserProvider Critical Error: $error');
    } else {
      print('⚠️ UserProvider Warning: $error');
      // Don't set error state for non-critical issues
    }
  }

  // Public methods for updating user data
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? profileImageUrl,
    String? phoneNumber,
  }) async {
    if (_firebaseUser == null || _userModel == null) {
      print('❌ Cannot update profile: User not authenticated');
      return false;
    }

    try {
      print('📝 Updating user profile...');

      final updates = <String, dynamic>{};

      if (firstName != null) updates['firstName'] = firstName;
      if (lastName != null) updates['lastName'] = lastName;
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;

      // Update full name if first or last name changed
      if (firstName != null || lastName != null) {
        final newFirstName = firstName ?? _userModel!.firstName;
        final newLastName = lastName ?? _userModel!.lastName;
        updates['fullName'] = '$newFirstName $newLastName';

        // Also update Firebase Auth display name
        try {
          await _firebaseUser!.updateDisplayName('$newFirstName $newLastName');
        } catch (e) {
          print('⚠️ Could not update Firebase auth display name: $e');
          // Continue anyway
        }
      }

      updates['updatedAt'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseUser!.uid)
          .update(updates);

      print('✅ Profile updated successfully');
      return true;
    } catch (e) {
      print('❌ Error updating profile: $e');

      // Check if it's a network error vs permission error
      if (e.toString().contains('PERMISSION_DENIED')) {
        _setErrorState('Permission denied. Please check your account.');
      } else {
        print('⚠️ Profile update failed, but continuing normally: $e');
        // Don't set error state for network issues
      }

      return false;
    }
  }

  Future<bool> updatePreferences(Map<String, dynamic> preferences) async {
    if (_firebaseUser == null) return false;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseUser!.uid)
          .update({
        'preferences': preferences,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Preferences updated successfully');
      return true;
    } catch (e) {
      print('⚠️ Error updating preferences: $e');
      return false;
    }
  }

  Future<bool> updateSkills(List<String> skills) async {
    if (_firebaseUser == null) return false;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseUser!.uid)
          .update({
        'skills': skills,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Skills updated successfully');
      return true;
    } catch (e) {
      print('⚠️ Error updating skills: $e');
      return false;
    }
  }

  // Method to refresh user data manually
  Future<void> refreshUserData() async {
    if (_firebaseUser == null) return;

    print('🔄 Manually refreshing user data...');

    try {
      // Reload Firebase user
      await _firebaseUser!.reload();

      // Reset document creation flag to allow retry
      _hasAttemptedDocumentCreation = false;

      // The document listener will automatically handle Firestore updates
      print('✅ User data refresh initiated');
    } catch (e) {
      print('⚠️ Error refreshing user data: $e');
      // Don't set error state for refresh issues
    }
  }

  // Method to sign out
  Future<void> signOut() async {
    print('👋 UserProvider: Signing out user');

    try {
      await FirebaseAuth.instance.signOut();
      // Auth state change will handle cleanup
    } catch (e) {
      print('❌ Error signing out: $e');
      _setErrorState('Failed to sign out: ${e.toString()}');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    print('🧹 UserProvider: Disposing subscriptions');
    _authSubscription?.cancel();
    _userDocSubscription?.cancel();
    super.dispose();
  }
}