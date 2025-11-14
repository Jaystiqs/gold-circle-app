class OnboardingData {
  final String userType; // 'client' or 'provider'

  // CLIENT-SPECIFIC FIELDS
  // Page 1: Primary task
  String? primaryTask;

  // Page 2: Task preferences
  List<String>? taskPreferences;
  String? taskDetails;

  // Page 4: Priorities
  List<String>? priorities;

  // Page 6: Additional tasks
  List<String>? additionalTasks;

  // PROVIDER-SPECIFIC FIELDS
  // Page 1: Primary service
  String? primaryService;

  // Page 2: Skills/Specializations
  List<String>? skills;

  // Page 3: Experience level
  String? experienceLevel;

  // Page 5: Goal/Motivation
  String? goal;

  // Page 6: Availability/Capacity
  String? availability;

  // Page 8: Additional services
  List<String>? additionalServices;

  // SHARED FIELDS
  // Page 8: Referral source
  String? referralSource;
  String? referralDetails;

  // Page 9: Notifications
  bool notificationsEnabled;

  // Additional metadata
  DateTime? createdAt;
  bool isComplete;

  OnboardingData({
    required this.userType,
    // Client fields
    this.primaryTask,
    this.taskPreferences,
    this.taskDetails,
    this.priorities,
    this.additionalTasks,
    // Provider fields
    this.primaryService,
    this.skills,
    this.experienceLevel,
    this.goal,
    this.availability,
    this.additionalServices,
    // Shared fields
    this.referralSource,
    this.referralDetails,
    this.notificationsEnabled = false,
    this.createdAt,
    this.isComplete = false,
  }) {
    createdAt ??= DateTime.now();
  }

  // Convert to JSON for storage/API
  Map<String, dynamic> toJson() {
    return {
      'userType': userType,
      // Client fields
      'primaryTask': primaryTask,
      'taskPreferences': taskPreferences,
      'taskDetails': taskDetails,
      'priorities': priorities,
      'additionalTasks': additionalTasks,
      // Provider fields
      'primaryService': primaryService,
      'skills': skills,
      'experienceLevel': experienceLevel,
      'goal': goal,
      'availability': availability,
      'additionalServices': additionalServices,
      // Shared fields
      'referralSource': referralSource,
      'referralDetails': referralDetails,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': createdAt?.toIso8601String(),
      'isComplete': isComplete,
    };
  }

  // Create from JSON
  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      userType: json['userType'] as String,
      // Client fields
      primaryTask: json['primaryTask'] as String?,
      taskPreferences: (json['taskPreferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      taskDetails: json['taskDetails'] as String?,
      priorities: (json['priorities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      additionalTasks: (json['additionalTasks'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      // Provider fields
      primaryService: json['primaryService'] as String?,
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      experienceLevel: json['experienceLevel'] as String?,
      goal: json['goal'] as String?,
      availability: json['availability'] as String?,
      additionalServices: (json['additionalServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      // Shared fields
      referralSource: json['referralSource'] as String?,
      referralDetails: json['referralDetails'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      isComplete: json['isComplete'] as bool? ?? false,
    );
  }

  // Copy with method for easy updates
  OnboardingData copyWith({
    String? userType,
    // Client fields
    String? primaryTask,
    List<String>? taskPreferences,
    String? taskDetails,
    List<String>? priorities,
    List<String>? additionalTasks,
    // Provider fields
    String? primaryService,
    List<String>? skills,
    String? experienceLevel,
    String? goal,
    String? availability,
    List<String>? additionalServices,
    // Shared fields
    String? referralSource,
    String? referralDetails,
    bool? notificationsEnabled,
    DateTime? createdAt,
    bool? isComplete,
  }) {
    return OnboardingData(
      userType: userType ?? this.userType,
      // Client fields
      primaryTask: primaryTask ?? this.primaryTask,
      taskPreferences: taskPreferences ?? this.taskPreferences,
      taskDetails: taskDetails ?? this.taskDetails,
      priorities: priorities ?? this.priorities,
      additionalTasks: additionalTasks ?? this.additionalTasks,
      // Provider fields
      primaryService: primaryService ?? this.primaryService,
      skills: skills ?? this.skills,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      goal: goal ?? this.goal,
      availability: availability ?? this.availability,
      additionalServices: additionalServices ?? this.additionalServices,
      // Shared fields
      referralSource: referralSource ?? this.referralSource,
      referralDetails: referralDetails ?? this.referralDetails,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  // Validation method
  bool isValid() {
    if (userType == 'client') {
      return primaryTask != null &&
          primaryTask!.isNotEmpty &&
          (priorities != null && priorities!.isNotEmpty);
    } else if (userType == 'provider') {
      return primaryService != null &&
          primaryService!.isNotEmpty &&
          (skills != null && skills!.isNotEmpty) &&
          experienceLevel != null &&
          experienceLevel!.isNotEmpty;
    }
    return false;
  }

  // Calculate completion percentage
  double getCompletionPercentage() {
    if (userType == 'client') {
      int totalFields = 6;
      int completedFields = 0;

      if (primaryTask != null && primaryTask!.isNotEmpty) completedFields++;
      if (taskPreferences != null && taskPreferences!.isNotEmpty) {
        completedFields++;
      }
      if (priorities != null && priorities!.isNotEmpty) completedFields++;
      if (additionalTasks != null && additionalTasks!.isNotEmpty) {
        completedFields++;
      }
      if (referralSource != null && referralSource!.isNotEmpty) completedFields++;
      if (notificationsEnabled) completedFields++;

      return completedFields / totalFields;
    } else if (userType == 'provider') {
      int totalFields = 7;
      int completedFields = 0;

      if (primaryService != null && primaryService!.isNotEmpty) completedFields++;
      if (skills != null && skills!.isNotEmpty) completedFields++;
      if (experienceLevel != null && experienceLevel!.isNotEmpty) completedFields++;
      if (goal != null && goal!.isNotEmpty) completedFields++;
      if (availability != null && availability!.isNotEmpty) completedFields++;
      if (additionalServices != null && additionalServices!.isNotEmpty) {
        completedFields++;
      }
      if (notificationsEnabled) completedFields++;

      return completedFields / totalFields;
    }
    return 0.0;
  }

  @override
  String toString() {
    if (userType == 'client') {
      return 'OnboardingData(userType: $userType, primaryTask: $primaryTask, '
          'priorities: $priorities, isComplete: $isComplete)';
    } else {
      return 'OnboardingData(userType: $userType, primaryService: $primaryService, '
          'skills: $skills, experienceLevel: $experienceLevel, goal: $goal, '
          'availability: $availability, isComplete: $isComplete)';
    }
  }
}