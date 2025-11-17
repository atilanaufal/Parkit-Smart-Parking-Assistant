import 'package:flutter/material.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_location_controller.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_slot_controller.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_motor_controller.dart';
import 'package:parkit_smart_parking_assistant/ui/screens/nav_screen.dart';
import 'config/theme/app_theme.dart';
import 'package:get/get.dart';

void main() {
  Get.put(UserMotorController());
  Get.put(ParkingLocationController(), permanent: true);
  Get.put(ParkingSlotController(), permanent: true); // <-- WAJIB
  runApp(const ParkItApp());
}

class ParkItApp extends StatelessWidget {
  const ParkItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkIt',
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system, // bisa ThemeMode.light / dark
      home: NavScreen(),
    );
  }
}
