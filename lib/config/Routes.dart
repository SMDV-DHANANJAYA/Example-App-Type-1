import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../pages/other/LocationUsersPage.dart';
import '../pages/HomePage.dart';
import '../pages/LoginPage.dart';
import '../pages/OfflinePage.dart';

class Routes{
  static List<GetPage> routes = [
    GetPage(
        name: '/loginPage',
        page: () => LoginPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOutQuad
    ),
    GetPage(
        name: '/homePage',
        page: () => HomePage(),
        transition: Transition.fade,
        transitionDuration: const Duration(seconds: 1),
        curve: Curves.easeInOutQuad
    ),
    GetPage(
        name: '/locationUsersPage',
        page: () => LocationUsersPage(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut
    ),
    GetPage(
        name: '/offlinePage',
        page: () => OfflinePage(),
        transition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuad
    ),
  ];
}