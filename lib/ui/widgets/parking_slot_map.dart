// lib/ui/widgets/parking_slot_map.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_location_controller.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/parking_slot_controller.dart';

class ParkingSlotMap extends StatefulWidget {
  const ParkingSlotMap({super.key});

  @override
  State<ParkingSlotMap> createState() => _ParkingSlotMapState();
}

class _ParkingSlotMapState extends State<ParkingSlotMap> {
  String selectedParkir = "Parkir - 1";
  String selectedBaris = "Baris - All";

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final ParkingSlotController slots = Get.find();
    return Obx(() {
      final slotData = slots.slotData;

      List<Map<String, dynamic>> filtered = List.from(slotData);

      if (selectedBaris != "Baris - All") {
        final bar = selectedBaris.replaceAll("Baris - ", "");
        filtered = filtered.where((d) => d["row"] == bar).toList();
      }
      const perPage = 8;
      final totalPages = filtered.isEmpty
          ? 1
          : (filtered.length / perPage).ceil();

      return Container(
        padding: const EdgeInsets.all(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// =============================
            /// FILTER
            /// =============================
            Row(
              children: [
                Expanded(
                  child: _dropdown(
                    value: selectedParkir,
                    items: const ["Parkir - 1"],
                    onChanged: (v) => setState(() => selectedParkir = v!),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _dropdown(
                    value: selectedBaris,
                    items: [
                      "Baris - All",
                      ...slots.availableRows.map((r) => "Baris - $r").toList(),
                    ],
                    onChanged: (v) => setState(() => selectedBaris = v!),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// =============================
            /// SLOT GRID
            /// =============================
            SizedBox(
              height: 190, //190 android
              child: PageView.builder(
                controller: pageController,
                itemCount: totalPages,
                itemBuilder: (context, pageIndex) {
                  final start = pageIndex * perPage;
                  final end = (start + perPage).clamp(0, filtered.length);

                  final pageSlots = filtered.sublist(start, end);

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: .9,
                        ),
                    itemCount: pageSlots.length,
                    itemBuilder: (context, i) {
                      final s = pageSlots[i];
                      final String spaceId = (s['space_id'] ?? '').toString();

                      return _slotCard(
                        row: s['row'],
                        spaceId: spaceId, // RAW
                        slotLabel: s['slot_label'],
                        capacity: s['capacity'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  /// =============================
  /// SLOT CARD
  /// =============================
  Widget _slotCard({
    required String row,
    required String spaceId,
    required String slotLabel,
    required int capacity,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showConfirmParkingDialog(row, spaceId, slotLabel),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(height: 6),
              Text(
                "Baris $row",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                "Slot $slotLabel",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                "Kapasitas $capacity",
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// =============================
  /// CONFIRM
  /// =============================
  void _showConfirmParkingDialog(String row, String spaceId, String slotLabel) {
    final ParkingLocationController pc = Get.find();
    final ParkingSlotController slots = Get.find();

    // =============================
    // USER BELUM PARKIR
    // =============================
    if (!pc.isParked.value) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Konfirmasi Parkir"),
          content: Text(
            "Parkir: $selectedParkir\n"
            "Baris: $row\n"
            "Slot: $slotLabel",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                slots.switchSlot(
                  newRow: row,
                  newSpaceId: spaceId,
                  location: pc,
                );

                pc.setParking(
                  selectedParkir,
                  row,
                  slotLabel,
                  row: row,
                  spaceId: spaceId,
                  slotWasExhausted: pc.lastSlotWasExhausted,
                );

                Navigator.pop(context);
              },
              child: const Text("Ya, Parkir"),
            ),
          ],
        ),
      );
      return;
    }

    // =============================
    // USER SUDAH PARKIR
    // =============================
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ganti Slot Parkir?"),
        content: Text(
          "Anda sudah menggunakan slot parkir.\n\n"
          "Slot saat ini:\n"
          "Baris ${pc.baris.value}, Slot ${pc.slot.value}\n\n"
          "Ganti dengan:\n"
          "Baris $row, Slot $slotLabel ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              slots.switchSlot(newRow: row, newSpaceId: spaceId, location: pc);

              pc.setParking(
                selectedParkir,
                row,
                slotLabel,
                row: row,
                spaceId: spaceId,
                slotWasExhausted: pc.lastSlotWasExhausted,
              );

              Navigator.pop(context);
            },
            child: const Text("Ganti Slot"),
          ),
        ],
      ),
    );
  }

  /// =============================
  /// DROPDOWN
  /// =============================
  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton(
        value: value,
        underline: const SizedBox(),
        isExpanded: true,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
