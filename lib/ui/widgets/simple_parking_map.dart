// lib/ui/widgets/simple_parking_map.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_location_controller.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_slot_controller.dart';

class SimpleParkingMapCard extends StatelessWidget {
  SimpleParkingMapCard({super.key});

  final ParkingLocationController pc = Get.find();

  ParkingSlotController? _slotController() {
    try {
      return Get.find<ParkingSlotController>();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!pc.isParked.value) return _notParkedView();
      return _parkedView();
    });
  }

  // ==================== BELUM PARKIR ====================
  Widget _notParkedView() {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: const [
          Icon(Icons.map_rounded, size: 60, color: Color(0xFF4E71FF)),
          SizedBox(height: 16),
          Text(
            "Anda Belum Memarkirkan Motor",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ==================== SUDAH PARKIR ====================
  Widget _parkedView() {
    final String rowIndex = pc.baris.value; // "0" - "9"

    final int userSlot =
        int.tryParse(pc.slot.value.replaceAll(RegExp(r'[^0-9]'), '')) ?? -1;

    final slotController = _slotController();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: _lokasiBlock(rowIndex, userSlot, slotController),
    );
  }

  // ==================== BLOK LOKASI (SATU BARIS) ====================
  Widget _lokasiBlock(
    String rowIndex,
    int userSlot,
    ParkingSlotController? slotController,
  ) {
    // slot kosong nyata
    final List<Map<String, dynamic>> emptySlots =
        slotController?.slotData.where((s) => s['row'] == rowIndex).toList() ??
        [];

    // slot terisi dari motor_id
    final Set<int> occupiedSlots =
        slotController?.getFinalOccupiedSlots(rowIndex) ?? {};

    // kumpulkan semua slot yang relevan
    final Set<int> slotNumbers = {};

    // slot kosong
    for (final s in emptySlots) {
      final n = int.tryParse(s['slot_label']) ?? -1;
      if (n > 0) slotNumbers.add(n);
    }

    // slot terisi
    slotNumbers.addAll(occupiedSlots);

    // slot user
    if (userSlot > 0) slotNumbers.add(userSlot);

    final List<int> slots = slotNumbers.toList()..sort();

    // group max 5 kolom
    final List<List<int>> grouped = [];
    for (int i = 0; i < slots.length; i += 5) {
      grouped.add(
        slots.sublist(i, i + 5 > slots.length ? slots.length : i + 5),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${pc.parkir.value} • Baris $rowIndex",
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),

        ...grouped.map((rowSlots) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: rowSlots.map((slotNum) {
                final bool isUser = slotNum == userSlot;
                final bool isOccupied = occupiedSlots.contains(slotNum);
                final bool isEmpty = emptySlots.any(
                  (s) => s['slot_label'] == slotNum.toString(),
                );

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: 55,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blue
                            : isOccupied
                            ? Colors.red
                            : isEmpty
                            ? Colors.green
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        border: isUser
                            ? Border.all(color: Colors.blueAccent, width: 4)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "R$rowIndex",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "Slot $slotNum",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}
