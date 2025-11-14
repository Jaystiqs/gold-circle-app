import 'package:flutter/material.dart';
import 'package:goldcircle/pages/client/client_creator_offer.dart';
import 'package:goldcircle/pages/creator/creator_home_page.dart';
import 'package:goldcircle/pages/creator/creator_jobs.dart';
import 'package:goldcircle/pages/creator/creator_offers.dart';
import 'package:goldcircle/pages/creator/creator_self_profile.dart';
import 'package:goldcircle/pages/creator/creator_tasks.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'utils/app_styles.dart';

// Import your provider-specific pages here
// import 'package:goldcircle/pages/provider/provider_home.dart';
// import 'package:goldcircle/pages/provider/creator_jobs.dart';
// import 'package:goldcircle/pages/provider/provider_earnings.dart';
import 'package:goldcircle/pages/shared/messages.dart';
// import 'package:goldcircle/pages/provider/provider_profile.dart';

class CreatorBottomNavigation extends StatefulWidget {
  final VoidCallback? onShowAuth;
  final bool isLoggedIn;

  const CreatorBottomNavigation({
    super.key,
    this.onShowAuth,
    this.isLoggedIn = false,
  });

  @override
  State<CreatorBottomNavigation> createState() => _CreatorBottomNavigationState();
}

class _CreatorBottomNavigationState extends State<CreatorBottomNavigation> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    // Replace these with your actual provider pages
    const ProviderHomePage(),
    const ProviderTasksPage(),
    const CreatorOffersPage(),
    // _ProviderEarningsPlaceholder(),
    const MessagesPage(),
    ProviderSelfProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
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
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppStyles.goldPrimary,
              unselectedItemColor: AppStyles.textLight,
              selectedLabelStyle: AppStyles.caption.copyWith(
                fontWeight: AppStyles.semiBold,
                color: AppStyles.goldPrimary,
              ),
              unselectedLabelStyle: AppStyles.caption,
              iconSize: 24.0,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIcons.house()),
                  activeIcon: Icon(PhosphorIcons.house(PhosphorIconsStyle.bold)),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIcons.clipboard()),
                  activeIcon: Icon(PhosphorIcons.clipboard(PhosphorIconsStyle.bold)),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIcons.tag()),
                  activeIcon: Icon(PhosphorIcons.tag(PhosphorIconsStyle.bold)),
                  label: 'Offers',
                ),
                BottomNavigationBarItem(
                  icon: Icon(PhosphorIcons.chatCircle()),
                  activeIcon: Icon(PhosphorIcons.chatCircle(PhosphorIconsStyle.bold)),
                  label: 'Messages',
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
      ),
    );
  }
}
