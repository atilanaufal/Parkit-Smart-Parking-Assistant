import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_motor_controller.dart';

class AddMotorWarning extends StatelessWidget {
  AddMotorWarning({super.key});

  final UserMotorController motor = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Jika user sudah punya motor → Jangan tampilkan banner
      if (motor.motors.isNotEmpty) return const SizedBox.shrink();

      // Jika belum ada motor → tampilkan banner
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0x33FF9800), // oranye transparan
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_rounded, color: Colors.orange, size: 24),
            const SizedBox(width: 10),

            Expanded(
              child: Text(
                "Tambahkan motor untuk mendapatkan pengalaman parkir yang maksimal.",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
