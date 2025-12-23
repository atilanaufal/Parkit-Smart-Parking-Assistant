import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_controller.dart';
import 'package:parkit_smart_parking_assistant/services/motor_service.dart';

class UserMotorController extends GetxController {
  /// List motor milik user (maksimal 5)
  final RxList<Map<String, dynamic>> motors = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;

  bool get isFull => motors.length >= 5;
  @override
  void onInit() {
    final user = Get.find<UserController>();
    fetchMotorsByUser(user.userId.value);
    super.onInit();
  }

  // ===========================================================
  // FETCH MOTOR BY USER
  // ===========================================================
  Future<void> fetchMotorsByUser(String userId) async {
    if (userId.isEmpty) return;

    try {
      isLoading.value = true;

      final data = await MotorService.getMotorByUser(userId);

      motors.assignAll(
        data.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================
  // ADD MOTOR
  // ===========================================================
  Future<void> addMotor({
    required String userId,
    required String ownerName,
    required String email,
    required String brand,
    required String model,
    required String color,
    required int widthCm,
  }) async {
    if (isFull) {
      Get.snackbar('Info', 'Maksimal 5 motor');
      return;
    }

    try {
      isLoading.value = true;

      final createdMotor = await MotorService.registerMotor(
        userId: userId,
        ownerName: ownerName,
        email: email,
        brand: brand,
        model: model,
        color: color,
        widthCm: widthCm,
      );

      // ✅ LANGSUNG TAMBAHKAN KE LIST LOKAL
      motors.insert(0, Map<String, dynamic>.from(createdMotor));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================
  // UPDATE MOTOR
  // ===========================================================
  Future<void> updateMotor({
    required String code,
    required String brand,
    required String model,
    required String color,
    required int widthCm,
  }) async {
    try {
      isLoading.value = true;

      final updated = await MotorService.updateMyMotor(
        code: code,
        brand: brand,
        model: model,
        color: color,
        widthCm: widthCm,
      );

      // ===============================
      // 🔥 UPDATE LOKAL, BUKAN FETCH
      // ===============================
      final index = motors.indexWhere((m) => m['code'] == code);
      if (index != -1) {
        motors[index] = {...motors[index], ...updated};
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================
  // DELETE MOTOR
  // ===========================================================
  Future<void> deleteMotor(String code) async {
    try {
      isLoading.value = true;

      await MotorService.deleteMotor(code);

      // 🔥 HAPUS LANGSUNG DARI LIST LOKAL
      motors.removeWhere((m) => m['code'] == code);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================
  // CLEAR STATE (OPSIONAL, SAAT LOGOUT)
  // ===========================================================
  void clear() {
    motors.clear();
  }
}
