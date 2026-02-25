import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/feature/home/presentation/screen/spot_owner_home_screen.dart';
import 'package:xocobaby13/feature/navigation/controller/navigation_controller.dart';
import 'package:xocobaby13/feature/navigation/presentation/widgets/bottom_navigation_bar_for_spot_owner.dart';
import 'package:xocobaby13/feature/profile/controller/profile_controller.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/profile_screen.dart';

class SpotOwnerNavigationScreen extends StatelessWidget {
  const SpotOwnerNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        NavigationController.instance();
    ProfileController.instance();

    return Obx(
      () => Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFFD7E7F7), Color(0xFFE2E8F1)],
            ),
          ),
          child: IndexedStack(
            index: navigationController.selectedTabIndex.value,
            children: const <Widget>[
              SpotOwnerHomeScreen(),
              _TabPlaceholder(label: 'Events', icon: CupertinoIcons.calendar),
              _TabPlaceholder(label: 'Chat', icon: CupertinoIcons.chat_bubble),
              ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarForSpotOwner(
          selectedIndex: navigationController.selectedTabIndex.value,
          onItemTapped: navigationController.setTabIndex,
        ),
      ),
    );
  }
}

class _TabPlaceholder extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TabPlaceholder({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 42, color: const Color(0xFF1787CF)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF23303D),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
