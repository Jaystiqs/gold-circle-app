import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goldcircle/pages/client/client_account_settings.dart';
import 'package:provider/provider.dart';
import 'package:goldcircle/auth/auth_wrapper.dart';
import 'package:goldcircle/auth/email_verification.dart';
import 'package:goldcircle/auth/consolidated_auth.dart';
import 'package:goldcircle/providers/user_provider.dart'; // Import your UserProvider
import 'app_styles.dart';
import 'bottom_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Enable Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Enable Realtime Database persistence
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  runApp(const GoldCircleApp());
}

class GoldCircleApp extends StatelessWidget {
  const GoldCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // User Provider - manages all user state and data
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        // Add other providers here as needed
        // ChangeNotifierProvider(create: (_) => OtherProvider()),
      ],
      child: MaterialApp(
        title: 'Gold Circle',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppStyles.goldPrimary,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: AppStyles.fontFamily,
          appBarTheme: AppBarTheme(
            backgroundColor: AppStyles.backgroundWhite,
            elevation: 0,
            iconTheme: IconThemeData(color: AppStyles.textPrimary),
            titleTextStyle: AppStyles.h5.copyWith(
              color: AppStyles.textPrimary,
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarDividerColor: Colors.transparent,
            ),
          ),
          textTheme: const TextTheme(
            displayLarge: AppStyles.h1,
            displayMedium: AppStyles.h2,
            displaySmall: AppStyles.h3,
            headlineLarge: AppStyles.h4,
            headlineMedium: AppStyles.h5,
            headlineSmall: AppStyles.h6,
            bodyLarge: AppStyles.bodyLarge,
            bodyMedium: AppStyles.bodyMedium,
            bodySmall: AppStyles.bodySmall,
            labelLarge: AppStyles.button,
            labelMedium: AppStyles.buttonSmall,
            labelSmall: AppStyles.caption,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.goldPrimary,
              foregroundColor: AppStyles.textWhite,
              textStyle: AppStyles.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppStyles.goldPrimary,
              side: BorderSide(color: AppStyles.goldPrimary),
              textStyle: AppStyles.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppStyles.backgroundGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: AppStyles.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: AppStyles.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: AppStyles.goldPrimary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            hintStyle: AppStyles.bodyLarge.copyWith(color: AppStyles.textLight),
          ),
        ),
        // Define named routes
        initialRoute: '/',
        routes: {
          '/': (context) => const SystemUIWrapper(child: AuthWrapper()),
          '/home': (context) => const SystemUIWrapper(child: AuthWrapper()),
          '/auth': (context) => const ConsolidatedAuthPage(),
          '/email-verification': (context) => const EmailVerificationPage(),
          '/account-settings': (context) => const AccountSettingsPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Updated SystemUIWrapper to accept a child widget
class SystemUIWrapper extends StatelessWidget {
  final Widget? child;

  const SystemUIWrapper({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: child ?? const BottomNavigation(),
    );
  }
}