import 'package:flutter/material.dart';

class MiscScreen extends StatelessWidget {
  const MiscScreen({super.key});

  Color get mainColor => const Color(0xFF4E71FF);
  Color get background => const Color(0xFFF4F7FE);
  Color get shadow => const Color.fromRGBO(0, 0, 0, 0.06);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        centerTitle: true,
        title: const Text(
          "Menu Lainnya",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ================= PROFILE CARD ===========================
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Circle avatar
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: const Icon(Icons.person, size: 32, color: Colors.grey),
                ),

                const SizedBox(width: 16),

                // Name + Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Guest",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Halo Pengguna ParkIt!",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),

                const Spacer(),
                const Icon(Icons.more_vert, color: Colors.black54),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ================= PREMIUM BUTTON ===========================
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                "TINGKATKAN KE PREMIUM",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ================= MENU GRID ===========================
          Wrap(
            spacing: 28,
            runSpacing: 28,
            alignment: WrapAlignment.center,
            children: [
              _menuItem(Icons.history_rounded, "Riwayat\nParkir"),
              _menuItem(Icons.bookmark_added_rounded, "Lokasi\nTersimpan"),
              _menuItem(
                Icons.notifications_active_rounded,
                "Notifikasi\nParkir",
              ),
              _menuItem(Icons.color_lens_rounded, "Tema\nAplikasi"),
              _menuItem(Icons.settings_rounded, "Pengaturan"),
              _menuItem(Icons.help_center_rounded, "Bantuan &\nTentang"),
            ],
          ),

          const SizedBox(height: 35),
        ],
      ),
    );
  }

  // ================= MENU ITEM COMPONENT ===========================
  Widget _menuItem(IconData icon, String label) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: mainColor),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
