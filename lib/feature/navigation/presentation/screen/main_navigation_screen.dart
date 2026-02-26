import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xocobaby13/feature/chat/presentation/screen/chat_list_screen.dart';
import 'package:xocobaby13/feature/home/presentation/screen/home_screen.dart';
import 'package:xocobaby13/feature/navigation/controller/navigation_controller.dart';
import 'package:xocobaby13/feature/navigation/presentation/widgets/bottom_navigation_bar_for_baby.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/activity_screen.dart';
import 'package:xocobaby13/feature/profile/controller/profile_controller.dart';
import 'package:xocobaby13/feature/profile/presentation/screen/fisherman_profile_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

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
              HomeScreen(),
              ActivityScreen(
                embedded: true,
                showBack: false,
                useDetailsRoute: true,
              ),
              ChatListScreen(),
              FishermanProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarForBaby(
          selectedIndex: navigationController.selectedTabIndex.value,
          onItemTapped: navigationController.setTabIndex,
        ),
      ),
    );
  }
}
