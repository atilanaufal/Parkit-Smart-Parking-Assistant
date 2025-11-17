import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_motor_controller.dart';
import 'package:parkit_smart_parking_assistant/ui/screens/home/user_motor/add_motor_screen.dart';
import 'package:parkit_smart_parking_assistant/ui/screens/home/user_motor/edit_motor_screen.dart';
import 'user_motor_card.dart';
import 'user_motor_empty.dart';

class UserMotorSection extends StatelessWidget {
  UserMotorSection({super.key});

  final UserMotorController motor = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ================= KETIKA BELUM ADA MOTOR =================
      if (motor.motors.isEmpty) {
        return UserMotorEmpty(
          onAdd: () {
            Get.to(() => AddMotorScreen());
          },
        );
      }

      // ================= KETIKA SUDAH ADA MOTOR (1–5) =================
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LIST MOTOR
          ...List.generate(motor.motors.length, (index) {
            final m = motor.motors[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: UserMotorCard(
                motorName: m["name"]!,
                dimension: m["dimension"]!,
                colorName: m["color"]!,
                type: m["type"] ?? "matic_motor",
                onDelete: () {
                  Get.dialog(
                    AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Text("Hapus Motor?"),
                      content: const Text("Motor akan dihapus dari daftar."),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text(
                            "Batal",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            motor.removeMotor(index);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            "Hapus",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onEdit: () {
                  Get.to(() => EditMotorScreen(index: index));
                },
              ),
            );
          }),

          const SizedBox(height: 8),

          // ================= TOMBOL TAMBAH MOTOR (jika belum penuh) =================
          if (!motor.isFull)
            InkWell(
              onTap: () {
                Get.to(() => AddMotorScreen());
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0x334E71FF), // biru transparan
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
