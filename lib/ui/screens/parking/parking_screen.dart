// lib/ui/screens/parking/parking_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_slot_controller.dart';
import 'package:parkit_smart_parking_assistant/ui/widgets/add_motor_warning.dart';
import 'package:parkit_smart_parking_assistant/ui/widgets/live_feed_widget.dart';
import 'package:parkit_smart_parking_assistant/ui/widgets/parking_slot_map.dart';
import 'package:parkit_smart_parking_assistant/ui/widgets/recommendation_carousel.dart';

class ParkingScreen extends StatelessWidget {
  const ParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ParkingSlotController slotController = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// =============================
              /// WARNING
              /// =============================
              AddMotorWarning(),

              const SizedBox(height: 16),

              /// =============================
              /// STATUS SLOT
              /// =============================
              const Text(
                "Status Slot",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _stat(
                      icon: Icons.grid_view_rounded,
                      color: Colors.blue,
                      label: "Total",
                      value:
                          (slotController.totalMotor.value +
                                  slotController.totalEmpty.value)
                              .toString(),
                      bg: const Color(0xFFEAF1FF),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _stat(
                      icon: Icons.motorcycle_rounded,
                      color: Colors.red,
                      label: "Terisi",
                      value: slotController.totalMotor.value.toString(),
                      bg: const Color(0xFFFFEAEA),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _stat(
                      icon: Icons.check_circle_rounded,
                      color: Colors.green,
                      label: "Kosong",
                      value: slotController.totalEmpty.value.toString(),
                      bg: const Color(0xFFE9FFF0),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// =============================
              /// SLOT MAP
              /// =============================
              const ParkingSlotMap(),

              const SizedBox(height: 24),

              /// =============================
              /// LIVE FEED
              /// =============================
              const Text(
                "Deteksi Real-Time",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),

              LiveFeedWidget(
                loading: slotController.isLoading.value,
                sessionId: slotController.sessionId.value,
              ),

              /// =============================
              /// REKOMENDASI SLOT
              /// =============================
              const SizedBox(height: 24),
              const Text(
                "Rekomendasi Slot",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              RecommendationCarousel(
                items: slotController.getRecommendedSlots(limit: 5),
                onTap: (slot) {
                  Get.snackbar(
                    "Rekomendasi",
                    "Fokus ke ${slot.slot}",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.blue.shade50,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// =============================
  /// STAT CARD
  /// =============================
  Widget _stat({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
