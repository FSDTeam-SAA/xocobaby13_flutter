import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/feature/chat/presentation/screen/chat_list_screen.dart';
import 'package:xocobaby13/feature/home/presentation/screen/spot_owner_home_screen.dart';
import 'package:xocobaby13/feature/navigation/controller/navigation_controller.dart';
import 'package:xocobaby13/feature/navigation/presentation/widgets/bottom_navigation_bar_for_spot_owner.dart';
import 'package:xocobaby13/feature/profile/controller/profile_controller.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/spot_owner_profile_screen.dart';
import 'package:xocobaby13/feature/profile/presentation/widgets/spot_owner_profile_style.dart';
import 'package:xocobaby13/feature/spot_owner/presentation/screen/spot_owner_events_screen.dart';

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
              colors: <Color>[
                SpotOwnerProfilePalette.backgroundTop,
                SpotOwnerProfilePalette.backgroundBottom,
              ],
            ),
          ),
          child: IndexedStack(
            index: navigationController.selectedTabIndex.value,
            children: const <Widget>[
              SpotOwnerHomeScreen(),
              SpotOwnerEventsScreen(),
              ChatListScreen(
                backgroundColor: Colors.transparent,
                safeAreaBottom: false,
              ),
              SpotOwnerProfileScreen(),
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
