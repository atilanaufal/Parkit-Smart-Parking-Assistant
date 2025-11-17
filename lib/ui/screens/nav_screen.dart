import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../logic/getx/controller/nav_controller.dart';

// Screens
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/parking/parking_screen.dart';
import '../../ui/screens/misc/misc_screen.dart';

class NavScreen extends StatelessWidget {
  NavScreen({super.key});

  final NavController nav = Get.put(NavController());

  final List<Widget> pages = [HomeScreen(), ParkingScreen(), MiscScreen()];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF4E71FF),
          elevation: 0,
          toolbarHeight: 70,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(
                width: 35,
                height: 35,
                child: Image.asset(
                  "assets/icons/parkit4.png",
                  fit: BoxFit.cover, // atau BoxFit.contain sesuai kebutuhan
                ),
              ),

              Text(
                "arkIt",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
        body: PageView(
          controller: nav.pageController,
          onPageChanged: nav.onPageChanged,
          children: pages,
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: nav.currentIndex.value,
          onTap: nav.changeTab,
          selectedItemColor: const Color(0xFF4E71FF),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility_rounded),
              label: "Parking",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps_rounded),
              label: "Misc",
            ),
          ],
        ),
      );
    });
  }
}
