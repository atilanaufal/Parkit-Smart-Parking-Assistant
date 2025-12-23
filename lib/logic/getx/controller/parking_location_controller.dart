import 'package:get/get.dart';

class ParkingLocationController extends GetxController {
  RxBool isParked = false.obs;

  RxString parkir = "-".obs;
  RxString baris = "-".obs;
  RxString slot = "-".obs;
  bool lastSlotWasExhausted = false;

  /// 🔥 INFO INTERNAL (JANGAN UNTUK UI)
  String? usedRow;
  String? usedSpaceId;

  void clearParking() {
    isParked.value = false;
    parkir.value = "-";
    baris.value = "-";
    slot.value = "-";

    usedRow = null;
    usedSpaceId = null;
  }

  void setParking(
    String parkirVal,
    String barisVal,
    String slotLabel, {
    required String row,
    required String spaceId,
    required bool slotWasExhausted, // ⬅️ baru
  }) {
    parkir.value = parkirVal;
    baris.value = barisVal;
    slot.value = slotLabel;

    usedRow = row;
    usedSpaceId = spaceId;
    lastSlotWasExhausted = slotWasExhausted;

    isParked.value = true;
  }
}
