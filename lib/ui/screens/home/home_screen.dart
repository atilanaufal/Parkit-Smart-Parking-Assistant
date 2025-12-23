import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_location_controller.dart';
import 'package:parkit_smart_parking_assistant/ui/widgets/simple_parking_map.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_motor_controller.dart';
import 'package:parkit_smart_parking_assistant/ui/widgets/user_motor_section.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_slot_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ParkingLocationController pc = Get.find();
  final UserMotorController motor = Get.find<UserMotorController>();
  final ParkingSlotController slots = Get.find<ParkingSlotController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // ================= CURRENT MOTOR LOCATION =================
            const Text(
              "Lokasi Motor Saat Ini",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            Obx(() {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    if (pc.isParked.value) {
                      _showEndParkingDialog(context);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4E71FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.motorcycle_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pc.parkir.value,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Baris ${pc.baris.value}     Slot ${pc.slot.value}",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        Icon(
                          pc.isParked.value
                              ? Icons.circle_rounded
                              : Icons.circle_outlined,
                          color: pc.isParked.value ? Colors.green : Colors.red,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // ================= SIMPLE PARKING MAP CARD =================
            SimpleParkingMapCard(),
            const SizedBox(height: 20),

            // ================= USER MOTOR =================
            const Text(
              "Motor Anda",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            UserMotorSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // POPUP END PARKING
  void _showEndParkingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text("Akhiri Parkir?"),
        content: const Text(
          "Apakah anda yakin ingin menyudahi penggunaan slot parkir?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              final row = pc.usedRow;
              final spaceId = pc.usedSpaceId;

              if (row != null && spaceId != null) {
                slots.releaseSlot(
                  row: pc.usedRow!,
                  spaceId: pc.usedSpaceId!,
                  wasExhausted: pc.lastSlotWasExhausted,
                );
              }

              pc.clearParking();

              Navigator.pop(context);
            },
            child: const Text(
              "Ya, Akhiri",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
