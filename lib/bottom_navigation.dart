import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goldcircle/pages/client/orders.dart';
import 'package:goldcircle/pages/provider/provider_self_profile.dart';
import 'package:goldcircle/pages/shared/messages.dart';
import 'package:goldcircle/pages/client/client_self_profile.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'app_styles.dart';
import 'home_page.dart';

class BottomNavigation extends StatefulWidget {
  final VoidCallback? onShowAuth;
  final bool isLoggedIn;

  const BottomNavigation({
    super.key,
    this.onShowAuth,
    this.isLoggedIn = false,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    const HomePage(),
    WishlistsPage(
      isLoggedIn: widget.isLoggedIn,
      onShowAuth: widget.onShowAuth,
    ),
    // BookingsPage(
    //   isLoggedIn: widget.isLoggedIn,
    //   onShowAuth: widget.onShowAuth,
    // ),
    const OrdersPage(),
    const MessagesPage(),
    const ClientProfilePage(),
    // MessagesPage(
    //   isLoggedIn: widget.isLoggedIn,
    //   onShowAuth: widget.onShowAuth,
    // ),
    // ProfilePage(
    //   isLoggedIn: widget.isLoggedIn,
    //   onShowAuth: widget.onShowAuth,
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppStyles.backgroundWhite,
          border: Border(
            top: BorderSide(
              color: AppStyles.borderLight,
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppStyles.goldPrimary,
            unselectedItemColor: AppStyles.textPrimary,
            selectedLabelStyle: AppStyles.caption.copyWith(
              fontWeight: AppStyles.semiBold,
              color: AppStyles.goldPrimary,
            ),
            unselectedLabelStyle: AppStyles.caption,
            iconSize: 24.0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.magnifyingGlass()),
                activeIcon: Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold)),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.pushPin()),
                activeIcon: Icon(PhosphorIcons.pushPin(PhosphorIconsStyle.bold)),
                label: 'Wishlists',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.clipboardText()),
                activeIcon: Icon(PhosphorIcons.clipboardText(PhosphorIconsStyle.bold)),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.chatCircle()),
                activeIcon: Icon(PhosphorIcons.chatCircle(PhosphorIconsStyle.bold)),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Icon(PhosphorIcons.user()),
                activeIcon: Icon(PhosphorIcons.user(PhosphorIconsStyle.bold)),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Updated pages with auth awareness
class WishlistsPage extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback? onShowAuth;

  const WishlistsPage({
    super.key,
    required this.isLoggedIn,
    this.onShowAuth,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return _buildLoginPrompt(
        context,
        icon: PhosphorIcons.heart(),
        title: 'Log in to view wishlists',
        subtitle: 'You can create, view, and edit wishlists once you\'ve logged in.',
        onLogin: onShowAuth,
      );
    }

    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      appBar: AppBar(
        title: Text('Wishlists', style: AppStyles.h5),
        backgroundColor: AppStyles.backgroundWhite,
        elevation: 0,
        foregroundColor: AppStyles.textPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.heart(),
              size: 64,
              color: AppStyles.textLight,
            ),
            const SizedBox(height: 16.0),
            Text(
              'No wishlists yet',
              style: AppStyles.h4.copyWith(color: AppStyles.textSecondary),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Start exploring to add favorites to your wishlists',
              style: AppStyles.bodyMedium.copyWith(color: AppStyles.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BookingsPage extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback? onShowAuth;

  const BookingsPage({
    super.key,
    required this.isLoggedIn,
    this.onShowAuth,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return _buildLoginPrompt(
        context,
        icon: PhosphorIcons.airplane(),
        title: 'Log in to view trips',
        subtitle: 'You can view your reservations and booking details once you\'ve logged in.',
        onLogin: onShowAuth,
      );
    }

    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      appBar: AppBar(
        title: Text('Trips', style: AppStyles.h5),
        backgroundColor: AppStyles.backgroundWhite,
        elevation: 0,
        foregroundColor: AppStyles.textPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.airplane(),
              size: 64,
              color: AppStyles.textLight,
            ),
            const SizedBox(height: 16.0),
            Text(
              'No trips yet',
              style: AppStyles.h4.copyWith(color: AppStyles.textSecondary),
            ),
            const SizedBox(height: 8.0),
            Text(
              'When you book a trip, you\'ll find your reservations here',
              style: AppStyles.bodyMedium.copyWith(color: AppStyles.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLoginPrompt(
    BuildContext context, {
      required IconData icon,
      required String title,
      required String subtitle,
      VoidCallback? onLogin,
    }) {
  return Scaffold(
    backgroundColor: AppStyles.backgroundWhite,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppStyles.textLight,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppStyles.h4.copyWith(color: AppStyles.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: AppStyles.bodyMedium.copyWith(color: AppStyles.textLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.goldPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Log in',
                  style: AppStyles.button.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Allow browsing without login - do nothing
              },
              child: Text(
                'Not now',
                style: AppStyles.bodyMedium.copyWith(
                  color: AppStyles.textLight,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}