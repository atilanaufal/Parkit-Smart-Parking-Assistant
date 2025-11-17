import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  RxInt currentIndex = 0.obs;

  final PageController pageController = PageController();

  void changeTab(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
