import 'package:flutter/material.dart';
import 'package:parkit_smart_parking_assistant/ui/widgets/add_motor_warning.dart';
import 'package:parkit_smart_parking_assistant/ui/widgets/parking_slot_map.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),

      // =================== BODY SCROLL ===================
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            AddMotorWarning(),
            // ============================================================
            //                     Status SLOT
            // ============================================================
            const Text(
              "Status Slot",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.grid_view_rounded,
                    iconColor: Colors.blue,
                    value: "480",
                    label: "Total",
                    bg: const Color(0xFFEAF1FF),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: _statCard(
                    icon: Icons.motorcycle_rounded,
                    iconColor: Colors.red,
                    value: "320",
                    label: "Terisi",
                    bg: const Color(0xFFFFEAEA),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: _statCard(
                    icon: Icons.check_circle_rounded,
                    iconColor: Colors.green,
                    value: "160",
                    label: "Kosong",
                    bg: const Color(0xFFE9FFF0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ParkingSlotMap(),
            const SizedBox(height: 20),
            const Text(
              "Deteksi Real-Time",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            // ============================================================
            //                 INTERACTIVE PARKING MAP
            // ============================================================
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Icon besar tengah
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/camera.png",
                        width: 65,
                        height: 65,
                        color: Color(0xFF009DFF), // mempertahankan warna biru
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Live Feed Kamera Parkir",
                        style: TextStyle(
                          color: Color.fromARGB(255, 65, 65, 65),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ============================================================
            //             BUTTON "TEMUKAN SLOT TERDEKAT"
            // ============================================================
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Color(0xFF0066FF),
                ),
                child: const Center(
                  child: Text(
                    "Temukan Slot Terdekat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ============================================================
            //                     REKOMENDASI SLOT
            // ============================================================
            const Text(
              "Rekomendasi Slot",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  _slotCard("Slot B-12", "50m", "1 min"),
                  _slotCard("Slot A-08", "85m", "2 min"),
                  _slotCard("Slot C-24", "120m", "3 min"),
                  _slotCard("Slot D-05", "140m", "4 min"),
                  _slotCard("Slot D-05", "140m", "4 min"),
                  _slotCard("Slot D-05", "140m", "4 min"),
                  _slotCard("Slot D-05", "140m", "4 min"),
                  _slotCard("Slot D-05", "140m", "4 min"),
                ],
              ),
            ),
          ],
        ),
      ),

      // =================== BOTTOM NAV ===================
    );
  }

  // ============================================================
  //                      WIDGETS
  // ============================================================

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
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

      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),

              Text(
                label,
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _slotCard(String title, String distance, String time) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
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
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4E71FF),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.black54, size: 16),
              const SizedBox(width: 6),
              Text(distance, style: const TextStyle(color: Colors.black54)),
              const SizedBox(width: 14),
              const Icon(Icons.timer, color: Colors.black54, size: 16),
              const SizedBox(width: 6),
              Text(time, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              print("Navigasi ke $title");
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4E71FF)),
              ),
              child: const Center(
                child: Text(
                  "Navigasi",
                  style: TextStyle(color: Color(0xFF4E71FF)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
