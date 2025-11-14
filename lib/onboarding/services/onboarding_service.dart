import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/onboarding_data.dart';

class OnboardingService {
  static const String _onboardingKey = 'onboarding_data';
  static const String _completedKey = 'onboarding_completed';

  // Save onboarding data locally
  static Future<void> saveOnboardingData(OnboardingData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(data.toJson());
    await prefs.setString(_onboardingKey, jsonData);
  }

  // Get saved onboarding data
  static Future<OnboardingData?> getOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_onboardingKey);

    if (jsonData == null) return null;

    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonData);
      return OnboardingData.fromJson(decoded);
    } catch (e) {
      print('Error decoding onboarding data: $e');
      return null;
    }
  }

  // Mark onboarding as completed
  static Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completedKey, true);
  }

  // Check if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_completedKey) ?? false;
  }

  // Clear onboarding data (for testing)
  static Future<void> clearOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingKey);
    await prefs.remove(_completedKey);
  }

  // Save to Firestore after user signs up
  static Future<void> syncToFirestore(String uid, OnboardingData data) async {
    // TODO: Implement Firestore sync
    // await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(uid)
    //     .update({
    //   'onboardingData': data.toJson(),
    //   'onboardingCompleted': true,
    // });
  }
}