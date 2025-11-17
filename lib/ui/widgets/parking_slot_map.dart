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
    final slotData = slots.slotData;

    // FILTER
    List<Map<String, dynamic>> filtered = List.from(slotData);

    if (selectedParkir != "Parkir - 1") {
      filtered = filtered
          .where(
            (d) =>
                d["slot"] == selectedParkir.replaceAll("Parkir - ", "Slot - "),
          )
          .toList();
    }

    if (selectedBaris != "Baris - All") {
      final bar = selectedBaris.replaceAll("Baris - ", "");

      if (bar == "Bonus") {
        // Khusus Bonus → ambil hanya id = Bonus
        filtered = filtered.where((d) => d["id"] == "Bonus").toList();
      } else {
        // Baris A–F → id harus huruf + angka, bukan Bonus
        filtered = filtered.where((d) {
          final id = d["id"].toString();
          return id.startsWith(bar) && RegExp(r'^[A-F][0-9]+$').hasMatch(id);
        }).toList();
      }
    }

    const perPage = 8;
    final totalPages = (filtered.length / perPage).ceil();

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
          // ========== FILTER ROW ==========
          Row(
            children: [
              Expanded(
                child: _dropdown(
                  value: selectedParkir,
                  items: ["Parkir - 1", "Parkir - 2", "Parkir - 3"],
                  onChanged: (v) => setState(() => selectedParkir = v!),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: _dropdown(
                  value: selectedBaris,
                  items: [
                    "Baris - All",
                    "Baris - A",
                    "Baris - B",
                    "Baris - C",
                    "Baris - D",
                    "Baris - E",
                    "Baris - F",
                    "Baris - Bonus",
                  ],
                  onChanged: (v) => setState(() => selectedBaris = v!),
                ),
              ),

              const SizedBox(width: 10),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E71FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ========== PAGEVIEW (SCROLL HORIZONTAL) ==========
          SizedBox(
            height: 190,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (_) {},

              child: PageView.builder(
                controller: pageController,
                itemCount: totalPages,
                scrollDirection: Axis.horizontal,

                itemBuilder: (context, pageIndex) {
                  int start = pageIndex * perPage;
                  int end = (start + perPage).clamp(0, filtered.length);

                  final slotsPage = filtered.sublist(start, end);

                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: .9,
                        ),
                    itemCount: slotsPage.length,
                    itemBuilder: (context, i) {
                      final s = slotsPage[i];
                      return _slotCard(
                        id: s["id"],
                        slot: s["slot"],
                        occupied: s["occupied"],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== SLOT CARD ==========
  Widget _slotCard({
    required String id,
    required String slot,
    required bool occupied,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        onTap: () {
          if (!occupied) {
            _showConfirmParkingDialog(id, slot);
          }
        },

        child: Container(
          decoration: BoxDecoration(
            color: occupied ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  occupied
                      ? Icons.motorcycle_rounded
                      : Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                const SizedBox(height: 6),
                Text(
                  id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  slot,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== POPUP KONFIRMASI ==========
  void _showConfirmParkingDialog(String id, String slot) {
    final ParkingLocationController pc = Get.find();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text("Konfirmasi Lokasi"),
        content: Text(
          "Parkir: $selectedParkir\n"
          "Baris: $id\n" // <--- id langsung, contoh A2
          "Slot:  $slot\n", // <--- slot langsung, contoh Slot - 5
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              pc.setParking(
                selectedParkir, // Parkir - 1 / 2 / 3
                id, // A1 / A2 / B1 / B2 (STRING UTUH)
                slot, // Slot - 1 / Slot - 5
              );

              Navigator.pop(context);
            },
            child: const Text(
              "Ya, Parkir",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ========== DROPDOWN UI ==========
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
        border: Border.all(color: Colors.black12),
      ),
      child: DropdownButton(
        value: value,
        underline: const SizedBox(),
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
