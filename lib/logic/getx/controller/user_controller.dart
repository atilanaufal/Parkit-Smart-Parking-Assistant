import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_motor_controller.dart';
import 'package:parkit_smart_parking_assistant/services/user_service.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;

  RxString userId = ''.obs;
  RxString username = ''.obs;
  RxString email = ''.obs;
  RxString motorUserId = ''.obs;
  bool get isLoggedIn => userId.isNotEmpty;

  // ================= REGISTER =================
  Future<void> register({
    required String usernameInput,
    required String emailInput,
    required String passwordInput,
  }) async {
    try {
      isLoading.value = true;

      final res = await UserService.register(
        username: usernameInput,
        email: emailInput,
        password: passwordInput,
      );

      // ================= IMPORTANT =================
      // Backend REGISTER belum tentu balikin user lengkap
      // Jadi JANGAN langsung assign String dari response

      if (res['user_id'] != null) {
        userId.value = res['user_id'].toString();
      }

      if (res['username'] != null) {
        username.value = res['username'].toString();
      } else {
        username.value = usernameInput; // fallback
      }

      if (res['email'] != null) {
        email.value = res['email'].toString();
      } else {
        email.value = emailInput; // fallback
      }
    } catch (e) {
      Get.snackbar("Register Gagal", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= LOGIN (BY USER ID) =================
  Future<void> login(String id) async {
    try {
      isLoading.value = true;

      final res = await UserService.getUser(id);

      final data = res['data'] ?? res;
      if (data is! Map) {
        throw Exception("User tidak ditemukan");
      }

      // ✅ SET USER STATE DULU
      userId.value = (data['user_id'] ?? data['id']).toString();
      username.value = (data['username'] ?? 'User').toString();
      email.value = (data['email'] ?? '').toString();

      // 🔥 BARU FETCH MOTOR
      final motor = Get.find<UserMotorController>();
      await motor.fetchMotorsByUser(userId.value);
      debugPrint('RAW BODY => ${userId.value}');
    } catch (e) {
      Get.snackbar("Login Gagal", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    userId.value = '';
    username.value = '';
    email.value = '';
  }
}
