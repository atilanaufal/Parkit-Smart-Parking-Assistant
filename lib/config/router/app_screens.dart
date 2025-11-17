import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/ui/screens/home/user_motor/add_motor_screen.dart';
import '../constant/routes.dart';

import '../../../ui/screens/home/home_screen.dart';
import '../../../ui/screens/parking/parking_screen.dart';
import '../../../ui/screens/misc/misc_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: Routes.parking,
      page: () => const ParkingScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: Routes.misc,
      page: () => MiscScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.addMotor,
      page: () => AddMotorScreen(),
      transition: Transition.rightToLeft,
    ),

    // GetPage(
    //   name: Routes.profile,
    //   page: () => const ProfileScreen(),
    //   transition: Transition.rightToLeft,
    // ),

    // // sub pages
    // GetPage(
    //   name: Routes.slotDetail,
    //   page: () => const SlotDetailScreen(),
    //   transition: Transition.downToUp,
    // ),

    // GetPage(
    //   name: Routes.settings,
    //   page: () => const SettingsScreen(),
    //   transition: Transition.fadeIn,
    // ),
  ];
}
