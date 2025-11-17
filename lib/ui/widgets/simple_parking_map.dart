import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_location_controller.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_slot_controller.dart';

class SimpleParkingMapCard extends StatelessWidget {
  SimpleParkingMapCard({super.key});

  final ParkingLocationController pc = Get.find();

  ParkingSlotController? _maybeSlotController() {
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
    final String baris = pc.baris.value; // ex: A2
    final String huruf = baris[0]; // A

    // Lokasi selalu A1 dan A2 (atau B1, B2; C1, C2)
    final List<String> lokasiList = ["${huruf}2", "${huruf}1"];

    final int userSlot =
        int.tryParse(pc.slot.value.replaceAll("Slot - ", "")) ?? -1;

    final slotController = _maybeSlotController();

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

      // =============== VERTIKAL ================
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lokasiList.map((lokasi) {
          return _lokasiBlock(lokasi, userSlot, slotController);
        }).toList(),
      ),
    );
  }

  // BLOCK: 1 lokasi (A1 / A2)
  Widget _lokasiBlock(
    String lokasi,
    int userSlot,
    ParkingSlotController? slotController,
  ) {
    final bool isUserLokasi = lokasi == pc.baris.value;

    // Ambil slot real untuk lokasi ini
    final List<Map<String, dynamic>> realSlots =
        slotController?.slotData.where((s) => s["id"] == lokasi).toList() ?? [];

    // Urutkan slot berdasarkan angka
    realSlots.sort((a, b) {
      final an = int.tryParse(a["slot"].replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final bn = int.tryParse(b["slot"].replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return an.compareTo(bn);
    });

    // Group slot per 5 kolom MAX
    List<List<Map<String, dynamic>>> grouped = [];
    for (int i = 0; i < realSlots.length; i += 5) {
      grouped.add(
        realSlots.sublist(
          i,
          i + 5 > realSlots.length ? realSlots.length : i + 5,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Text(
          "${pc.parkir.value} • Lokasi $lokasi",
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),

        // TIAP BARIS (MAX 5 slot)
        ...grouped.map((rowSlots) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: rowSlots.map((slotItem) {
                final slotNum =
                    int.tryParse(
                      slotItem["slot"].replaceAll(RegExp(r'[^0-9]'), ''),
                    ) ??
                    -1;

                final bool occupied = slotItem["occupied"] == true;
                final bool highlight = isUserLokasi && slotNum == userSlot;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: 55, // diperkecil supaya 5 kolom muat rapi
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ), // lebih kecil
                      decoration: BoxDecoration(
                        color: occupied ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(
                          10,
                        ), // radius lebih kecil
                        border: highlight
                            ? Border.all(color: Colors.blueAccent, width: 5)
                            : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            lokasi,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11, // lebih kecil
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            slotItem["slot"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10, // lebih kecil
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
