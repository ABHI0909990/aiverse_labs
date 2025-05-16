import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../FavoritesScreen/FavoritesScreenWrapper.dart';
import '../HomeScreen/HomeScreenController.dart';
import '../HomeScreen/HomeScreenWrapper.dart';
import '../ProfileScreen/ProfileScreenWrapper.dart';
import '../SearchScreen/SearchScreenWrapper.dart';
import 'CustomNavBar.dart';

class Navbarwrapper extends StatefulWidget {
  const Navbarwrapper({super.key});

  @override
  State<Navbarwrapper> createState() => _NavbarwrapperState();
}

class _NavbarwrapperState extends State<Navbarwrapper> {
  final HomeScreenController _homeController = Get.find<HomeScreenController>();

  final List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomNavBar(
          homeScreenController: _homeController,
          child: Obx(() => IndexedStack(
                index: _homeController.selectedIndex.value,
                children: _screens,
              )),
        ));
  }
}
