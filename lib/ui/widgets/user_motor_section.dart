import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_motor_controller.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_controller.dart';
import 'package:parkit_smart_parking_assistant/ui/screens/home/user_motor/add_motor_screen.dart';
import 'package:parkit_smart_parking_assistant/ui/screens/home/user_motor/edit_motor_screen.dart';
import 'user_motor_card.dart';
import 'user_motor_empty.dart';

class UserMotorSection extends StatelessWidget {
  UserMotorSection({super.key});

  final UserMotorController motor = Get.find();
  final UserController user = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ================= LOADING =================
      if (motor.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // ================= BELUM ADA MOTOR =================
      if (motor.motors.isEmpty) {
        return UserMotorEmpty(
          onAdd: () => Get.to(() => const AddMotorScreen()),
        );
      }

      // ================= SUDAH ADA MOTOR =================
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(motor.motors.length, (index) {
            final m = motor.motors[index];

            // ================= SAFE PARSING =================
            final String brand = (m['brand'] ?? '-').toString();
            final String model = (m['model'] ?? 'matic').toString();
            final String color = (m['color'] ?? '').toString();
            final int lengthCm = (m['length_cm'] as num?)?.toInt() ?? 0;
            final int widthCm = (m['width_cm'] as num?)?.toInt() ?? 0;
            final String code = m['code'].toString();

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: UserMotorCard(
                brand: brand,
                model: model,
                lengthCm: lengthCm,
                widthCm: widthCm,
                colorName: color,
                onDelete: () {
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: const Text("Hapus Motor?"),
                      content: const Text("Motor akan dihapus dari akun ini."),
                      actions: [
                        TextButton(
                          onPressed: Get.back,
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Get.back();
                            await motor.deleteMotor(code);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text("Hapus"),
                        ),
                      ],
                    ),
                  );
                },

                onEdit: () {
                  Get.to(() => EditMotorScreen(motorCode: code, motorData: m));
                },
              ),
            );
          }),

          const SizedBox(height: 8),

          // ================= TAMBAH MOTOR =================
          if (!motor.isFull)
            InkWell(
              onTap: () => Get.to(() => const AddMotorScreen()),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0x334E71FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, color: Color(0xFF4E71FF)),
                      SizedBox(width: 6),
                      Text(
                        "Tambah Motor",
                        style: TextStyle(
                          color: Color(0xFF4E71FF),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
