import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/offer_provider.dart';
import 'screens/offer_list_screen.dart';

void main() {
  runApp(const GoldCircleApp());
}

class GoldCircleApp extends StatelessWidget {
  const GoldCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OfferProvider(),
      child: MaterialApp(
        title: 'Gold Circle',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: const Color(0xFFD4AF37), // Gold color
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFD4AF37),
            primary: const Color(0xFFD4AF37),
            secondary: const Color(0xFFB8860B),
          ),
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.white,
              elevation: 2,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFD4AF37),
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Colors.grey[200],
            labelStyle: const TextStyle(fontSize: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        home: const GoldCircleHome(),
      ),
    );
  }
}

class GoldCircleHome extends StatelessWidget {
  const GoldCircleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const OfferListScreen();
  }
}
