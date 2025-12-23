import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_controller.dart';
import 'package:parkit_smart_parking_assistant/ui/screens/auth/login_screen.dart';
import 'package:parkit_smart_parking_assistant/ui/screens/auth/register_screen.dart';

class MiscScreen extends StatelessWidget {
  const MiscScreen({super.key});

  Color get mainColor => const Color(0xFF4E71FF);
  Color get background => const Color(0xFFF4F7FE);
  Color get shadow => const Color.fromRGBO(0, 0, 0, 0.06);

  @override
  Widget build(BuildContext context) {
    final UserController user = Get.find();

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

      body: Obx(() {
        final bool loggedIn = user.isLoggedIn;

        return ListView(
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
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loggedIn ? user.username.value : "Guest",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        loggedIn ? user.email.value : "Halo Pengguna ParkIt!",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                  const Icon(Icons.more_vert, color: Colors.black54),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ================= LOGIN / REGISTER / LOGOUT BUTTON ===========================
            InkWell(
              onTap: () {
                if (!loggedIn) {
                  Get.bottomSheet(_authBottomSheet(), isScrollControlled: true);
                } else {
                  user.logout();
                }
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: loggedIn ? Colors.red : mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    loggedIn ? "LOGOUT" : "LOGIN / REGISTER",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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
        );
      }),
    );
  }

  // ================= AUTH BOTTOM SHEET ===========================
  Widget _authBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("Login"),
            onTap: () {
              Get.back();
              Get.to(() => LoginScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text("Register"),
            onTap: () {
              Get.back();
              Get.to(() => RegisterScreen());
            },
          ),
        ],
      ),
    );
  }

  // ================= MENU ITEM ===========================
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
